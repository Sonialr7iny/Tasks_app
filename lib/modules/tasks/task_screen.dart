import 'package:flutter/material.dart';
import 'package:tasks_app/shared/components/components.dart';
import 'package:tasks_app/shared/components/constants.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Tasks ........."));
    // ListView.separated(
    //   itemBuilder: (context, index) => buildTaskItems(tasks[index]),
    //   separatorBuilder: (context, index) => Padding(
    //     padding: const EdgeInsetsDirectional.only(start: 20.0),
    //     child: Container(
    //           width: double.infinity,
    //           color: Colors.grey[300],
    //           height: 1.0,
    //         ),
    //   ),
    //   itemCount:tasks.length);
  }
}
