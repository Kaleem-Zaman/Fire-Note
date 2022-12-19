import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";


class NewNote extends StatefulWidget {
  static const String id = "new_note";
  const NewNote({Key? key}) : super(key: key);

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  String? title, content;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff160515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Create new note"
        ),
        actions: [
          IconButton(
            onPressed: (){
              if(title == null || content == null){
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Row(
                   children: [
                     Icon(Icons.warning, color: Colors.yellow,),
                     SizedBox(width: 12,),
                     Text(
                       "Please fill all fields to save the note!",
                       style: TextStyle(
                         color: Colors.white
                       ),
                     ),
                   ],
                 ))
               );
              }
              else{
                var docref = FirebaseFirestore.instance.collection("notes").doc();
                String date = DateTime.now().day.toString() + '/'
                    + DateTime.now().month.toString() + '/'
                    + DateTime.now().year.toString();
                Map<String, dynamic> note = {
                  'title': title,
                  'content': content,
                  'dateCreated': date
                };
                docref.set(note);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Row(
                      children: [
                        Icon(Icons.check, color: Colors.yellow,),
                        SizedBox(width: 12,),
                        Text(
                          "Note created successfully",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ))
                );
              }
            },
            icon: Icon(Icons.check_circle, color: Colors.yellowAccent,),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            TextField(
              style: TextStyle(
                color: Colors.white,
                fontSize: 18
              ),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow)
                ),
                hintText: "Enter title",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 18
                )
              ),
              onChanged: (value){
                setState(() {
                  title = value;
                });
              },
            ),
            SizedBox(height: 10,),
            TextField(
              maxLines: 30,
              decoration: InputDecoration(
                border: InputBorder.none,
                  hintText: "Note",
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 18
                  )
              ),
              onChanged: (value){
                content = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
