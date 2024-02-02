import 'package:flutter/material.dart';

import 'databasehelper.dart';
import 'notes.dart';


class SQFSCREEN extends StatefulWidget {
  const SQFSCREEN({super.key});

  @override
  State<SQFSCREEN> createState() => _SQFSCREENState();
}

class _SQFSCREENState extends State<SQFSCREEN> {
  DBHelper? dbHelper;

  late Future<List<NotesModel>> notesList = Future<List<NotesModel>>.value([]);

  @override
  void initState() {
    super.initState();

    dbHelper = DBHelper();
    loadData();
  }
  loadData() async {
    setState(() {
      notesList = dbHelper!.getNotesList();
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('CRUD Method'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(future: notesList, builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        dbHelper!.update(NotesModel(
                            id:snapshot.data![index].id!,
                            title: 'First Flutter Notes',
                            age: 11,
                            description: 'I will update the flutter application using database',
                            email: 'sherali@gmail.com'));
                        setState(() {
                          notesList=dbHelper!.getNotesList();
                        });
                      },
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.pink,
                          child: const Icon(Icons.delete_forever),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            dbHelper!.delete(snapshot.data![index].id!);
                            notesList=dbHelper!.getNotesList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        key: ValueKey<int>(snapshot.data![index].id!),
                        child: Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].title.toString()),
                            subtitle: Text(snapshot.data![index].description.toString()),
                            trailing: Text(snapshot.data![index].age.toString()),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }else{
                return const CircularProgressIndicator();
              }

            },),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dbHelper!.insert(
              NotesModel(title: 'First Note', age: 22, description: 'This is my first sql App', email: 'sherali098.sa@gmail.com'),
          ).then((value) {
            print('data added');
            loadData();

          }).onError((error, stackTrace){
            print(error.toString());

          });
        },child: const Icon(Icons.add),
      ),
    );
  }
}