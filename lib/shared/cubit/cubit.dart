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
    TaskScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List<String> title = [
    'Tasks',
    'Done',
    'Archive',
  ];
  IconData febIcon = Icons.edit;
  bool isBottomSheetShown = false;
  List<Map> tasks = [];
  TaskDb taskDb = TaskDb();

  AppCubit() : super(AppInitialState());

  void changeIndex(int index) async {
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

  Future<List<Map>> getDate() async {
    await _refreshTasks();
    return tasks = await taskDb.getDb();
  }

  Future<void> updateTasks({
    required String status,
    required int id,
  }) async {
    try {
      await taskDb.updateData(status: status, id: id);
      emit(AppUpdateDatabaseState());
      if (kDebugMode) {
        print('Cubit update: taskDb.Update completed');
        await _refreshTasks();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating tasks :$e');
        emit(AppDatabaseErrorState(e.toString()));
      }
    }
  }

  Future<void> insert({
    required String title,
    required String time,
    required String date,
  }) async {
    try {
      await taskDb.insertToTask(title, time, date);
      emit(AppInsertDatabaseState());
      if (kDebugMode) {
        print("Cubit insert: taskDb.insertToTask completed.");
      }
      await _refreshTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting task:$e');
        emit(AppDatabaseErrorState(e.toString()));
      }
    }
  }

  Future<void> _refreshTasks() async {
    tasks = await taskDb.getDb();
    emit(AppGetDatabaseState());
    emit(AppGetDatabaseLoadingState());
  }
}
