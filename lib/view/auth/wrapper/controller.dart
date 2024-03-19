import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/routes/routes.dart';
import 'package:logic_study/services/init.dart';

class WrapperController extends GetxController {
  final _auth = Get.find<Auth>();

  init() async {
    if (_auth.isAuthorised) {
      try {
        await _auth.initAuth();
      } catch (e) {
        Get.offAllNamed(Routes.errorPage);
      }
    } else {
      await waitFor(const Duration(seconds: 2));
      Get.offAllNamed(Routes.auth);
    }
  }
}
