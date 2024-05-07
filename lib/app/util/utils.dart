import 'package:html_unescape/html_unescape.dart';

class Utils {
  static String decodeHtml(String text) {
    final unescape = HtmlUnescape();
    return unescape.convert(text);
  }
}
