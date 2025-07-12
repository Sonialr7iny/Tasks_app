import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/shared/components/components.dart';
import 'package:tasks_app/shared/cubit/cubit.dart';
import 'package:tasks_app/shared/cubit/states.dart';
import 'package:tasks_app/task_db.dart';


import '../shared/components/constants.dart';
class HomeLayoutScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TaskDb taskDb=TaskDb();

  HomeLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (BuildContext context, AppStates state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(
                  cubit.title[cubit.currentIndex],
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.indigo[400],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.indigo[400],
                shape: CircleBorder(),
                onPressed: ()async {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      try{
                        if(kDebugMode){
                          print('FAB: Attempting taskDb.insertToTask ...');
                        }
                        await taskDb.insertToTask(
                            titleController.text,
                            timeController.text,
                            dateController.text
                        );
                        if(kDebugMode){
                          print('FAB: taskDb.insertTask completed.');
                        }
                        if(kDebugMode){
                         print('FAB: Starting 200ms delay before getDb ... ');
                        }
                        await Future.delayed(const Duration(microseconds: 2000));
                        if(kDebugMode){
                          print('FAB: Delay finished. Attempting taskDB.getDb() ...');
                        }

                        List<Map> localTasksResult=await taskDb.getDb();
                        if(kDebugMode){
                          print('FAB: taskDb.getDb() completed. Records received: ${localTasksResult.length}');
                        }
                        print('FAB: ------------------- TASKS VIA taskDb.getDb() ----------------------');
                        if(localTasksResult.isNotEmpty){
                          print('FAB: First task from getDb: ${localTasksResult.first}');
                          if(localTasksResult.length>1){
                            print('FAB: Last task from getDb: ${localTasksResult.last}');
                          }

                          print('FAB: Full list from getDb (attempting direct print): $localTasksResult');
                        }else{
                          print('FAB: taskDb.getDb() returned an empty list or null');
                        }

                        tasks=localTasksResult;
                      }catch(e,s){
                        if(kDebugMode){
                          print('FAB: !!! CRITICAL ERROR in FAB onPressed: ${e.toString()}');
                          print('FAB: Stacktrace: $s');
                        }
                      }finally{
                        if(Navigator.canPop(context)){
                          Navigator.pop(context);
                        }
                        cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                      }
                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet((context) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                        controller: titleController,
                                          validate: (value) {
                                            if (value.isEmpty) {
                                              return 'Title must not be empty!';
                                            }
                                            return null;
                                          },
                                          type: TextInputType.text,
                                          text: 'Title',
                                          prefix: Icons.title),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      defaultFormField(
                                        controller: timeController,
                                          validate: (value) {
                                            if (value.isEmpty) {
                                              return 'Time must not be empty!';
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) {
                                              timeController.text =
                                                  value!.format(context);
                                            });
                                          },
                                          type: TextInputType.text,
                                          text: 'Time',
                                          prefix: Icons.watch_later_outlined),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      defaultFormField(
                                        controller: dateController,
                                          validate: (value) {
                                            if (value.isEmpty) {
                                              return 'Date must not be empty!';
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2025-12-12')).then((value){
                                              dateController.text =
                                                  DateFormat.yMMMd().format(
                                                      value as DateTime);

                                            });


                                          },
                                          type: TextInputType.text,
                                          text: 'Date',
                                          prefix: Icons.calendar_month),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .closed
                        .then((value) {
                      if (cubit.isBottomSheetShown) {
                        cubit.changeBottomSheetState(
                            isShow: false, icon: Icons.edit);
                      }
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                elevation: 9.0,
                child: Icon(
                  cubit.febIcon,
                  color: Colors.white,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: cubit.currentIndex,
                  onTap: (value) {
                    cubit.changeIndex(value);
                    if(kDebugMode){
                      print('Tasks : $tasks');
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_outlined),
                      activeIcon: Icon(Icons.menu),
                      label: 'Tasks',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline),
                      activeIcon: Icon(Icons.check_circle),
                      label: 'Done',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      activeIcon: Icon(Icons.archive),
                      label: 'Archive',
                    ),
                  ]),
              body: cubit.screen[cubit.currentIndex],
            );
          },
        ));
  }
}
