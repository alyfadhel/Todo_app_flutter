import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo_app/shared/components/components.dart';
import 'package:new_todo_app/shared/cubit/cubit.dart';
import 'package:new_todo_app/shared/cubit/states.dart';


class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context, state)
      {
        var tasks = AppCubit.get(context).archiveTasks;
        return  tasksBuilder(context: context, tasks: tasks);
      },
    );
  }
}
