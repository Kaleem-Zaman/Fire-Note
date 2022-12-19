import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/note_file.dart';

import 'new_note.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff160515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Fire🔥Note"),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.help_outline,),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent,
        onPressed: (){
          Navigator.pushNamed(context, NewNote.id);
        },
        child: Icon(Icons.add, color: Colors.black,),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("notes").snapshots(),
            builder: (context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else{
                return ListView(
                  children: snapshot.data!.docs.map<Widget>((document){
                    return NoteTile(
                      id: document.id,
                      title: document['title'],
                      dateCreated: document['dateCreated'],
                      content: document['content'],
                    );
                  }).toList(),
                );
              }
            },
          )
        ),
      ),
    );
  }
}

class NoteTile extends StatelessWidget {
  String title, dateCreated, content, id;
  NoteTile({
    Key? key,
    required this.id,
    required this.title,
    required this.dateCreated,
    required this.content
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder:
                    (context)=>NotesFile(docId: id, title: title, content: content,)));
          },
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xff120411),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 3.0,
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(dateCreated, style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){},
                          icon: Icon(
                            Icons.edit,
                            color: Colors.yellow,
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text(
                                      "Delete"
                                  ),
                                  content: Text(
                                      "Are you sure?"
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                                      ),
                                      onPressed: (){
                                        debugPrint(id);
                                        FirebaseFirestore.instance.collection("notes").doc(id).delete();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Row(
                                              children: [
                                                Icon(Icons.check, color: Colors.yellow,),
                                                SizedBox(width: 12,),
                                                Text(
                                                  "Note deleted successfully",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                ),
                                              ],
                                            ))
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 15,)
      ],
    );
  }
}

