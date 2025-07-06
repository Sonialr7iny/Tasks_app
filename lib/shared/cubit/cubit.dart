import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/shared/cubit/states.dart';

import '../../modules/archive/archive_screen.dart';
import '../../modules/done/done_screen.dart';
import '../../modules/tasks/task_screen.dart';
import '../../task_db.dart';
import '../components/constants.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screen = [
    TaskScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List<String> title = [
    'Tasks',
    'Done',
    'Archive',
  ];
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }

  IconData febIcon = Icons.edit;
  bool isBottomSheetShown = false;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
}){
    isBottomSheetShown=isShow;
    febIcon=icon;
    emit(AppChangeBottomSheetState());
  }


  List<Map> tasks=[];
  TaskDb taskDb = TaskDb();
  Future<List<Map>> getDate()async => tasks=await taskDb.getDb();
  void insert({
    required String title,
    required String time,
    required String date,
}){
    taskDb.insertToTask(title, time, date);
    emit(AppInsertDatabaseState());
  }

}