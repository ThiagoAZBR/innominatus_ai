abstract class ClassState {
  const ClassState();
}

class ClassIsLoadingState implements ClassState {
  const ClassIsLoadingState();
}

class ClassDefaultState implements ClassState {
  final String? classContent;
  const ClassDefaultState({this.classContent});
}

class ClassWithErrorState implements ClassState {
  const ClassWithErrorState();
}
