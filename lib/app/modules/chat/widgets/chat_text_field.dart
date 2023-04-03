import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/chat/controllers/chat_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../../domain/usecases/create_chat_completion.dart';
import '../../../shared/themes/app_color.dart';
import '../controllers/states/chat_states.dart';

class ChatTextField extends StatelessWidget {
  final ChatController chatController;
  const ChatTextField({
    Key? key,
    required this.chatController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.only(
        top: 8,
        left: 14,
        bottom: 32,
        right: 14,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              offset: const Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
          ),
          child: RxBuilder(
            builder: (_) => AbsorbPointer(
              absorbing: chatController.isLoading(),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: TextField(
                      onChanged: (text) {
                        if (chatController.appState
                            is ChatMissingRequisitesState) {
                          chatController.setTextFieldError(null);
                        }
                      },
                      controller: chatController.messageFieldController,
                      focusNode: chatController.messageFieldFocusNode,
                      cursorColor: AppColors.black,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: ' Mensagem...',
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            final state =
                                await chatController.createChatCompletion(
                              CreateChatCompletionParam(
                                chatController.messageFieldController.text,
                              ),
                            );
                            if (state is ChatHttpErrorState) {
                              chatController.showErrorToUser();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.send_rounded,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
