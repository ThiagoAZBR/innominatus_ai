class UnexpectedException implements Exception {}

class CantGenerateTranslatedFieldsOfStudyException {
  const CantGenerateTranslatedFieldsOfStudyException();
}

class MissingLanguageCacheException implements Exception {}

class MissingContentCacheException implements Exception {
  const MissingContentCacheException();
}

class HomologResponse implements Exception {}

class UnableToValidatePremiumStatus implements Exception {
  final String message;
  const UnableToValidatePremiumStatus({
    this.message =
        'Ainda não conseguimos verificar se o processo de ativação da sua assinatura já foi concluído.\n\nPor favor, tente novamente mais tarde.',
  });
}

class ThereIsNoPurchaseToRestore implements Exception {
  final String message;

  const ThereIsNoPurchaseToRestore({
    this.message =
        'Você não possui assinaturas para restaurar.\n\nRealize a assinatura do Chaos IO Premium para poder receber diversos benefícios!',
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
