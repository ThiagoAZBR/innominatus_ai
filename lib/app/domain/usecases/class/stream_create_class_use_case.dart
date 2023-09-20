import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:innominatus_ai/app/data/chat_repository.dart';
import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';

class StreamCreateClassUseCase {
  final ChatRepository chatRepository;

  StreamCreateClassUseCase(this.chatRepository);

  Either<Exception, Future<http.StreamedResponse>> call({
    required CreateClassParams params,
  }) {
    return chatRepository.streamCreateClass(params);
  }
}
