import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sumgo_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:sumgo_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:sumgo_crawller_flutter/_common/util/AnimationUtil.dart';
import 'package:sumgo_crawller_flutter/repository/RemovalConditionRepository.dart';
import 'package:sumgo_crawller_flutter/util/MyBottomSheetUtil.dart';
import 'package:sumgo_crawller_flutter/util/MyFonts.dart';
import 'package:sumgo_crawller_flutter/util/MyImage.dart';
import 'package:sumgo_crawller_flutter/widget/MyCard.dart';
import 'package:sumgo_crawller_flutter/widget/MyRedButton.dart';
import 'package:sumgo_crawller_flutter/widget/MyWhiteButton.dart';
import 'package:sumgo_crawller_flutter/widget/SelectRemovalType.dart';

import '../../provider/RequestRemovalProvider.dart';
import '../../util/MyColors.dart';

class RequestRemovalPage extends StatefulWidget {
  static const String staticClassName = "RequestRemovalPage";
  final className = staticClassName;

  RequestRemovalPage({Key? key}) : super(key: key);

  @override
  _RequestRemovalPageState createState() => _RequestRemovalPageState();
}

class _RequestRemovalPageState extends KDHState<RequestRemovalPage> {
  @override
  bool isPage() => false;

  @override
  List<WidgetToGetSize> makeWidgetListToGetSize() => [];

  @override
  Future<void> onLoad() async {
    await RequestRemovalProvider.read(context).resetRemovalConditionList();
  }

  @override
  void mustRebuild() {
    widgetToBuild = () => body();
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}

  Widget body() {
    return RequestRemovalProvider.consumer(builder:
        (BuildContext context, RequestRemovalProvider provider, Widget? child) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 60),
            MyCard(
              title: "?????? ??????",
              rightButton: MyRedButton("????????????",
                  onPressed: () => showCreateItemBottomSheet()),
              contents: (RequestRemovalProvider.read(context)
                      .removalConditionList
                    ..sort((a, b) {
                      int calculateOrder(RemovalCondition removalCondition) {
                        if (removalCondition.type == RemovalType.best.value) {
                          return 3;
                        } else if (removalCondition.type ==
                            RemovalType.include.value) {
                          return 2;
                        } else {
                          return 1;
                        }
                      }

                      return calculateOrder(a) > calculateOrder(b) ? -1 : 1;
                    }))
                  .map((e) => RequestRemovalListTile(
                        item: e,
                        isPlusIcon: e.type != "exclude",
                      ))
                  .toList(),
              bottomButton: MyWhiteButton("?????? ????????????",
                  onPressed:
                      RequestRemovalProvider.read(context).removeRequests),
            ),
          ],
        ),
      );
    });
  }

  void showCreateItemBottomSheet() {
    final contentController = TextEditingController();
    final typeController = SelectRemovalTypeController();

    MyBottomSheetUtil().showInputBottomSheet(
      context: context,
      title: '?????? ?????? ????????????',
      children: [
        SelectRemovalType(typeController: typeController),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 100,
          leading: Text("??????",
              style: MyFonts.gothicA1(color: MyColors.black, fontSize: 12.5)),
          title: TextField(
            controller: contentController,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        const SizedBox(height: 10),
      ],
      buttonStr: "??????",
      onButtonPress: (setErrorMessage) =>
          RequestRemovalProvider.read(context).addRemovalCondition(
        contentController.text.trim(),
        typeController.typeValue,
        typeController.typeDisplay,
        setErrorMessage,
      ),
    );
  }
}

class RequestRemovalListTile extends StatelessWidget {
  RemovalCondition item;
  AnimationController? animateController;
  bool isPlusIcon;

  RequestRemovalListTile({Key? key, required this.item, this.isPlusIcon = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationUtil.slideInLeft(
      manualTrigger: true,
      duration: const Duration(milliseconds: 0),
      delay: const Duration(milliseconds: 0),
      from: 15,
      controller: (aController) => animateController = aController,
      child: Slidable(
        key: GlobalKey(), //1.????????? ?????? ????????????
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Image(
                image: (isPlusIcon ? MyImage.plusIcon : MyImage.minusIcon)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          horizontalTitleGap: 6,
          title: Text("[${item.typeDisplay ?? ""}] ${item.content ?? ""}",
              style: MyFonts.gothicA1()),
          dense: true,
        ),
        endActionPane: ActionPane(
          //3. startActionPane: ??????????????? ??????????????? ???????????????, endActionPane: ??????
          extentRatio: 0.4,
          //?????? child??? ??????
          motion: const BehindMotion(),
          //?????? ??????????????? ?????? BehindMotion, DrawerMotion, ScrollMotion, StretchMotion
          children: [
            CustomSlidableAction(
              onPressed: (c) => showUpdateItemBottomSheet(context, item),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: const Icon(Icons.edit),
            ),
            CustomSlidableAction(
              onPressed: (c) => RequestRemovalProvider.read(context)
                  .deleteRemovalCondition(item, animateController),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  void showUpdateItemBottomSheet(
      BuildContext context, RemovalCondition currentItem) {
    final contentController = TextEditingController(text: currentItem.content);
    final typeController = SelectRemovalTypeController();

    MyBottomSheetUtil().showInputBottomSheet(
      context: context,
      title: '?????? ?????? ????????????',
      children: [
        SelectRemovalType(typeController: typeController, typeDisplay: currentItem.typeDisplay, typeValue: currentItem.type),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 100,
          leading: Text("??????",
              style: MyFonts.gothicA1(color: MyColors.black, fontSize: 12.5)),
          title: TextField(
            controller: contentController,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        const SizedBox(height: 10),
      ],
      buttonStr: "??????",
      onButtonPress: (setErrorMessage) =>
          RequestRemovalProvider.read(context).updateRemovalCondition(
        contentController.text.trim(),
        typeController.typeValue,
        typeController.typeDisplay,
        currentItem,
        setErrorMessage,
      ),
    );
  }
}
