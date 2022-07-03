import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:new_todo_app/shared/components/components.dart';
import 'package:new_todo_app/shared/cubit/cubit.dart';
import 'package:new_todo_app/shared/cubit/states.dart';


class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context, state)
      {
        var tasks = AppCubit.get(context).newTasks;
        return  tasksBuilder(context: context, tasks: tasks);
      },
    );
  }


}
