import 'package:flutter/material.dart';
import '../../view_model/logInScreen/login_screen.dart';
import '../local/CacheHelper.dart';

Widget textFormField({
  required Function(String value) validate,
  required TextEditingController controller,
  required String label,
  String? hintText,
  required IconData prefixIcon,
  IconData? suffixIcon,
  required TextInputType keyboardType,
  bool obSecureText = false,
  Function? suffixPressed,
  Function? onSubmit,
  Function? onChanged,
}) =>
    TextFormField(
      controller: controller,
      onChanged: (value) {
        onChanged!(value);
      },
      validator: (value) {
        return validate(value!);
      },
      keyboardType: keyboardType,
      obscureText: obSecureText,
      onFieldSubmitted: (value) {
        onSubmit!(value);
      },
      decoration: InputDecoration(
        label: Text(label),
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
            onPressed: () {
              suffixPressed!();
            },
            icon: Icon(suffixIcon)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );

void signOut(context) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => LogInScreen()));
  }).catchError((e) {
    debugPrint(e);
  });
}
