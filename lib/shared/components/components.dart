import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Signout
// uIDGlobal = null;
// CacheHelper.removeData(key: 'uID');
// navigateAndFinish(context, LoginScreen());

Widget MyTFF({
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String labelText = '',
  String hintText = '',
  bool obscureText = false,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? Function(String?)? validator,
  void Function(String)? onFieldSubmitted,
  void Function(String)? onChanged,
}) => TextFormField(
  controller: controller,
  validator: validator,
  onFieldSubmitted: onFieldSubmitted,
  onChanged: onChanged,
  keyboardType: keyboardType,
  obscureText: obscureText,
  decoration: InputDecoration(
    labelText: labelText,
    hintText: hintText,
    border: OutlineInputBorder(),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  ),
);

Widget MyTextButton({
  required String text,
  required void Function()? onPressed,
  double? width,
  Color textColor = Colors.blue,
}) => Container(
width: width,
child: TextButton(
child: Text(
text,
style: TextStyle(
decoration: TextDecoration.underline,
decorationColor: textColor,
color: textColor,
),
),
onPressed: onPressed
),
);

Widget MyButton({
  required String text,
  required void Function()? onPressed,
  double width = double.infinity,
  double height = 50.0,
  TextAlign textAlign = TextAlign.center,
}) => Container(
  width: width,
  height: height,
  color: Colors.blue,
  child: MaterialButton(
    onPressed: onPressed,
    child: Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void ShowToast({
  required String text,
  required ToastStates state,
  required BuildContext context,
}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: chooseToastColor(state),
      //action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar, backgroundColor: Colors.red),
    ),
  );
}

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route) {
        return false;
      },
    );