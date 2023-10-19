abstract class ClassState {
  const ClassState();
}

class ClassIsLoadingState implements ClassState {
  const ClassIsLoadingState();
}

class ClassWithErrorState implements ClassState {
  final bool isNonPremiumLimitation;
  const ClassWithErrorState({this.isNonPremiumLimitation = false});
}

class ClassDefaultState implements ClassState {
  final String? classContent;
  final String? className;
  const ClassDefaultState({this.className, this.classContent});
}
