import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';
import 'package:innominatus_ai/app/modules/class/controllers/states/class_states.dart';
import 'package:rx_notifier/rx_notifier.dart';

class ClassController {
  final CreateClassUseCase createClassUseCase;

  final RxNotifier _state = RxNotifier<ClassState>(
    const ClassIsLoadingState(),
  );

  Future<void> createClass(CreateClassParams params) async {
    final response = await createClassUseCase(params: params);

    response.fold(
      (failure) => setClassError(),
      setClassDefault,
    );
  }

  ClassController(this.createClassUseCase);

  // Getters and Setters
  ClassState get state => _state.value;

  void setClassLoading() => _state.value = const ClassIsLoadingState();
  void setClassError() => _state.value = const ClassWithErrorState();
  void setClassDefault([
    String? classContent,
  ]) =>
      _state.value = ClassDefaultState(classContent: classContent);
}
