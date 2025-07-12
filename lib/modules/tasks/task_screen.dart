import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/shared/components/components.dart';
import 'package:tasks_app/shared/components/constants.dart';
import 'package:tasks_app/shared/cubit/cubit.dart';
import 'package:tasks_app/shared/cubit/states.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context,AppStates state) {
        print('Hello consumer in Task Screen !!!!!------');
      },
      builder: (BuildContext context,AppStates state) {
        var tasks=AppCubit.get(context).tasks;
        return Center(
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    buildTaskItems(tasks[index]),
                separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsetsDirectional.only(start: 20.0),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                        height: 1.0,
                      ),
                    ),
                itemCount: tasks.length));
      },
    );
  }
}
