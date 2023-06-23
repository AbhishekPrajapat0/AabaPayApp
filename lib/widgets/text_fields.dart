/* Tushar Ugale * Technicul.com */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

// ignore: must_be_immutable
class BorderedTextField extends StatelessWidget {
  String title = "";
  TextEditingController textEditingController;
  TextInputType textInputType;
  String errorMsg = "";
  TextCapitalization capital;
  bool autoFocus = false;

  BorderedTextField(this.title, this.textEditingController,
      {Key? key,
      this.textInputType = TextInputType.text,
      this.errorMsg = "",
      this.capital = TextCapitalization.none,
      this.autoFocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14)),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          autofocus: autoFocus,
          controller: textEditingController,
          style:
              const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
          cursorHeight: 30,
          cursorColor: darkPrimaryColor,
          keyboardType: textInputType,
          textCapitalization: capital,

          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter ${title.toLowerCase()}';
          //     }
          //     if (title.toLowerCase().contains("mobile") && value.length != 10) {
          //       return 'Please enter 10 digit mobile number';
          //     }
          //     return null;
          //   },

          decoration: InputDecoration(
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: darkPrimaryColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: darkPrimaryColor, width: 1.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: darkPrimaryColor, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: darkPrimaryColor, width: 1.0),
              ),
              hintText: '',
              errorText: errorMsg == "" ? null : errorMsg),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class FloatingTextField extends StatelessWidget {
  String title = "";
  String label = "";
  TextEditingController textEditingController;
  TextInputType textInputType;
  String errorMsg = "";
  TextCapitalization capital;
  bool autoFocus = false;
  void Function(String? value) onChange;
  FloatingTextField(this.title, this.label, this.textEditingController,
      {Key? key,
      this.textInputType = TextInputType.text,
      this.capital = TextCapitalization.none,
      this.errorMsg = "",
      this.autoFocus = false,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          autofocus: autoFocus,
          onChanged: onChange,
          controller: textEditingController,
          cursorHeight: 22,
          cursorColor: darkPrimaryColor,
          keyboardType: textInputType,
          textCapitalization: capital,
          style: const TextStyle(height: 1, color: Colors.white),
          decoration: InputDecoration(
            labelStyle: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            alignLabelWithHint: true,
            labelText: title,
            hintText: label,
            errorText: errorMsg == "" ? null : errorMsg,
            hintStyle: TextStyle(
                color: lightWhiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w400),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: dividerColor),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: dividerColor),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: dividerColor),
            ),
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
