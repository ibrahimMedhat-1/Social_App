// ignore_for_file: use_build_context_synchronously

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/constraints.dart';
import '../../shared/local/CacheHelper.dart';
import '../registerScreen/registerScreen.dart';
import 'cubit/login_cubit.dart';

// ignore: must_be_immutable
class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SafeArea(
                child: Form(
                  key: formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'login'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 35,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Login now to browse our hot offers',
                            style: TextStyle(),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          textFormField(
                            onChanged: (v) {},
                            controller: emailController,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Your Email';
                              }
                            },
                            label: 'Email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Email Address',
                            obSecureText: false,
                            onSubmit: () {},
                            suffixPressed: () {},
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textFormField(
                            onChanged: (v) {},
                            controller: passwordController,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Your Password';
                              }
                            },
                            label: 'Password',
                            prefixIcon: Icons.lock,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: 'Password',
                            obSecureText: LoginCubit.get(context).isPassword,
                            suffixIcon: LoginCubit.get(context).suffixIcon,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                // LoginCubit.get(context).userLogIn(
                                //   email: emailController.text,
                                //   password: passwordController.text,
                                // );
                              }
                            },
                            suffixPressed: () {
                              LoginCubit.get(context).changeObSecure();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Container(
                              width: 150,
                              height: 60,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                              child: ConditionalBuilder(
                                condition: state is! LoginLoading,
                                builder: (context) => MaterialButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      uID = null;
                                      await CacheHelper.removeData(key: 'uId');
                                      LoginCubit.get(context)
                                          .userLogIn(email: emailController.text, password: passwordController.text, context: context);
                                    }
                                  },
                                  color: Colors.blue,
                                  minWidth: double.infinity,
                                  child: const Text(
                                    'LOGIN',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                fallback: (context) => const Center(child: CircularProgressIndicator()),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text('Don\'t have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (builder) => RegisterScreen()));
                                },
                                child: const Text('Register'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
