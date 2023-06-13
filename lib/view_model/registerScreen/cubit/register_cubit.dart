import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/model/create_user_model.dart';
import '../../logInScreen/login_screen.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  IconData suffixIcon = Icons.visibility;

  void changeObSecure() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(RegisterPasswordIsShown());
  }

  void userRegister(
      {required String email, required String password, required String name, required String phone, required BuildContext context}) async {
    emit(RegisterLoading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(id: value.user!.uid, name: name, email: email, phone: phone, context: context, uID: value.user!.uid);
      emit(RegisterDone());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => LogInScreen()));
    }).catchError((onError) {
      debugPrint(onError.toString());
    });
  }

  void userCreate(
      {required String name, required String email, required String phone, required String uID, required BuildContext context, required String id}) {
    CreateUserModel model = CreateUserModel(
        name: name,
        email: email,
        phone: phone,
        profileImage:
            'https://img.freepik.com/free-photo/smiley-woman-holding-bowl-with-lemons_23-2148450416.jpg?w=2000&t=st=1676485757~exp=1676486357~hmac=dacb09e01135a2f9f2912354be261331af8d3bf295054edc5e7999875f232399',
        coverImage:
            'https://img.freepik.com/free-photo/side-view-woman-drinking-pouring-lemonade_23-2148450420.jpg?w=2000&t=st=1676485727~exp=1676486327~hmac=61c228fd8b8f1b3ff870f4adbd21acbc4a645d77216665f9761bc9a7c2278c13',
        bio: 'Write your bio...',
        id: id);

    FirebaseFirestore.instance.collection('user').doc(uID).set(model.toMap()).then((value) {}).catchError((e) {
      debugPrint(e);
    });
  }
}
