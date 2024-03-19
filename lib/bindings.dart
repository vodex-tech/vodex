import 'package:get/get.dart';
import 'package:datasource/datasource.dart';
import 'package:logic_study/view/auth/auth/controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Datasource>(() => Datasource());
    Get.put(Auth(), permanent: true);
  }
}
