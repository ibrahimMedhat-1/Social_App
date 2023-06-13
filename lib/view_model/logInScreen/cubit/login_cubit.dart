// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/shared/constraints.dart';
import '../../../shared/local/CacheHelper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  IconData suffixIcon = Icons.visibility;

  void changeObSecure() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(LoginPasswordIsShown());
  }

  void userLogIn({
    required String email,
    required String password,
    required BuildContext context,
    Map<String, dynamic>? query,
  }) async {
    uID = null;
    await CacheHelper.removeData(key: 'uId');
    SocialCubit.get(context).currentIndex = 0;
    emit(LoginLoading());
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.toString(), password: password.toString()).then((value) async {
      await CacheHelper.setData(key: 'uId', value: FirebaseAuth.instance.currentUser!.uid.toString());
      uID = await CacheHelper.getData(key: 'uId');
      SocialCubit.get(context).getData();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const SocialLayout()));
      emit(LoginDone());
    }).catchError((onError) {
      emit(LoginError(onError.toString()));
      debugPrint(onError.toString());
    });
  }
}
