import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/auth.dart';
import 'package:logic_study/view/auth/login/controller.dart';
import 'package:logic_study/view/auth/login/login.dart';
import 'package:logic_study/view/auth/sign_up/controller.dart';
import 'package:logic_study/view/auth/sign_up/sign_up.dart';
import 'package:logic_study/view/auth/wrapper/controller.dart';
import 'package:logic_study/view/auth/wrapper/error_page.dart';
import 'package:logic_study/view/auth/wrapper/wrapper.dart';
import 'package:logic_study/view/home/main.dart';

class Routes {
  static const initial = '/main';

  static const wrapper = '/wrapper';
  static const auth = '/auth';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const main = '/main';
  static const errorPage = '/error-page';

  static final routes = [
    GetPage(
      name: wrapper,
      binding: BindingsBuilder.put(() => WrapperController(), permanent: true),
      page: () => const WrapperScreen(),
    ),
    GetPage(
      name: auth,
      page: () => const AuthScreen(),
      middlewares: [WrapperMiddleware()],
    ),
    GetPage(
      name: login,
      binding: BindingsBuilder.put(() => LogInController()),
      page: () => const LogInScreen(),
      middlewares: [WrapperMiddleware()],
    ),
    GetPage(
      name: signUp,
      binding: BindingsBuilder.put(() => SignUpController(), permanent: true),
      page: () => const SignUpScreen(),
      middlewares: [WrapperMiddleware()],
    ),
    GetPage(
      name: main,
      page: () => const UserMainScreen(),
      middlewares: [WrapperMiddleware()],
    ),
    GetPage(
      name: errorPage,
      page: () => const ErrorPage(),
    ),
  ];
}

class WrapperMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == Routes.wrapper || Get.isRegistered<WrapperController>()) {
      return null;
    }
    return RouteSettings(
      name: Routes.wrapper,
      arguments: route,
    );
  }
}
