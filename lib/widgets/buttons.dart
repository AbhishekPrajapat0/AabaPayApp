/* Tushar Ugale * Technicul.com */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GradientButton extends StatelessWidget {
  String title = "";
  void Function() onTap;
  bool isLoading = false;

  GradientButton(this.title, this.onTap, {this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              darkPrimaryColor,
              lightPrimaryColor,
            ],
          ),
        ),
        child: Center(
            child: isLoading
                ? SizedBox(
                    child: CircularProgressIndicator(color: Colors.white),
                    height: 25,
                    width: 25,
                  )
                : Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500))),
      ),
    );
  }
}
