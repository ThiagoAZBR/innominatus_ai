import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class HomeController {
  final PageController pageController = PageController();
  final _pageCounter$ = RxNotifier(0);

  int get pageCounter => _pageCounter$.value;
  setPageCounter(int newValue) => _pageCounter$.value = newValue;
}
