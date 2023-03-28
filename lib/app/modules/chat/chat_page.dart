import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/chat/widgets/typing_indicator.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../core/app_controller.dart';
import '../../domain/usecases/create_chat_completion.dart';
import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';
import '../home/app_states.dart';

class ChatPage extends StatelessWidget {
  final AppController appController;
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
                                          child: Text(
                                            chatMessage.message,
                                            style: AppTextStyles.interLittle(),
                                          ),
                                        ))
                                    : MessageBox(
                                        backgroundColor: AppColors.secondary,
                                        child: Text(
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
                                          is MissingRequisitesState) {
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
                                          if (state is HttpErrorState) {
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
                    visible: appController.appState is MissingRequisitesState,
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

class MessageBox extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets margin;

  const MessageBox({
    Key? key,
    required this.child,
    this.backgroundColor = AppColors.primary,
    this.margin = const EdgeInsets.only(bottom: 24),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      margin: margin,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: child,
      ),
    );
  }
}
