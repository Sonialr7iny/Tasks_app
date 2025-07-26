import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/shared/components/components.dart';
import 'package:tasks_app/shared/cubit/cubit.dart';
import 'package:tasks_app/shared/cubit/states.dart';

import '../task_db.dart';

class HomeLayout extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();


  HomeLayout({super.key});

  // @override
  // void dispose() {
  //   titleController.dispose();
  //   timeController.dispose();
  //   dateController.dispose();
  //   super.dispose();
  // }

  void _clearController() {
    titleController.clear();
    timeController.clear();
    dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getDate(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(kDebugMode){
            print('Listener received state :$state');
            if (state is AppGetDatabaseState) {
              print('Listener saw AppGetDatabaseState. Tasks: ${AppCubit.get(context).tasks.length}');
            }
          }
          if(state is AppGetDatabaseState&&AppCubit.get(context).isBottomSheetShown){
            WidgetsBinding.instance.addPostFrameCallback((_){
              if(AppCubit.get(context).isBottomSheetShown){
                Navigator.pop(context);
              }
            });
          }
        },
        builder: (BuildContext context, AppStates state) {
          // if (kDebugMode) {
          //   print('----- BlocConsumer Builder -----');
          //   print('Current AppState: $state');
          //   AppCubit cubitForDebug=AppCubit.get(context);
          //   print('cubit.tasks before UI build:${cubitForDebug.tasks}');
          //   print('cubit.currentIndex: ${cubitForDebug.currentIndex}');
          //   print('-------------------------------------------,');
          // }
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentIndex],
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.indigo,
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.indigo[400],
              shape: CircleBorder(),
              onPressed: () async {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate())  {
                    await cubit.insert(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text).then((_)async{
                              _clearController();
                              cubit.changeBottomSheetState(
                                  isShow: false, icon: Icons.edit);
                              cubit.tasks = await cubit.taskDb.getDb();

                    }).catchError((e){
                      if(kDebugMode){
                        print('Error when insert data to DB: $e');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save task, please try again')));
                    });
                    if (kDebugMode) {
                      print("FAB: cubit.insert() awaited and completed.");
                      print("FAB: cubit.tasks after insert: ${cubit.tasks}");
                    }

                    Navigator.pop(context);
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          elevation: 20.0,
                          (context) => Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                          controller: titleController,
                                          type: TextInputType.text,
                                          text: 'Title',
                                          prefix: Icons.title,
                                          validate: (value) {
                                            if (value.isEmpty) {
                                              return 'Title must not be empty';
                                            }
                                            return null;
                                          }),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      defaultFormField(
                                          controller: timeController,
                                          type: TextInputType.text,
                                          text: 'Time',
                                          prefix: Icons.access_time,
                                          validate: (value) {
                                            if (value.isEmpty) {
                                              return 'Time must not be empty';
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) {
                                              timeController.text = value!
                                                  .format(context)
                                                  .toString();
                                            });
                                          }),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      defaultFormField(
                                          controller: dateController,
                                          type: TextInputType.text,
                                          text: 'Date',
                                          prefix: Icons.calendar_month,
                                          validate: (value) {
                                            if (value.isEmpty) {
                                              return 'Date must not be empty';
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            dateController.clear();
                                            showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.parse(
                                                        '2025-12-12'))
                                                .then((value) {
                                              dateController.text =
                                                  DateFormat.yMMMd().format(
                                                      value as DateTime);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ))
                      .closed
                      .then((value) {
                        if(cubit.isBottomSheetShown) {
                          cubit.changeBottomSheetState(
                              isShow: false, icon: Icons.edit);
                        }
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  _clearController();
                }
              },
              child: Icon(
                cubit.febIcon,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (value) async{
                cubit.changeIndex(value);
                // await cubit.getDate();
                // if (kDebugMode) {
                //   print('--- BottomNav onTap ---');
                //   print('cubit.tasks after getDate: ${cubit.tasks}');
                //   print('-----------------------');
                // }

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
                    label: 'Archive')
              ],
            ),
            body: state is! AppGetDatabaseLoadingState
                ? Center(child: CircularProgressIndicator())
                : cubit.screen[cubit.currentIndex],
          );
        },
      ),
    );
  }
}
