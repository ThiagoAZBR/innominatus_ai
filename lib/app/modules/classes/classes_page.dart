import 'package:flutter/material.dart';
import 'package:innominatus_ai/app/domain/usecases/roadmap_creation/get_roadmap.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/classes_controller.dart';
import 'package:innominatus_ai/app/modules/classes/controllers/states/classes_state.dart';
import 'package:innominatus_ai/app/modules/classes/widgets/classes_error.dart';
import 'package:innominatus_ai/app/modules/classes/widgets/classes_selection.dart';
import 'package:innominatus_ai/app/shared/containers/classes_container.dart';
import 'package:innominatus_ai/app/shared/routes/app_routes.dart';
import 'package:innominatus_ai/app/shared/routes/args/class_page_args.dart';
import 'package:innominatus_ai/app/shared/routes/args/classes_page_args.dart';
import 'package:innominatus_ai/app/shared/utils/route_utils.dart';
import 'package:innominatus_ai/app/shared/widgets/app_scaffold/app_scaffold.dart';
import 'package:innominatus_ai/app/shared/widgets/continue_floating_button.dart';
import 'package:rx_notifier/rx_notifier.dart';

class ClassesPage extends StatefulWidget {
  final ClassesController controller;

  const ClassesPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  ClassesPageArgs? args;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = RouteUtils.getArgs(context) as ClassesPageArgs?;
    if (args != null) {
      controller.getClassesRoadmap(
        GetRoadmapParams(args!.selectedSubject,Localizations.localeOf(context).languageCode),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    ClassesContainer().dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapBuilder = {
      ClassesSelectionState().toString(): ClassesSelection(
        controller: controller,
      ),
      ClassesErrorState().toString(): const ClassesError(),
    };

    return AppScaffold(
      floatingButton: RxBuilder(
        builder: (_) => Visibility(
          visible: controller.hasAnyClassSelected,
          child: ContinueFloatingButton(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.classPage,
                arguments: ClassPageArgs(
                  className: controller.selectedClass!,
                  subject: args?.selectedSubject ?? '',
                ),
              );
            },
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: RxBuilder(
          builder: (_) => mapBuilder[controller.state$.toString()]!,
        ),
      ),
    );
  }

  ClassesController get controller => widget.controller;
}
