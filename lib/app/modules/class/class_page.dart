import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/domain/usecases/class/create_class_use_case.dart';
import 'package:innominatus_ai/app/modules/class/controllers/class_controller.dart';
import 'package:innominatus_ai/app/modules/class/controllers/states/class_states.dart';
import 'package:innominatus_ai/app/modules/class/widgets/states/class_default.dart';
import 'package:innominatus_ai/app/modules/class/widgets/states/class_is_loading.dart';
import 'package:innominatus_ai/app/modules/class/widgets/states/class_with_error.dart';
import 'package:innominatus_ai/app/shared/containers/class_container.dart';
import 'package:innominatus_ai/app/shared/routes/args/class_page_args.dart';
import 'package:innominatus_ai/app/shared/utils/route_utils.dart';
import 'package:innominatus_ai/app/shared/widgets/app_scaffold/app_scaffold.dart';
import 'package:rx_notifier/rx_notifier.dart';

class ClassPage extends StatefulWidget {
  final ClassController controller;
  const ClassPage({super.key, required this.controller});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  ClassPageArgs? args;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    args = RouteUtils.getArgs(context) as ClassPageArgs?;
    await controller.appController.checkUserPremiumStatus();
    if (args != null) {
      await controller.createClass(
        CreateClassParams(
          className: args!.className,
          subject: args!.subject,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    ClassContainer().dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapBuilder = {
      const ClassIsLoadingState().toString(): const ClassIsLoading(),
      const ClassWithErrorState().toString(): ClassWithError(
        classController: controller,
      ),
      const ClassDefaultState().toString():
          ClassDefault(controller: controller),
    };

    return AppScaffold(
      child: SingleChildScrollView(
        child: RxBuilder(
          builder: (_) => mapBuilder[controller.state.toString()]!,
        ),
      ),
    );
  }

  ClassController get controller => widget.controller;
}
