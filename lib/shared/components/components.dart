import 'package:flutter/material.dart';

Widget defaultFormField({
  TextEditingController? controller,
  required TextInputType type,
  required String? text,
  ValueChanged? onSubmite,
  ValueChanged? onChange,
  VoidCallback? onTap,
  FormFieldValidator? validate,
  IconData? prefix,
  IconData? suffix,
  bool isPassword = false,
  VoidCallback? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      onFieldSubmitted: onSubmite,
      onChanged: onChange,
      validator: validate,
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        prefixIcon: Icon(prefix),
        enabled: isClickable,
      ),
      onTap: onTap,
    );

Widget buildTaskItems(Map model) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.indigo[400],
                child: Text(
                  '${model['time']}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Column(
                crossAxisAlignment:CrossAxisAlignment.start ,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
            ]),
      ),
    );
Widget buildTaskItem(Map model)=>Column(
  children: [
    Card(

    )
  ],
);