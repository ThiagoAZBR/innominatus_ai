import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/modules/chat/widgets/chat_text_field.dart';
import 'package:innominatus_ai/app/modules/chat/widgets/typing_indicator.dart';
import 'package:innominatus_ai/app/shared/app_constants/app_constants.dart';
import 'package:innominatus_ai/app/shared/containers/chat_container.dart';
import 'package:innominatus_ai/app/shared/core/app_controller.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../shared/themes/app_color.dart';
import '../../shared/themes/app_text_styles.dart';
import 'controllers/chat_controller.dart';
import 'controllers/states/chat_states.dart';
import 'widgets/message_box.dart';

class ChatPage extends StatefulWidget {
  final ChatController chatController;
  const ChatPage({
    Key? key,
    required this.chatController,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.artificialIntelligenceMessages$.add(
        AppConstants.chaosSelfIntroduction(appController.languageCode),
      );
      chatController.chatMessages$.add(
        ChatMessage(
          isUser: false,
          message:
              AppConstants.chaosSelfIntroduction(appController.languageCode),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ChatContainer().dispose();
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
                            ...chatController.chatMessages$
                                .map((chatMessage) => chatMessage.isUser
                                    ? Align(
                                        alignment: Alignment.topRight,
                                        child: MessageBox(
                                          child: SelectableText(
                                            chatMessage.message,
                                            style: AppTextStyles.interSmall(),
                                          ),
                                        ))
                                    : MessageBox(
                                        backgroundColor: AppColors.secondary,
                                        child: SelectableText(
                                          chatMessage.message,
                                          style: AppTextStyles.interSmall(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ))
                                .toList(),
                            Visibility(
                              visible: chatController.isLoading(),
                              child: TypingIndicator(
                                showIndicator: chatController.isLoading(),
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
                  child: ChatTextField(
                    chatController: chatController,
                  ),
                ),
                RxBuilder(
                  builder: (_) => Visibility(
                    visible:
                        chatController.appState is ChatMissingRequisitesState,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                          left: 36,
                        ),
                        child: Text(
                          chatController.errorMessage ?? '',
                          style: AppTextStyles.interSmall(color: Colors.red),
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

  ChatController get chatController => widget.chatController;
  AppController get appController => widget.chatController.appController;
}
