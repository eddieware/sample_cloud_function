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
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('data')
            //Text('Numero de Taps!!!! ', style: _estiloTexto),
            //Text('$_conteo',style: _estiloTexto) //$ interpolacion string
          ],
        )
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
}
