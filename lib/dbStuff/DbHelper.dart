import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DbHelper {

  static Database db;

  Future<Database> get database async{

    if( db==null){
     db= await initDB();
    }

    return db;
  }



  initDB() async {

   io.Directory dd= await getApplicationDocumentsDirectory();
   String path= join(dd.path,"myDb.db");
   var db=await openDatabase(path,version: 1,onCreate: onCreatDB);
   return db;
  }
     
   
  void onCreatDB(Database db, int version) async {
  
    await db.execute("create table lists (id INTEGER PRIMARY KEY AUTOINCREMENT,title varchar(80),desc varchar(150));");
    await db.execute("create table sublist (listid INTEGER , title varchar(80) , isChecked boolean , FOREIGN KEY  (listid) REFERENCES lists(id));");
  }

  Future<List<Obj>> getLists(String query) async {
    var db_connection= await database;
    List<Map> list= await db_connection.rawQuery(query);
    List<Obj>objList=[];
    List<ObjJunior> listj=[new ObjJunior("title")];
    for(int i=0;i<list.length;i++){
      
      int id=list[i]['id'];
       List<ObjJunior> listj=[];
       listj= await getSubLists("select * from sublist where listid like $id;");
       
       Obj obj=new Obj(list[i]['title'],list[i]['desc'],listj);
       obj.id=id;
      objList.add(obj);
    }
   return objList;

  }

  Future<List<ObjJunior>> getSubLists(String query) async {
    var db_connection= await database;
    List<Map> list= await db_connection.rawQuery(query);
     List<ObjJunior> objList=[];

    for(int i=0;i<list.length;i++){
      ObjJunior objJunior=new ObjJunior(list[i]['title']);
      if(list[i]['isChecked']=="true"){objJunior.isChecked=true;}else{objJunior.isChecked=false;}
      
      objList.add(objJunior);
    }
    return objList;
  }

  void addList(Obj obj) async{
    var db_connection=await database;
    String t =obj.title;
    String desc=obj.desc;
    await db_connection.transaction((transaction) async{
      await transaction.rawInsert("insert into lists (title,desc) values('$t','$desc');");
      List<Map> list= await transaction.rawQuery("select id from lists where title like '$t' and desc like '$desc';");
      int id= list[0]['id'];
      
      for(int i=0;i<obj.list.length;i++){
        String title=obj.list[i].title;
        bool isChecked=obj.list[i].isChecked;
        await transaction.rawInsert("insert into sublist (listid,title,isChecked) values($id,'$title','$isChecked');");
      }
      return true;
    });
  }

  Future<int> updateList(String query) async{
    var db_connection=await database;
    return db_connection.rawUpdate(query);
  }

}

class Obj {
  int id;
  String title;
  String desc;
  List<ObjJunior> list;
  Obj(String title,String desc,List<ObjJunior> list){
    this.title=title;
    this.desc=desc;
    this.list=list;
    
  }
  
  
}

class ObjJunior {
  String title;
  bool isChecked;
  ObjJunior(String title){
    this.title=title;
    isChecked=false;
  }


}