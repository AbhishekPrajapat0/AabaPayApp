/* Tushar Ugale * Technicul.com */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class PreLoginToolbar extends StatelessWidget {
  String title = "";
  void Function() onTap;
  bool showBlackButton = true;

  PreLoginToolbar(this.title, this.onTap, {this.showBlackButton = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        showBlackButton
            ? InkWell(
                onTap: onTap,
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lightBlackBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: blackShadowColor.withOpacity(0.68),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ]),
                  child: const Center(
                      child: Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 20)),
                ),
              )
            : Container(),
        showBlackButton ? const SizedBox(width: 20) : Container(),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 24)),
      ],
    );
  }
}

class PostLoginToolbar extends StatelessWidget {
  String title = "";
  void Function() onTap;
  bool showBlackButton = true;

  PostLoginToolbar(this.title, this.onTap, {this.showBlackButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          InkWell(
              onTap: onTap,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              )),
          SizedBox(
            width: 20,
          ),
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
