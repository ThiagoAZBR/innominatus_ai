import 'package:flutter/widgets.dart';

class RouteUtils {
  static getArgs(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments;
}
