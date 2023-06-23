/* Tushar Ugale * Technicul.com */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';

Future<bool> showExitPopup(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardHeaderBackgroundColor,
          title: Text(
            "Exit?",
            style: TextStyle(color: whiteColor),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            color: cardHeaderBackgroundColor,
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Do you want to exit?",
                  style: TextStyle(color: whiteColor),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFC4C4C4),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(color: whiteColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('yes selected');
                          exit(0);
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(color: blackBackgroundColor),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: lightPrimaryColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}
