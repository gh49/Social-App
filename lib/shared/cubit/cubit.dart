import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
}