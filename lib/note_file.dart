import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesFile extends StatefulWidget {
  static const String id = "note_file";
  final String? docId, title, content;
  const NotesFile(
      {
        Key? key,
        this.title,
        this.content,
        this.docId
      }) : super(key: key);

  @override
  State<NotesFile> createState() => _NotesFileState();
}

class _NotesFileState extends State<NotesFile> {

  bool isEditable=false;
  bool isClickable = false;
  Color activeColor = Colors.grey;
  TextEditingController? titleController;
  TextEditingController? contentController;
  String? newTitle, newContent;
  @override
  void initState() {
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xff160515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: TextField(
          controller: titleController,
          onChanged: (value){
            setState(() {
              if(activeColor == Colors.grey && isClickable == false){
                activeColor = Colors.yellow;
                isClickable = true;
              }
              newTitle = value;
            });
          },
          readOnly: !isEditable,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.yellowAccent
              )
            )
          ),
        ),
        actions: [
          isEditable? IconButton(
            onPressed: (){
              setState(() {
                isEditable = false;
              });
            },
            icon: Icon(Icons.cancel, color: Colors.red,),
          ) : SizedBox(),
          IconButton(
            onPressed: (){
              setState(() {
                isEditable = true;
              });
            },
            icon: Icon(Icons.edit_note),
          ),
          isEditable? IconButton(
            onPressed: (){
              if (!isClickable){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red,),
                        SizedBox(width: 12,),
                        Text(
                          "Please do any modifications to save the changes!",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ))
                );
              }
              else{
                Map<String, dynamic> newNote = {
                  'title': newTitle,
                  'content': newContent,
                  'dateCreated': DateTime.now().day.toString() + '/'
                      + DateTime.now().month.toString() + '/'
                      + DateTime.now().month.toString()
                };
                FirebaseFirestore.instance.collection("notes").doc(widget.docId).update(newNote);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.yellowAccent,),
                        SizedBox(width: 12,),
                        Text(
                          "Changes saved successfully!",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ))
                );
              }
            },
            icon: Icon(Icons.check_circle, color: activeColor,),
          ) : SizedBox()
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              TextField(
                controller: contentController,
                onChanged: (value){
                  setState(() {
                    if(activeColor == Colors.grey && isClickable == false){
                      activeColor = Colors.yellow;
                      isClickable = true;
                    }
                    newContent = value;
                  });
                },
                readOnly: !isEditable,
                maxLines: 30,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                ),
            ),
          ]
          ),
        ),
      ),
    );
  }
}
