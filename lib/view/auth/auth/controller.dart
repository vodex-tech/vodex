import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:datasource/datasource.dart';
import 'package:logic_study/view/auth/info/options.dart';
import 'package:logic_study/routes/routes.dart';
import 'package:logic_study/services/init.dart';
import 'package:uuid/uuid.dart';

class Auth extends GetxController {
  final _datasource = Get.find<Datasource>();

  late User user;

  bool get isAuthorised => FirebaseAuth.instance.currentUser != null;
  bool get isAdmin => user.type == UserType.admin;

  initAuth() async {
    await init();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final user = await _datasource.get<User>(userId);
    if (!isAuthorised) {
      Get.offAllNamed(Routes.auth);
      return;
    }
    if (user != null && user.college.isNotEmpty) {
      this.user = user;
      startListener();
      Get.offAllNamed(Routes.main);
      return;
    }
    this.user = user ??
        User(
          name: '',
          email: FirebaseAuth.instance.currentUser!.email!,
          type: UserType.user,
          university: '',
          college: '',
          department: '',
          branch: '',
          stage: '',
          id: userId,
        );
    startListener();

    if (user == null) await _datasource.put(this.user);
    Get.offAll(const AccountSetupScreenWrapper());
  }

  StreamSubscription<DatabaseEvent>? _listener;

  startListener() async {
    final isRegistered = GetStorage().hasData('uid');
    if (!isRegistered) {
      final uid = const Uuid().v4();
      await GetStorage().write('uid', uid);
    }
    final uid = GetStorage().read('uid');
    await FirebaseDatabase.instance.ref('users').set({user.id: uid});
    _listener ??= FirebaseDatabase.instance
        .ref('users/${user.id}')
        .onValue
        .listen((event) async {
      final data = event.snapshot.value;
      if (data != null && data is String) {
        if (data != uid) {
          await signOut();
        }
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await initAuth();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('خطأ', 'البريد الالكتروني غير موجود');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('خطأ', 'كلمة المرور غير صحيحة');
      } else if (e.code == 'invalid-credential') {
        Get.snackbar('خطأ', 'البريد الالكتروني او كلمة المرور غير صحيحة');
      } else {
        Get.snackbar('خطأ', 'حدث خطأ ما');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ ما');
    }
  }

  Future signUp(String email, String password) async {
    try {
      final firebaseUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = User(
        name: '',
        email: email,
        type: UserType.user,
        university: '',
        college: '',
        department: '',
        branch: '',
        stage: '',
        id: firebaseUser.user!.uid,
      );
      await _datasource.put(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          await initAuth();
        } catch (e) {
          Get.snackbar('خطأ', 'البريد الالكتروني مستخدم بالفعل');
        }
      } else {
        Get.snackbar('خطأ', 'حدث خطأ ما');
      }
      rethrow;
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ ما');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.auth);
    GetStorage().remove('skip');
    _listener?.cancel();
  }
}
