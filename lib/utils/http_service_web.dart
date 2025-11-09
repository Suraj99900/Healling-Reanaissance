
import 'dart:js' as js;


void webLaunch(String url) {
  js.context.callMethod('open', [url, '_blank']);
}