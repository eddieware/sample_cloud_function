import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Stateful'),
          centerTitle: true,
          elevation: 20,
        ),
        body: Center(child: _retrieveUsers()
            // la mayoria de los Widgets solo pueden tener un child
            ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //floatingActionButton: _crearBotones());
        floatingActionButton: new FloatingActionButton(
          onPressed: () => _showAddUserDialogBox(context), //--------- new
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ));
  }

  Future<Null> _showAddUserDialogBox(BuildContext context) {
    TextEditingController _nameTextController = new TextEditingController();
    TextEditingController _emailTextController = new TextEditingController();

    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: const Text("Add a contact"),
            content: Container(
              height: 120.0,
              width: 100.0,
              child: ListView(
                children: <Widget>[
                  new TextField(
                    controller: _nameTextController,
                    decoration: const InputDecoration(labelText: "Name: "),
                  ),
                  new TextField(
                    controller: _emailTextController,
                    decoration: const InputDecoration(labelText: "Email: "),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              // This button results in adding the contact to the database
              new FlatButton(
                  onPressed: () {
                    CloudFunctions.instance
                        .getHttpsCallable(functionName: "addUser")
                        .call(<String, dynamic>{
                      "name": _nameTextController.text,
                      "email": _emailTextController.text
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Confirm"))
            ],
          );
        });
  }

  StreamBuilder<QuerySnapshot> _retrieveUsers() {
    return new StreamBuilder<QuerySnapshot>(
        // Interacts with Firestore (not CloudFunction)
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            print("retrieve users do not have data.");
            //print(logger);
            return Container();
          }

          // This ListView widget consists of a list of tiles
          // each represents a user.
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return new ListTile(
                    title: new Text(snapshot.data.documents[index]['name']),
                    subtitle:
                        new Text(snapshot.data.documents[index]['email']));
              });
        });
  }
}
