import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/chat/widgets/typing_indicator.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'controllers/chat_controller.dart';
import '../../domain/usecases/create_chat_completion.dart';
import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';
import 'controllers/states/chat_states.dart';
import 'widgets/message_box.dart';

class ChatPage extends StatelessWidget {
  final ChatController appController;
  const ChatPage({
    Key? key,
    required this.appController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        appController.cleanData();
        return true;
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: RxBuilder(
                        builder: (_) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Icons Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.maybePop(context),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 36),
                            // Messages
                            ...appController.chatMessages$
                                .map((chatMessage) => chatMessage.isUser
                                    ? Align(
                                        alignment: Alignment.topRight,
                                        child: MessageBox(
                                          child: SelectableText(
                                            chatMessage.message,
                                            style: AppTextStyles.interLittle(),
                                          ),
                                        ))
                                    : MessageBox(
                                        backgroundColor: AppColors.secondary,
                                        child: SelectableText(
                                          chatMessage.message,
                                          style: AppTextStyles.interLittle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ))
                                .toList(),
                            Visibility(
                              visible: appController.isLoading(),
                              child: TypingIndicator(
                                showIndicator: appController.isLoading(),
                              ),
                            ),
                            const SizedBox(height: 64),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Text Field
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
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
                        color: AppColors.lightWhite,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        child: RxBuilder(
                          builder: (_) => AbsorbPointer(
                            absorbing: appController.isLoading(),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: TextField(
                                    onChanged: (text) {
                                      if (appController.appState
                                          is ChatMissingRequisitesState) {
                                        appController.setTextFieldError(null);
                                      }
                                    },
                                    controller:
                                        appController.messageFieldController,
                                    focusNode:
                                        appController.messageFieldFocusNode,
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
                                          final state = await appController
                                              .createChatCompletion(
                                            CreateChatCompletionParam(
                                              appController
                                                  .messageFieldController.text,
                                            ),
                                          );
                                          if (state is ChatHttpErrorState) {
                                            appController.showErrorToUser();
                                          }
                                        },
                                        child: const Icon(
                                          Icons.send,
                                          color: AppColors.black,
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
                  ),
                ),
                RxBuilder(
                  builder: (_) => Visibility(
                    visible:
                        appController.appState is ChatMissingRequisitesState,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                          left: 36,
                        ),
                        child: Text(
                          appController.errorMessage ?? '',
                          style: AppTextStyles.interLittle(color: Colors.red),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
