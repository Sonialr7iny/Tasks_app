abstract class AppStates{}
class AppInitialState extends AppStates{}

class AppChangeBottomNavBarState extends AppStates{}

class AppChangeBottomSheetState extends AppStates{}

class AppInsertDatabaseState extends AppStates{}

class AppGetDatabaseState extends AppStates{}

class AppUpdateDatabaseState extends AppStates{}

class AppDeleteDatabaseState extends AppStates{}

class AppGetDatabaseLoadingState extends AppStates{}

class AppDatabaseErrorState extends AppStates{
  final String error;
  AppDatabaseErrorState(this.error);
}