import 'package:innominatus_ai/app/modules/classes/controllers/states/classes_state.dart';
import 'package:rx_notifier/rx_notifier.dart';

class ClassesController {
  final RxNotifier _state$ = RxNotifier<ClassesState>(ClassesSelectionState());
  final RxNotifier _isClassesLoading = RxNotifier(true);

  // Getters and Setters
  bool get isClassesLoading$ => _isClassesLoading.value;
  set isClassesLoading$(bool value) => _isClassesLoading.value = value;

  void startClassesLoading() => isClassesLoading$ = true;
  void endClassesLoading() => isClassesLoading$ = false;

  ClassesState get state$ => _state$.value;
  void setError() => _state$.value = ClassesErrorState();
}
