import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo_app/modules/archived_task/archived_task_screen.dart';
import 'package:new_todo_app/modules/done_task/done_task_screen.dart';
import 'package:new_todo_app/modules/new_task/new_task_screen.dart';
import 'package:new_todo_app/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const NewTaskScreen(),
    const DoneTaskScreen(),
    const ArchivedTaskScreen(),
  ];
  List<String> titles = [
    'New Task',
    'Done Task',
    'Archived Task',
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool isShowBottomSheet = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  })
  {
    isShowBottomSheet = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void createDatabase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database Created');
        database.execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
            .then((value) {
          print('Table Created');
        }).catchError((error) {
          print('Error when database created ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database Opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await database!.transaction((txn) async {
      txn.rawInsert(
              'INSERT INTO tasks (title,time,date,status) VALUES ("$title","$time","$date","new")')
          .then((value) {
        print('$value Inserting Successfully');
        emit(AppInsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when database inserting ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element) {
        if(element['status'] == 'new')
        {
          newTasks.add(element);
        }else if(element['status'] == 'done')
        {
          doneTasks.add(element);
        }else{
          archiveTasks.add(element);
        }
      });


      emit(AppGetDatabaseState());
    });
  }


  void updateData({
    required String status,
    required int id,
})
  {
     database!.rawUpdate(
         'UPDATE tasks SET status = ? WHERE id = ?',
         ['$status', id]).then((value)
     {
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());

     }).catchError((error)
     {
       print('Error is ${error.toString()}');
     });
  }

  void deleteData({
    required int id,
  })
  {
    database!.rawDelete
      ('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());

    }).catchError((error)
    {
      print('Error is ${error.toString()}');
    });
  }


}
