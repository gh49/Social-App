import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app_g/layouts/home_layout.dart';
import 'package:social_app_g/shared/components/components.dart';
import 'package:social_app_g/modules/login/cubit.dart';
import 'package:social_app_g/modules/register/register_screen.dart';
import 'package:social_app_g/modules/login/states.dart';
import 'package:social_app_g/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailCtrlr = TextEditingController();
  TextEditingController passwordCtrlr = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if(state is LoginErrorState) {
            //print("error");
            ShowToast(
                text: state.error.toString(),
                state: ToastStates.ERROR,
                context: context
            );
          }
          if(state is LoginSuccessState) {
            print("Success received");
            CacheHelper.saveData(
                key: "uID",
                value: state.uID
            ).then((value) {
              navigateAndFinish(context, HomeScreen());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Social App',
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      MyTFF(
                          controller: emailCtrlr,
                          keyboardType: TextInputType.emailAddress,
                          labelText: 'Email Address',
                          hintText: 'someone@example.com',
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          validator: (String? value) {
                            if(value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          }
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      MyTFF(
                          controller: passwordCtrlr,
                          keyboardType: TextInputType.visiblePassword,
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(LoginCubit.get(context).passwordSuffix),
                            onPressed: () {
                              LoginCubit.get(context).changePasswordVisibility();
                            },
                          ),
                          obscureText: LoginCubit.get(context).hidePassword,
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          }
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ConditionalBuilder(
                          condition: state is !LoginLoadingState,
                          builder: (context) => MyButton(
                            onPressed: () {
                              if(formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                  email: emailCtrlr.text,
                                  password: passwordCtrlr.text,
                                );
                              }
                            },
                            text: 'LOGIN',
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator())
                      ),
                      Row(
                        children: [
                          Text(
                            "Don't have an account?",
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, RegisterScreen());
                            },
                            child: Text(
                              'Register now!',
                            ),
                          ),
                        ],
                      ),
                    ],
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
