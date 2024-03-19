import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datasource/datasource.dart';
import 'package:firebase_feature_flag/firebase_feature_flag.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/controller.dart';

class HomeController extends GetxController {
  final _datasource = Get.find<Datasource>();
  final _auth = Get.find<Auth>();

  bool get isAdmin => _auth.isAdmin;

  final topBanner = FeatureFlag<String>(key: 'banner', initialValue: '');

  String get coursesId => '${_auth.user.university}_${_auth.user.college}_${_auth.user.department}_${_auth.user.stage}_${_auth.user.branch}';

  Query<Course> get courses => _datasource.getCoursesFor(_auth.user);
}
