/* Tushar Ugale * Technicul.com */
import 'dart:ui';

Color blackBackgroundColor = HexColor('141414');
Color lightBlackBackgroundColor = HexColor('161616');
Color blackShadowColor = HexColor('FDFDFD');
Color lightPrimaryColor = HexColor('00E5D3');
Color darkPrimaryColor = HexColor('019D91');

Color otpBorderColor = HexColor('010101');
Color cardBackgroundColor = HexColor('1F1F1F');
Color cardHeaderBackgroundColor = HexColor('2A2A2A');
Color searchBarHintColor = HexColor('818181');
Color cardBorderColor = HexColor('1A1A1A');
Color amountColor = HexColor('FFE797');
Color successColor = HexColor('00C572');
Color redColor = HexColor('FF0000');
Color yellowColor = HexColor('FFFF00');
Color purpleColor = HexColor('975AFF');
Color lightBlackColor = HexColor('222222');
Color darkRedColor = HexColor('FF1607');

Color whiteColor = HexColor('FFFFFF');
Color lightWhiteColor = HexColor('CFCFCF');
Color orangeColor = HexColor('ECA437');
Color dividerColor = HexColor('6E6E6E');
Color greenTextColor = HexColor('00C9A4');
Color lightGreenTextColor = HexColor('30D5AD');
Color benfCardBorderColor = HexColor('434343');
Color primaryAccBackgroundColor = HexColor('6C6C6C');

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
