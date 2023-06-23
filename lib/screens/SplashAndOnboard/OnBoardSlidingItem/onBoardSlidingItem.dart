/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/models/SlidingItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SlidingItems extends StatelessWidget {
  final int index;
  const SlidingItems(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: SvgPicture.asset(slideList[index].imageUrl),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(
              slideList[index].title,
              style: GoogleFonts.outfit(
                color: whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Center(
              child: Text(
                slideList[index].description,
                style: GoogleFonts.outfit(
                  color: lightWhiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
