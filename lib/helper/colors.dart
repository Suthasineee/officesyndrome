import 'package:flutter/widgets.dart';

const colorPrimary = Color(0xFFa7beb2);
const colorPrimaryDark = Color(0xFF44524a);
const colorAccent = Color(0xFF7d8f83);
const colorPrimaryBg = Color.fromARGB(255, 241, 246, 244);

const color_gray = Color(0xFF626C74);
const color_red_light = Color(0xFFEFAEB4);

const color_blue_light = Color(0xFF77c9d4);
const color_blue_lighter = Color(0xFFb5d7d7);

const color_white = Color(0xFFffffff);
const color_gray_button = Color(0xFFebebeb);
const color_gray_light_transparent_40 = Color(0xFF66f3f3f3);
const color_gray_light = Color(0xFFf3f3f3);
const color_gray_text =Color(0xFF000000);
const color_semi_gray_text = Color(0xFF979797);
const color_gray_light_text = Color(0xFFdbdbdb);
const color_text_black = Color.fromARGB(255, 58, 58, 58);
const color_black = Color(0xFF000000);
const color_black_transparent = Color(0xFF80000000);
const color_gray_background = Color.fromARGB(255, 241, 242, 245);

const color_red = Color(0xFFe41523);
const bg_callingbar = Color(0xFF59D038);

const color_facebook_bg = Color(0xFF3b5998);
const color_facebook_bg_light = Color(0xFFFF3B6698);

const color_intercom_bg_blue = Color(0xFF178dd1);

const light_gray = Color(0xFFdbdbdb);
const gray = Color(0xFF7e7e7e);
const semi_gray = Color(0xFF979797);
const dark_gray = Color(0xFF696969);
const bg_color = Color(0xFFf7f7f7);
const icon_gray = Color(0xFFe5e5e7);
const bg_gray = Color(0xFFf5f5f5);

const black = Color(0xFF000000);
const white = Color(0xFFffffff);
const black_effective = Color(0xFF2a2a2a);
const shadow = Color(0xFFd0d8dc);
const transparent = Color(0xFF00000000);
const translucent_white = Color(0xFF88ffffff);
const fb = Color(0xFF3b5998);
const google = Color(0xFFd34836);

const red_dark = Color(0xFFF06423);
const red_dark2 = Color(0xFFD85A1B);
const cyan_light = Color(0xFFc9ebee);
const cyan = Color(0xFFb5e3e7);
const cyan_dark = Color(0xFF70BDC6);
const navy_blue = Color(0xFF214258);
const navy_blue_dark = Color(0xFF1C3A4E);
const light_green = Color(0xFF78DC96);

const light_blue = Color(0xFF55C8F0);
const color_light_blue_dark = Color(0xFF2bade0);
const color_light_blue = Color(0xFF00b4ff);

const blue_black_dark = Color(0xFF13171d);
const blue_black_light = Color(0xFF516179);
const blue_grey_light = Color(0xFFA5B4C8);
const orange = Color(0xFFFFA500);
const orange_light = Color(0xFFFFC90E);
const yellow = Color(0xFFfff44f);
const start_gardius = Color(0xFF00B6B2);
const kDefaulColors = [
  Color(0xFF51b3b1),
];

const colorBgMessage = Color(0xFFc5e7e7);
const colorTextTimeChat = Color(0xFFc7c7cc);
const colorTextChat = Color(0xFF292929);
const colorChat = Color(0xFFf6f6f6);
const colorBgSlide =  Color(0xFF4597ec);  

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
