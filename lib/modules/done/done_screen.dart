import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({super.key});

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context,AppStates state) {
        if (kDebugMode) {
          print('Hello consumer in Task Screen !!!!!------');
        }
      },
      buildWhen: (previous,current){
        return current is AppGetDatabaseState||
            current is AppGetDatabaseLoadingState||
            current is AppInitialState;
      },
      builder: (BuildContext context,AppStates state) {
        AppCubit cubit=AppCubit.get(context);
        var tasks=cubit.doneTasks;
        if(state is AppGetDatabaseLoadingState && tasks.isEmpty){
          return const Center(child:CircularProgressIndicator());
        }
        if(tasks.isEmpty){
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle,size: 100,color: Colors.grey,),
                Text('No done tasks yet!',style: TextStyle(fontSize: 18,color: Colors.grey),)
              ],
            ),
          );
        }
        return Center(
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    buildTaskItems(tasks[index],context),
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
