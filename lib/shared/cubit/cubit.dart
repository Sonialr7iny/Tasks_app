import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/shared/cubit/states.dart';

import '../../modules/archive/archive_screen.dart';
import '../../modules/done/done_screen.dart';
import '../../modules/tasks/task_screen.dart';
import '../../task_db.dart';

class AppCubit extends Cubit<AppStates> {
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screen = [
   const TaskScreen(),
   const DoneScreen(),
   const ArchiveScreen(),
  ];
  List<String> title = [
    'Tasks',
    'Done',
    'Archive',
  ];
  IconData febIcon = Icons.edit;
  bool isBottomSheetShown = false;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  TaskDb taskDb = TaskDb();
  IconData checkIcon=Icons.check_box_outlined;

  AppCubit() : super(AppInitialState()){
    loadTasks();
  }

  void changeIndex(int index)  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    febIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  Future<void>loadTasks() async {
    emit(AppGetDatabaseLoadingState());
try{
  final List<Map> allTasks=await taskDb.getDb();
  newTasks.clear();
  doneTasks.clear();
  archivedTasks.clear();

  for(var task in allTasks){
    if(task['status']=='new'){
      newTasks.add(task);

    }
    else if(task['status']=='done'){
      doneTasks.add(task);

    }
    else if(task['status']=='archive'){
      archivedTasks.add(task);
    }
  }
  if(kDebugMode){
    print('CUBIT loadTasks: New :${newTasks.length},Done:${doneTasks.length},Archived:${archivedTasks.length}');
  }
  emit(AppGetDatabaseState());
}catch(e,s){
  if(kDebugMode){
    print('Error loading tasks from DB : $e');
    print('Stacktrace:$s');
  }
  emit(AppDatabaseErrorState(e.toString()));
}


  }

  Future<void> insert({
    required String title,
    required String time,
    required String date,
  }) async {
    try {
      await taskDb.insertToTask(title, time, date);
      // emit(AppInsertDatabaseState());
      if (kDebugMode) {
        print("Cubit insert: taskDb.insertToTask completed.");
      }
      await loadTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting task:$e');
        emit(AppDatabaseErrorState(e.toString()));
      }
    }
  }

  Future<void> updateTasks({
    required String status,
    required int id,
  }) async {
    try {
      await taskDb.updateData(status: status, id: id);
      // emit(AppUpdateDatabaseState());
      if (kDebugMode) {
        print('Cubit update: taskDb.Update completed for id:$id to status : $status');
      }
      await loadTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating tasks :$e');
        emit(AppDatabaseErrorState(e.toString()));
      }
    }
  }
  Future<void> deleteFromTasks({required int id})async{
    try{
      await taskDb.deleteData(id: id);
      if(kDebugMode){
        print('=============Cubit delete: tasksDb.delete completed with id :$id=======');
      }
      await loadTasks();
    }catch(e){
      if(kDebugMode){
        print('Error deleting task:$e');
        emit(AppDatabaseErrorState(e.toString()));
      }
    }
    emit(AppDeleteDatabaseState());
  }
}
