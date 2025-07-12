import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/layout/home_layout_screen.dart';
import 'package:tasks_app/shared/style/bloc_observer.dart';
import 'package:tasks_app/task_db.dart';
import 'layout/home_layout.dart';

// void testDatabaseOperations()async{
//   print('--- Starting Database Tast ---');
//   TaskDb myTaskDb=TaskDb();
//   await myTaskDb.initDb();
//   print('Initial task from DB:');
//   List<Map> initialTasks=await myTaskDb.getDb();
//   initialTasks.forEach((task)=>print(task));
//   print('Initial task count :${initialTasks.length}');

  // String testTitle='Test TaskDB${DateTime.now().microsecondsSinceEpoch}';
  // String testTime='10:00 AM';
  // String testDate='Jul 20, 2025';
  //
  // print("Attempting to insert: Title:$testTitle,Time :$testTime,Date:$testDate");
  // try{
  //   dynamic insertResult= myTaskDb.insertToTask(testTitle, testTime, testDate);
  //   print('Insert operation complated . Result (if any): $insertResult');
  // }catch(e){
  //   print('ERROR during insertToTask: $e');
  //   return;
  // }
  // print('Tasks from DB AFTER insert attempt:');
  // List <Map> taskAfterInsert=await myTaskDb.getDb();
  // bool found=false;
  // taskAfterInsert.forEach((task){
  //   print(task);
  //   if(task['title']==testTitle){
  //     found=true;
  //   }
  // });
  // print('Task count after insert: ${taskAfterInsert.length}');
  // if(found){
  //   print(("SUCCESS: Test task '$testTitle'was found in the database !"));
  // }else{
  //   print(("FAILURE: Test task '$testTitle'was NOT found in the database after insert attempt."));
  // }
//   print('--- Database Test Finished ---');
// }


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // testDatabaseOperations();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override


  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.indigo
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          splashFactory: InkSplash.splashFactory
      ),

      home: HomeLayout(),
    );
  }
}
