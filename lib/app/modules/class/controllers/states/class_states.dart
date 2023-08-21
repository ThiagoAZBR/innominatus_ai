abstract class ClassState {
  const ClassState();
}

class ClassIsLoadingState implements ClassState {
  const ClassIsLoadingState();
}

class ClassWithErrorState implements ClassState {
  const ClassWithErrorState();
}

class ClassDefaultState implements ClassState {
  final String? classContent;
  final String? className;
  const ClassDefaultState({this.className, this.classContent});
}
