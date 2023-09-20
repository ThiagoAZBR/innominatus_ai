import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:innominatus_ai/app/modules/class/controllers/class_controller.dart';
import 'package:innominatus_ai/app/modules/class/controllers/states/class_states.dart';
import 'package:innominatus_ai/app/shared/themes/app_text_styles.dart';

class ClassDefault extends StatelessWidget {
  final ClassController controller;
  const ClassDefault({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            state.className!,
            style: AppTextStyles.interHuge(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          controller.streamClassContent != null
              ? StreamBuilder(
                  stream: controller.streamClassContent!.asStream(),
                  builder: (context, snapshotFirst) {
                    if (snapshotFirst.hasData) {
                      return StreamBuilder(
                          stream: snapshotFirst.data!.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final String stringfyContent = formatStringfyJson(
                                utf8.decode(snapshot.data!),
                              );

                              final List contentList =
                                  json.decode(stringfyContent);

                              final List<String> classContent = contentList
                                  .map((e) => ClassContent.fromMap(e).content)
                                  .toList();

                              controller.classContentStream +=
                                  (classContent.reduce((a, b) => a + b));

                              return Text(
                                formatText(controller.classContentStream),
                                style:
                                    AppTextStyles.interMedium(lineHeight: 1.3),
                                textAlign: TextAlign.left,
                              );
                            }
                            return const SizedBox();
                          });
                    }
                    return const SizedBox();
                  })
              : Text(
                  formatText(state.classContent!),
                  style: AppTextStyles.interMedium(lineHeight: 1.3),
                  textAlign: TextAlign.left,
                ),
        ],
      ),
    );
  }

  String formatText(String classContent) {
    if (classContent.contains('Claro!')) {
      return classContent
          .replaceFirst('Claro! ', '')
          .replaceAll('\n-', '\n\n-');
    }
    return classContent.replaceAll('\n-', '\n\n-');
  }

  ClassDefaultState get state => controller.state as ClassDefaultState;
}

class ClassContent {
  final String content;

  ClassContent({
    required this.content,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'content': content});

    return result;
  }

  factory ClassContent.fromMap(Map<String, dynamic> map) {
    return ClassContent(
      content: map['content'] ?? '',
    );
  }
}

String formatStringfyJson(String content) {
  content = content.replaceAll('}', '},');
  content = content.replaceFirst('{', '[{');
  int lastBracket = content.lastIndexOf('},');
  content = content.replaceRange(lastBracket, null, '}]');

  return content;
}
