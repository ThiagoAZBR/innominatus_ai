abstract class AppState {
  const AppState();
}

class LoadingState implements AppState {
  const LoadingState();
}

class HttpErrorState implements AppState {
  const HttpErrorState();
}

class MissingRequisitesState implements AppState {
  const MissingRequisitesState();
}

class DefaultState implements AppState {
  const DefaultState();
}
