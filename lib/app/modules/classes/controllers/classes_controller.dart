import 'package:rx_notifier/rx_notifier.dart';

class ClassesController {
  final RxNotifier _isClassesLoading = RxNotifier(true);

  // Getters and Setters
  bool get isClassesLoading => _isClassesLoading.value;
  set isClassesLoading(bool value) => _isClassesLoading.value = value;
}
