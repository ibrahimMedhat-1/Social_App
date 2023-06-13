// ignore_for_file: must_be_immutable
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/shared/constraints.dart';
import 'package:social_app/shared/local/CacheHelper.dart';
import 'package:social_app/view_model/logInScreen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb)
    await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAzByNM_QENz5dhs8cBK__uGnqzGPR2pIE",
        authDomain: "social-app-1d237.firebaseapp.com",
        projectId: "social-app-1d237",
        storageBucket: "social-app-1d237.appspot.com",
        messagingSenderId: "681809782537",
        appId: "1:681809782537:web:dcaed8de78bc4b47a4d5d8",
        measurementId: "G-QNJV9L2B03"
    ),
  );
  else
    await Firebase.initializeApp();
  await CacheHelper.init();
  uID = await CacheHelper.getData(key: 'uId');
  Widget startScreen;
  if (uID != null) {
    startScreen = const SocialLayout();
  } else {
    startScreen = LogInScreen();
  }
  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  Widget startScreen;

  MyApp(this.startScreen, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SocialCubit>(
          create: (context) => SocialCubit()
            ..getData()
            ..getPosts()
            ..getAllUsers(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
            // useMaterial3: true
            ),
        debugShowCheckedModeBanner: false,
        home: startScreen,
      ),
    );
  }
}
