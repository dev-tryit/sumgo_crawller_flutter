import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sumgo_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:sumgo_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:sumgo_crawller_flutter/_common/util/AnimationUtil.dart';
import 'package:sumgo_crawller_flutter/repository/AnalysisItemRepository.dart';
import 'package:sumgo_crawller_flutter/util/MyBottomSheetUtil.dart';
import 'package:sumgo_crawller_flutter/util/MyColors.dart';
import 'package:sumgo_crawller_flutter/util/MyFonts.dart';
import 'package:sumgo_crawller_flutter/util/MyImage.dart';
import 'package:sumgo_crawller_flutter/widget/MyCard.dart';
import 'package:sumgo_crawller_flutter/widget/MyChart.dart';
import 'package:sumgo_crawller_flutter/widget/MyRedButton.dart';

import '../../provider/KeywordAnalysisProvider.dart';

class KeywordAnalysisPage extends StatefulWidget {
  static const String staticClassName = "KeywordAnalysisPage";
  final className = staticClassName;

  const KeywordAnalysisPage({Key? key}) : super(key: key);

  @override
  _KeywordAnalysisPageState createState() => _KeywordAnalysisPageState();
}

class _KeywordAnalysisPageState extends KDHState<KeywordAnalysisPage> {
  final scrollController = ScrollController();
  
  @override
  bool isPage() => false;

  @override
  List<WidgetToGetSize> makeWidgetListToGetSize() => [];

  @override
  Future<void> onLoad() async {
    await KeywordAnalysisProvider.read(context).resetAnalysisItemList();
  }

  @override
  void mustRebuild() {
    widgetToBuild = () => body();
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}

  Widget body() {
    return KeywordAnalysisProvider.consumer(
      builder:
          (BuildContext context, KeywordAnalysisProvider provider, Widget? child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 60),
              MyCard(
                scrollController: scrollController,
                title: "????????? ??????",
                rightButton: MyRedButton("????????????",
                    onPressed: () => showCreateItemBottomSheet()),
                contentHeight: 200,
                contents: KeywordAnalysisProvider.read(context).analysisItemList
                    .map((e) => KeywrodAnalysisListTile(
                  item: e,
                ))
                    .toList(),
              ),
              ...(KeywordAnalysisProvider.read(context).analysisItemList.map((e) => MyCard(
                title: e.title ?? "",
                useScroll: false,
                contents: [MyChart(e)],
              ))).toList(),
            ],
          ),
        );
      },
    );
  }

  void showCreateItemBottomSheet() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController keywordController = TextEditingController();

    MyBottomSheetUtil().showInputBottomSheet(
      context: context,
      title: '????????? ?????? ????????????',
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 100,
          leading: Text("?????? ??????",
              style: MyFonts.gothicA1(color: MyColors.black, fontSize: 12.5)),
          title: TextField(
            controller: titleController,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 100,
          leading: Text("?????? ?????? ?????????",
              style: MyFonts.gothicA1(color: MyColors.black, fontSize: 12.5)),
          title: TextField(
            controller: keywordController,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        const SizedBox(height: 10),
      ],
      buttonStr: "??????",
      onButtonPress: (setErrorMessage) => KeywordAnalysisProvider.read(context).addAnalysisItem(
        titleController.text.trim(),
        keywordController.text.trim(),
        setErrorMessage,
        scrollController,
      ),
    );
  }

}

class KeywrodAnalysisListTile extends StatelessWidget {
  AnalysisItem item;
  AnimationController? animateController;

  KeywrodAnalysisListTile({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = item.title ?? "";
    String keyword = (item.keywordList ?? []).join(",  ".trim());

    return AnimationUtil.slideInLeft(
      manualTrigger: true,
      duration: const Duration(milliseconds: 0),
      delay: const Duration(milliseconds: 0),
      from: 15,
      controller: (aController) => animateController = aController,
      child: Slidable(
        key: GlobalKey(), //1.????????? ?????? ????????????
        child: ListTile(
          //2. ??????????????? ?????? ??????
          leading: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Image(image: MyImage.boxIcon),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          horizontalTitleGap: 6,
          title: Text("$title ??????", style: MyFonts.gothicA1()),
          subtitle: Text(keyword,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
              style: MyFonts.gothicA1(fontSize: 9)),
          dense: true,
        ),
        endActionPane: ActionPane(
          //3. startActionPane: ??????????????? ??????????????? ???????????????, endActionPane: ??????
          extentRatio: 0.40,
          //?????? child??? ??????
          motion: const BehindMotion(),
          //?????? ??????????????? ?????? BehindMotion, DrawerMotion, ScrollMotion, StretchMotion
          children: [
            CustomSlidableAction(
              onPressed: (c) => showUpdateItemBottomSheet(context, title, keyword, item),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: const Icon(Icons.edit),
            ),
            CustomSlidableAction(
              onPressed: (c) => KeywordAnalysisProvider.read(context).deleteAnalysisItem(item, animateController),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  void showUpdateItemBottomSheet(BuildContext context, String title, String keyword, AnalysisItem currentItem) {
    final TextEditingController titleController = TextEditingController(text:title);
    final TextEditingController keywordController = TextEditingController(text:keyword);

    MyBottomSheetUtil().showInputBottomSheet(
      context: context,
      title: '????????? ?????? ????????????',
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 100,
          leading: Text("?????? ??????",
              style: MyFonts.gothicA1(color: MyColors.black, fontSize: 12.5)),
          title: TextField(
            controller: titleController,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 100,
          leading: Text("?????? ?????? ?????????",
              style: MyFonts.gothicA1(color: MyColors.black, fontSize: 12.5)),
          title: TextField(
            controller: keywordController,
            decoration: const InputDecoration(isDense: true),
          ),
        ),
        const SizedBox(height: 10),
      ],
      buttonStr: "??????",
      onButtonPress: (setErrorMessage) => KeywordAnalysisProvider.read(context).updateAnalysisItem(
        titleController.text.trim(),
        keywordController.text.trim(),
        currentItem,
        setErrorMessage,
      ),
    );
  }
}
