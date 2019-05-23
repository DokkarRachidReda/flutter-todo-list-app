import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/painting.dart';
import 'package:to_do_app/creatList.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_app/dbStuff/DbHelper.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      home: MyHomePage(title: 'TODO Lists'),
      routes: <String, WidgetBuilder> {
    '/creatList' : (BuildContext context) => new CreatList(),
    
  },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  
  
  final String title;

  @override
  Home createState() => Home();
}


class Home extends State<MyHomePage>  {
     bool first=true;
     List<Obj> list=[];
     var colors=[new Color(0xffff6659),new Color(0xff63a4ff),new Color(0xff000063),new Color(0xff39796b)];
     int currentIndex=0;

     var db=new DbHelper();
   Home()  ;
    
  @override 
  void initstate(){
      super.initState();

  }
 
  @override
  Widget build(BuildContext context)  {
    Widget widget=null;
    
    switch(currentIndex){
      case 0:{widget=homeWidget();break;}
      case 1:{widget=checkedWidget();break;}
      case 2:{widget=homeWidget();break;}
    }
    return Scaffold(
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
         selectedItemColor: Colors.black,
         onTap: (int i){
           setState(() {
            currentIndex=i; 
           });
         },
        items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.home),
           title: new Text('Home'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.check_box),
           title: new Text('Checked'),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.settings),
           title: Text('Settings')
         )
       ],
      ),
      /// We use [Builder] here to use a [context] that is a descendant of [Scaffold]
      /// or else [Scaffold.of] will return null
      
      body: Builder(
        builder: (context) => widget        
      ),
    );
  }



   Widget listAdapter(int index,List<Obj> list){
         
           
        var rng = new Random();
        int colorIndex=rng.nextInt(colors.length);
        return new GestureDetector(

         child: new Column(
         children: <Widget>[
           new Container(
             
             padding: EdgeInsets.all(5),
             decoration: new BoxDecoration(
               color: colors[colorIndex],
             borderRadius: BorderRadius.circular(6),
             ),
              
              child: new Column(
                 children: <Widget>[
                     new Text(list[index].title,style: new TextStyle(color: Colors.white,fontSize: 20,fontWeight:FontWeight.bold ),),
                     new Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                     //child: new Text(list[index].desc,style: new TextStyle(color: Colors.white,fontSize: 15, ),),
                     child: new Container(
                       color: Colors.grey[200],
                       height: 1,
                       width: 100,
                     ),
                     ),
                    
                     new Container(
                       height: 245,
                       width: 170,
                       alignment: Alignment.centerLeft,
                       
                       child: new ListView.builder(
                       itemCount: list[index].list.length,
                       itemBuilder: (BuildContext context,int i){
                        return new Container(
                          //margin: EdgeInsets.all(0),
                          alignment: Alignment.centerLeft,
                          child: new Row(                                                  
                            children: <Widget>[
                            new Checkbox(value: list[index].list[i].isChecked,
                            activeColor: Colors.white,
                            checkColor: Colors.white,
                            
                            onChanged: (bool newValue){
                              int id=list[index].id;
                              String title=list[index].list[i].title;
                              setState(() {
                              db.updateList("update sublist set isChecked='$newValue' where listid=$id  and title like '$title';");
                                   
                                });
                                
                            },
                            ),
                            
                            new Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: new Text(setTextLength(list[index].list[i].title,15),style: new TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.white),),
                            ),
                            ],
                          ),
                        );

                       },
                     ),
                     )
                 ],
               )
             
           )
         ],
        ),
        );
      }



  

  Widget homeWidget(){
        
           
  
  return new Scaffold(
   body: FutureBuilder(
     future: db.getLists("select * from lists"),
     initialData: List(),
     builder: (context, snapshot){

       return Container(
    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
               

                 new Padding(padding: EdgeInsets.fromLTRB(10, 40, 0, 0),                                
                   child: new Row(
                     children: <Widget>[
                       new Container(
                         height: 2,
                         width: 60,
                         color:Colors.grey[300] ,
                         padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                       ),
                       new Text("Tasks",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold)),
                       new Padding(
                         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                         child: new Text("Lists",style: TextStyle(fontSize: 45,fontWeight: FontWeight.w300,color: Colors.grey[600])),
                       ),
                       new Padding(
                         padding: EdgeInsets.fromLTRB(4, 3, 4, 0),
                         child: new Container(
                         height: 2,
                         width: 60,
                         color:Colors.grey[300] ,                    
                       ), 
                       )
                      
                     ],
                   )
                
                 ),
                 new Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: new Center(
                    child:new ButtonTheme(
                   minWidth: 50,
                   height: 55,
                   shape: new ContinuousRectangleBorder(borderRadius:new BorderRadius.circular(10.0),side: BorderSide(color: Colors.grey,width: 1)),
                   child: FlatButton.icon(
                     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                     icon: new Icon(Icons.add,size: 25,),
                     label: new Text(""),
                     onPressed: (){
                       Navigator.of(context).pushNamed('/creatList');
                     },
                   ),
                  ) ,
                  ),
                 ),
                 new Padding(
                   padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                   child: new Center(
                     child: new Text("Add List",style: new TextStyle(fontSize: 12,color: Colors.grey[500]),),
                   ),
                 ),
                new Container(
                       height: 345,
                      // width: 300,
                       padding: EdgeInsets.fromLTRB(10, 40, 0, 0),
                       child: new ListView.builder(
                     itemCount: snapshot.data.length,
                     shrinkWrap: true,                    
                     scrollDirection: Axis.horizontal,                    
                     itemBuilder: (_, int index){
                          
                     return Padding(padding: EdgeInsets.all(5),child: listAdapter(index,snapshot.data),);
                     },
                   ),
                     ),
                 ],
                  

                ),


              
            );
     }
   ),
  );

  }

  Widget checkedWidget(){

   return new Container();

  }

  String setTextLength(String text, int l){
    String t=text;
   if(text.length>l ){
     t=text.substring(0,l-4);
     t=t+" ... ";
   }
   return t;
  }
}

