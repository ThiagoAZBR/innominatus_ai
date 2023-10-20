class UnexpectedException implements Exception {}

class EmptyCacheException implements Exception {}

class HomologResponse implements Exception {}

class UnableToValidatePremiumStatus implements Exception {
  final String message;
  const UnableToValidatePremiumStatus({
    this.message =
        'Ainda não conseguimos verificar se o processo de ativação da sua assinatura já foi concluído.\n\nPor favor, tente novamente mais tarde.',
  });
}

class UnableToMakeSubscriptionPurchase implements Exception {
  final String message;
  const UnableToMakeSubscriptionPurchase({
    this.message =
        'Infelizmente ocorreu um problema ao tentar adquirir a sua assinatura e não conseguimos completar o processo de pagamento.\n\nPor favor, tente novamente mais tarde.',
  });
}

class CancelledPurchaseByUser implements Exception {
  const CancelledPurchaseByUser();
}
