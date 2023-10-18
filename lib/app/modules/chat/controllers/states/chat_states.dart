abstract class ChatState {
  const ChatState();
}

class ChatLoadingState implements ChatState {
  const ChatLoadingState();
}

class ChatHttpErrorState implements ChatState {
  const ChatHttpErrorState();
}

class ChatMissingRequisitesState implements ChatState {
  const ChatMissingRequisitesState();
}

class ChatLimitationNonPremiumUserState implements ChatState {
  const ChatLimitationNonPremiumUserState();
}

class ChatDefaultState implements ChatState {
  const ChatDefaultState();
}
