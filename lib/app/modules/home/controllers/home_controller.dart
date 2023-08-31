import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

class HomeController {
  final AppController appController;
  final PageController pageController = PageController();
  final _slideBannerCounter$ = RxNotifier(0);

  HomeController(this.appController);

  // Getters and Setters

  int get slideBannerCounter => _slideBannerCounter$.value;
  setPageCounter(int newValue) => _slideBannerCounter$.value = newValue;
}
