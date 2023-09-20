import 'package:http/http.dart' as http;
import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';
import 'package:innominatus_ai/app/domain/usecases/class/stream_create_class_use_case.dart';
import 'package:innominatus_ai/app/modules/class/controllers/states/class_states.dart';
import 'package:rx_notifier/rx_notifier.dart';

class ClassController {
  final CreateClassUseCase createClassUseCase;
  final StreamCreateClassUseCase streamCreateClassUseCase;

  String classContentStream = '';
  Future<http.StreamedResponse>? streamClassContent;

  final RxNotifier _state = RxNotifier<ClassState>(
    const ClassIsLoadingState(),
  );

  Future<void> createClass(CreateClassParams params) async {
    final response = await createClassUseCase(params: params);

    response.fold(
      (failure) => setClassError(),
      (data) => setClassDefault(
        data,
        params.className,
      ),
    );
  }

  void streamCreateClass(CreateClassParams params) {
    final response = streamCreateClassUseCase(params: params);

    response.fold(
      (failure) => setClassError(),
      (data) {
        streamClassContent = data;
        _state.value = ClassDefaultState(className: params.className);
      },
    );
  }

  ClassController(
    this.createClassUseCase,
    this.streamCreateClassUseCase,
  );

  // Getters and Setters
  ClassState get state => _state.value;

  void setClassLoading() => _state.value = const ClassIsLoadingState();
  void setClassError() => _state.value = const ClassWithErrorState();
  void setClassDefault([
    String? classContent,
    String? className,
  ]) =>
      _state.value = ClassDefaultState(
        classContent: classContent,
        className: className,
      );
}
