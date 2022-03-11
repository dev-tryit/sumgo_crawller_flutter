import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumgo_crawller_flutter/_common/abstract/KDHComponent.dart';
import 'package:sumgo_crawller_flutter/_common/abstract/KDHService.dart';
import 'package:sumgo_crawller_flutter/_common/abstract/KDHState.dart';
import 'package:sumgo_crawller_flutter/_common/model/WidgetToGetSize.dart';
import 'package:sumgo_crawller_flutter/_common/util/LogUtil.dart';
import 'package:sumgo_crawller_flutter/state/auth/AuthState.dart';
import 'package:sumgo_crawller_flutter/util/MyColors.dart';
import 'package:sumgo_crawller_flutter/util/MyComponents.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState
    extends KDHState<AuthPage, AuthPageComponent, AuthPageService> {
  @override
  bool isPage() => true;

  @override
  List<WidgetToGetSize> makeWidgetListToGetSize() => [];

  @override
  AuthPageComponent makeComponent() => AuthPageComponent(this);

  @override
  AuthPageService makeService() => AuthPageService(this, c);

  @override
  Future<void> onLoad() async {
  }

  @override
  void mustRebuild() {
    widgetToBuild = () => c.body(s);
    rebuild();
  }

  @override
  Future<void> afterBuild() async {}
}

class AuthPageComponent extends KDHComponent<_AuthPageState> {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool emailTextFieldEnabled = true;
  String? emailValidationText = "인증 요청";
  String? nextButtonText;
  Color emailValidationColor = MyColors.deepBlue;

  double passwordOpacity = 0;

  AuthPageComponent(_AuthPageState state) : super(state);

  Widget body(AuthPageService s) {
    final authState = s.authStateManager.state;
    LogUtil.debug(
        "body authStateManager.authState:${authState.runtimeType}");

    List<Widget> elementList = uiListByAuthState(authState);

    return Scaffold(
      bottomSheet: nextButtonText != null
          ? AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 1500),
              child: Container(
                height: 82,
                padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                child: SizedBox.expand(
                  child: ElevatedButton(
                    child: Text(nextButtonText!),
                    style: ElevatedButton.styleFrom(primary: MyColors.deepBlue),
                    onPressed: s.loginOrRegister,
                  ),
                ),
              ),
            )
          : null,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 36),
              Text(
                "숨고 매니저",
                style: GoogleFonts.blackHanSans(
                  fontSize: 35,
                  color: MyColors.deepBlue,
                ),
              ),
              const SizedBox(height: 69),
              inputBox(
                label: "이메일",
                trailing: emailValidationText,
                trailingColor: emailValidationColor,
                onTrailingTap: s.sendEmailVerification,
                controller: emailController,
                textFieldEnabled: emailTextFieldEnabled,
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value == null || !EmailValidator.validate(value)) {
                    return "이메일 형식이 아닙니다.";
                  }
                  return null;
                },
                onChanged: (value) => _formKey.currentState?.validate(),
              ),
              ...elementList
            ],
          ),
        ),
      ),
    );
  }

  Widget inputBox({
    required String label,
    String? trailing,
    Color? trailingColor,
    GestureTapCallback? onTrailingTap,
    TextEditingController? controller,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    bool? textFieldEnabled,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  validator: validator,
                  onChanged: onChanged,
                  enabled: textFieldEnabled,
                  obscureText: obscureText,
                ),
              ),
              ...trailing != null
                  ? [
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: InkWell(
                          onTap: onTrailingTap,
                          child: Text(
                            trailing,
                            style: GoogleFonts.gothicA1(
                              color: trailingColor ?? MyColors.deepBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : [],
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> uiListByAuthState(AuthState<AuthPageComponent> authState) {
    List<Widget> elementList = [];
    if (authState is AuthStateNeedVerfication) {
      emailValidationText = "인증 확인";
      emailTextFieldEnabled = false;
      emailValidationColor = MyColors.red;
      nextButtonText = null;
    } else if (authState is AuthStateSendEmail) {
      emailValidationText = "인증 요청";
      emailTextFieldEnabled = true;
      emailValidationColor = MyColors.deepBlue;
      nextButtonText = "null";
    } else if (authState is AuthStateLogin) {
      emailValidationText = null;
      emailTextFieldEnabled = false;
      nextButtonText = "로그인";

      //TODO: 로그인 코드 참고하여 ,EasyFade 위젯 만들기
      if (passwordOpacity == 0) {
        Timer(const Duration(milliseconds: 500), () {
          passwordOpacity = 1;
          rebuild();
        });
      }
      elementList.addAll([
        const SizedBox(height: 30),
        AnimatedOpacity(
          opacity: passwordOpacity,
          duration: const Duration(milliseconds: 800),
          child: inputBox(
            label: "비밀번호",
            controller: passwordController,
            onChanged: (value) => _formKey.currentState?.validate(),
            obscureText: true,
          ),
        ),
      ]);
    } else if (authState is AuthStateRegistration) {
      emailValidationText = null;
      emailTextFieldEnabled = false;
      nextButtonText = "회원가입";

      elementList.addAll([
        const SizedBox(height: 30),
        inputBox(
          label: "비밀번호",
          controller: passwordController,
          onChanged: (value) => _formKey.currentState?.validate(),
          obscureText: true,
        ),
        const SizedBox(height: 30),
        inputBox(
          label: "비밀번호 확인",
          controller: passwordConfirmController,
          onChanged: (value) => _formKey.currentState?.validate(),
          obscureText: true,
        ),
      ]);
    }

    return elementList;
  }
}

class AuthPageService extends KDHService<_AuthPageState, AuthPageComponent> {
  AuthStateManager<AuthPageComponent> authStateManager;

  AuthPageService(_AuthPageState state, AuthPageComponent c)
      : authStateManager = AuthStateManager<AuthPageComponent>(c),
        super(state, c);

  void sendEmailVerification() async {
    LogUtil.debug(
        "sendEmailVerification authStateManager.authState:${authStateManager.state.runtimeType}");

    String email = c.emailController.text.trim();

    await MyComponents.showLoadingDialog(context);
    if (authStateManager.state is AuthStateSendEmail) {
      await authStateManager.handle({'email': email});
    } else if (authStateManager.state is AuthStateNeedVerfication) {
      await authStateManager.handle({'email': email, 'context': context});
    }
    await MyComponents.dismissLoadingDialog();
    rebuild();
  }

  void loginOrRegister() async {
    LogUtil.debug(
        "loginOrRegister authStateManager.authState:${authStateManager.state.runtimeType}");

    String email = c.emailController.text.trim();
    String password = c.passwordController.text.trim();

    await MyComponents.showLoadingDialog(context);
    if (authStateManager.state is AuthStateLogin) {
      await authStateManager.state
          .handle({'email': email, 'password': password, 'context': context});
    } else if (authStateManager.state is AuthStateRegistration) {
      String passwordConfirm = c.passwordConfirmController.text.trim();
      await authStateManager.handle({
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
        'context': context,
      });
    } else {
      MyComponents.toastError(
        context,
        "loginOrRegister에 에러가 있습니다. 회원가입, 로그인 상태가 아닙니다.",
      );
    }
    await MyComponents.dismissLoadingDialog();
  }
}
