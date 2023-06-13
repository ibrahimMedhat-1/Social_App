import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import 'cubit/register_cubit.dart';
import 'cubit/register_state.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          // if(state is RegisterDone){
          //   if (RegisterCubit.get(context).registerModel!.status as bool) {
          //     CacheHelper.setData(key: 'token', value: RegisterCubit.get(context).registerModel!.data!.token.toString()).then((value) {
          //       Fluttertoast.showToast(
          //           msg: 'Registered Successfully',
          //           toastLength: Toast.LENGTH_SHORT,
          //           gravity: ToastGravity.BOTTOM,
          //           timeInSecForIosWeb: 1,
          //           backgroundColor: Colors.green,
          //           textColor: Colors.white,
          //           fontSize: 16.0);
          //       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => ShopLayout()));
          //     }).catchError((onError){
          //       print(onError);
          //     });
          //   } else {
          //     Fluttertoast.showToast(
          //         msg: '',
          //         toastLength: Toast.LENGTH_SHORT,
          //         gravity: ToastGravity.CENTER,
          //         timeInSecForIosWeb: 1,
          //         backgroundColor: Colors.red,
          //         textColor: Colors.white,
          //         fontSize: 30);
          //   }
          // }
        },
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
                            'Register'.toUpperCase(),
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
                            'Register now to browse our hot offers',
                            style: TextStyle(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textFormField(
                            onChanged: (v) {},
                            controller: nameController,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Your Name';
                              }
                            },
                            label: 'Name',
                            prefixIcon: Icons.person,
                            keyboardType: TextInputType.name,
                            hintText: 'Enter Your Name',
                            obSecureText: false,
                            onSubmit: () {},
                            suffixPressed: () {},
                          ),
                          const SizedBox(
                            height: 20,
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
                            controller: phoneController,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Your Phone Number';
                              }
                            },
                            label: 'Phone',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.phone,
                            hintText: 'Phone Number',
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
                            obSecureText: RegisterCubit.get(context).isPassword,
                            suffixIcon: RegisterCubit.get(context).suffixIcon,
                            onSubmit: (value) {},
                            suffixPressed: () {
                              RegisterCubit.get(context).changeObSecure();
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: Container(
                              width: 150,
                              height: 60,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                              child: MaterialButton(
                                color: Colors.blue,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    RegisterCubit.get(context).userRegister(
                                        email: emailController.text.toString(),
                                        password: passwordController.text.toString(),
                                        name: nameController.text.toString(),
                                        phone: phoneController.text.toString(),
                                        context: context);
                                  }
                                },
                                minWidth: double.infinity,
                                child: const Text(
                                  'REGISTER',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
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
