import 'dart:async';
import 'package:flutter/material.dart';
import 'package:to_do_app/dbStuff/DbHelper.dart';
import 'package:to_do_app/main.dart';
void main() => runApp(CreatList());

class CreatList extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      home: MyHomePage(title: 'TODO Lists'),
       routes: <String, WidgetBuilder> {
    '/main' : (BuildContext context) => new MyApp(),
  },
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  

  final String title;

  @override
  CreatListWidget createState() => CreatListWidget();

}


class CreatListWidget extends State<MyHomePage>{
  List<ObjJunior> list= [];
  String title;
  String desc;
  int _state=0;
  double btnWidth=280; 

   void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 1300), () {
      setState(() {
        _state = 2;
      });
    });
  }


  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text("Add This List",style: new TextStyle(color: Colors.black),);

    } else if (_state == 1) {

      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      );
    } else {
      return Icon(Icons.check, color: Colors.black);
    }
  }
  

  @override
  Widget build(BuildContext context) {

     if(_state==2){
         Timer(Duration(milliseconds: 600), () {
             _state=0;
             Navigator.of(context).pushNamed("/main");
              });
     }

    Widget listAdapter(int index){

    return new Container(
       height: 30,
       //width: 300,
       child: new Row(
         children: <Widget>[
           new Checkbox(value: list[index].isChecked,
                            activeColor: Colors.black,
                            checkColor: Colors.black,
                            
                            onChanged: (bool newValue){
                              setState(() {
                                  list[index].isChecked = newValue;
                                });
                            },
                            ),
                            
                            new Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: new Text(list[index].title,style: new TextStyle(fontSize: 18,fontWeight: FontWeight.w200,color: Colors.black),),
                            ),
         ],
         ),
    );
  }

    return Scaffold(
     

     body: Builder(
       builder: (context)=>
       new Container(

       child: new Column(
         crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[

                   new Padding(padding: EdgeInsets.fromLTRB(30, 50, 0, 0),                                
                   child: new Row(
                     children: <Widget>[
                       new Container(
                         height: 2,
                         width: 60,
                         color:Colors.grey[300] ,
                         padding: EdgeInsets.fromLTRB(30, 0, 5, 0),
                       ),
                       new Text("New",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold)),
                       new Padding(
                         padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                         child: new Text("List",style: TextStyle(fontSize: 45,fontWeight: FontWeight.w300,color: Colors.grey[600])),
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
               
                 new Padding(padding: EdgeInsets.only(top: 50),
                 child: new Container(
                     width: 250,
                     alignment: Alignment.center,
                   child: new Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[

                     new Container(
                       padding: EdgeInsets.only(bottom: 2),
                       decoration: new BoxDecoration(
                         border: new Border(bottom: BorderSide(width: 1,color: Colors.black))
                       ),
                       child:new TextField(
                      onChanged: (String s){
                        title=s;
                      },
                      decoration: new InputDecoration.collapsed(
                      hintText: "  List Title",
                      border: InputBorder.none
                ),
                     ),
                       ),
                     new Padding(padding:EdgeInsets.only(top: 40,bottom: 40) ,
                     child: new Container(
                       padding: EdgeInsets.only(bottom: 2),
                       decoration: new BoxDecoration(
                         border: new Border(bottom: BorderSide(width: 1,color: Colors.black))
                       ),
                       child:new TextField(
                      onChanged: (String s){
                        desc=s;
                      },
                      decoration: new InputDecoration.collapsed(
                      hintText: "  Descreption For the List ...",
                      border: InputBorder.none
                ),
                     ),
                       ),
                     ),

                     new Container(
                       padding: EdgeInsets.only(bottom: 2),
                       decoration: new BoxDecoration(
                         border: new Border(bottom: BorderSide(width: 1,color: Colors.black))
                       ),
                       child:new TextField(
                      
                      decoration: new InputDecoration.collapsed(
                      hintText: "  Add A Task ...",
                      border: InputBorder.none
                      ),
                    onSubmitted: (String t){
                      setState(() {
                       list.add(new ObjJunior(t)) ;
                       print(list.length);
                      });
                    },
                     ),
                       ),

                      new Container(
                        height: 220,
                        width: 300,
                        padding: EdgeInsets.only(top: 40,bottom: 10),
                        child: new ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context,int index){
                         return Padding(padding: EdgeInsets.all(5),child: listAdapter(index),);
                        },
                        ),
                        
                      ),
                        
                       new AnimatedContainer(                        
                         width: btnWidth,
                         height: 40,
                         duration: Duration(seconds: 1),
                         decoration: new BoxDecoration(
                         borderRadius: BorderRadius.circular(20),
                         color: Colors.grey[200],                    
                         ),
                         child: 
                         new FlatButton(                                                   
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)), 
                          child: setUpButtonChild(),//
                          
                          onPressed: (){
                            Obj obj=new Obj(title,desc,list);
                            new DbHelper().addList(obj);
                            setState(() {
                               if (_state == 0) {
                                  animateButton();
                                  btnWidth=100;
                                }
                              });

                           
                          },
                        ) ,
                       )
                      

                   ],
                   
                   ),
                 )
                 
                 )
                   
                 ]
       ),
     ),
     ),

    );
  
  
  
  }


}