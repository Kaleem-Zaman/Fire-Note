import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/note_file.dart';
import 'package:google_fonts/google_fonts.dart';

import 'new_note.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  bool editFlag = false;
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff160515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Fire🔥Note",
          style: GoogleFonts.teko(
            fontSize: 30
          ),
        ),
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
                    return Dismissible(
                      key: Key(document.id),
                      direction: DismissDirection.horizontal,
                      // here is the code chunk for deleting the note
                      onDismissed: (direction) {
                        FirebaseFirestore.instance.collection("notes").doc(document.id).delete();
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
                      },
                      // here is the code chunk for editing the note
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // Navigate to the edit screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotesFile(docId: document.id, title: document['title'], content: document["content"], editFlag: true,),
                            ),
                          );
                          return false;
                        }
                        return true;
                      },
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black, Color(0xff160515)],
                          ),
                        ),
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                        ),
                      ),
                      background: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.yellowAccent, Colors.deepOrange],
                          ),
                        ),
                        child: Icon(
                          Icons.edit_note,
                          color: Colors.black,
                        ),
                      ),
                      child: NoteTile(
                        id: document.id,
                        title: document['title'],
                        dateCreated: document['dateCreated'],
                        content: document['content'],
                      ),
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
        SizedBox(height: 5,),
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
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  backgroundColor: Colors.grey,
                                  title: Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure?",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  actions: [
                                    OutlinedButton(
                                      style: ButtonStyle(
                                        side: MaterialStatePropertyAll(
                                          BorderSide(color: Colors.white)
                                        )
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                                      ),
                                      onPressed: (){
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

