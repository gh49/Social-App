import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/layouts/home_layout.dart';
import 'package:social_app_g/modules/login/login_screen.dart';
import 'package:social_app_g/shared/components/constants.dart';
import 'package:social_app_g/shared/components/constants.dart';
import 'package:social_app_g/shared/cubit/cubit.dart';
import 'package:social_app_g/shared/cubit/states.dart';
import 'package:social_app_g/shared/network/local/cache_helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await CacheHelper.init();

  Widget startWidget = LoginScreen();
  uIDGlobal = CacheHelper.getData(key: "uID");
  if(uIDGlobal != null) {
    startWidget = HomeScreen();
  }

  runApp(MyApp(startWidget: startWidget,));
}

class MyApp extends StatelessWidget {
  Widget startWidget;
  MyApp({super.key, required this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Social App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: startWidget,
          );
        }
          ),
    );
  }
}

