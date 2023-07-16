import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/layouts/home_layout.dart';
import 'package:social_app_g/modules/register/cubit.dart';
import 'package:social_app_g/modules/register/states.dart';
import 'package:social_app_g/shared/components/components.dart';
import 'package:social_app_g/shared/components/constants.dart';
import 'package:social_app_g/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailCtrlr = TextEditingController();
  final TextEditingController passwordCtrlr = TextEditingController();
  final TextEditingController usernameCtrlr = TextEditingController();
  final TextEditingController phoneNumCtrlr = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if(state is CreateUserSuccessState) {
            CacheHelper.saveData(key: 'uID', value: state.uID);
            uIDGlobal = state.uID;
            navigateAndFinish(context, HomeScreen());
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
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: 80.0,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        MyTFF(
                            controller: usernameCtrlr,
                            keyboardType: TextInputType.name,
                            labelText: 'Username',
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                            validator: (String? value) {
                              if(value == null || value.isEmpty) {
                                return 'Please enter your user name';
                              }
                              return null;
                            }
                        ),
                        SizedBox(
                          height: 20.0,
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
                              icon: Icon(RegisterCubit.get(context).passwordSuffix),
                              onPressed: () {
                                RegisterCubit.get(context).changePasswordVisibility();
                              },
                            ),
                            obscureText: RegisterCubit.get(context).hidePassword,
                            validator: (value) {
                              if(value == null || value.toString().length < 6) {
                                return 'Password is too short';
                              }
                              return null;
                            }
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        MyTFF(
                            controller: phoneNumCtrlr,
                            keyboardType: TextInputType.phone,
                            labelText: 'Phone Number',
                            prefixIcon: Icon(
                              Icons.phone,
                            ),
                            validator: (String? value) {
                              if(value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            }
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is !RegisterLoadingState,
                          builder: (context) => MyButton(
                            onPressed: () {
                              if(formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  name: usernameCtrlr.text,
                                  email: emailCtrlr.text,
                                  password: passwordCtrlr.text,
                                  phoneNumber: phoneNumCtrlr.text
                                );
                              }
                            },
                            text: 'REGISTER',
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator())
                        ),
                      ],
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
