import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blueGrey,
  bool isUpperCase = true,
  double radius = 15.0,
  double height = 40.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
        elevation: 50.0,
      ),
    );

Widget defaultTextFormField({
  required String hint,
  required IconData prefixIcon,
  required BuildContext context,
  required TextInputType type,
  required Function validator,
  required TextEditingController controller,
  bool isPassword = false,
  IconButton? suffixIcon,
  Function? onChange,
  Function? onSubmit,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.blueGrey.withOpacity(0.1),
      ),
      child: TextFormField(
        onFieldSubmitted: onSubmit != null
            ? (s) {
                onSubmit(s);
              }
            : null,
        onChanged: onChange != null
            ? (s) {
                onChange(s);
              }
            : null,
        controller: controller,
        validator: (value) {
          validator(value);
        },
        keyboardType: type,
        obscureText: isPassword,
        style: const TextStyle(
          textBaseline: TextBaseline.alphabetic,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Colors.grey[200],
          ),
          suffix: suffixIcon,
          contentPadding: EdgeInsets.all(
            (MediaQuery.of(context).size.width) / 50.0,
          ),
          isCollapsed: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: Color(0xff314050),
              width: 1,
            ),
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.grey[200],
          ),
          labelText: hint,
        ),
      ),
    );

Card defaultLoading({
  required BuildContext context,
}) =>
    Card(
      child: Padding(
        padding: EdgeInsets.all(
          (MediaQuery.of(context).size.height) / 40.0,
        ),
        child: const CircularProgressIndicator(),
      ),
      elevation: 5,
    );
