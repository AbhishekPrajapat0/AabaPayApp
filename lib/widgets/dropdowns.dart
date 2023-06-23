/* Tushar Ugale * Technicul.com */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';

class FloatingDropdownInt extends StatelessWidget {
  String title = '';
  List<DropdownMenuItem<int>> items = [];
  int selectedValue = 0;
  void Function(int? value) onChange;
  String errorMsg = "";
  FloatingDropdownInt(
      this.title, this.items, this.selectedValue, this.onChange, this.errorMsg);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        dropdownTitle(title),
        Center(
          child: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.grey.shade800,
                primaryColor: Colors.white,
                focusColor: Colors.white,
                primaryColorLight: Colors.white),
            child: DropdownButtonFormField(
                value: selectedValue,
                style: const TextStyle(color: Colors.white, fontSize: 17),
                isExpanded: true,
                items: items,
                onChanged: onChange),
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Text(errorMsg,
                style: TextStyle(color: Colors.red, fontSize: 13)))
      ],
    );
  }

  Widget dropdownTitle(String title) {
    if (title != '') {
      return Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return Container();
    }
  }
}

class FloatingDropdownString extends StatelessWidget {
  String title = '';
  List<DropdownMenuItem<String>> items = [];
  String selectedValue = '';
  void Function(String? value) onChange;
  String errorMsg = "";
  FloatingDropdownString(
      this.title, this.items, this.selectedValue, this.onChange, this.errorMsg);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Center(
          child: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.grey.shade800,
                primaryColor: Colors.white,
                focusColor: Colors.white,
                primaryColorLight: Colors.white),
            child: DropdownButton(
              value: selectedValue,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              isExpanded: true,
              items: items,
              onChanged: onChange,
            ),
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Text(errorMsg,
                style: TextStyle(color: Colors.red, fontSize: 13)))
      ],
    );
  }
}
