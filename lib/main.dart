import 'package:flutter/material.dart';
import 'package:flutter_app/ClientModel.dart';
import 'package:flutter_app/Database.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // data for testing
//  List<Client> testClients = [
//    Client(firstName: "Raouf", lastName: "Rahiche", blocked: false),
//    Client(firstName: "Zaki", lastName: "oun", blocked: true),
//    Client(firstName: "oussama", lastName: "ali", blocked: false),
//  ];

  Client userid = new Client();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: FutureBuilder<List<Client>>(
        future: DBProvider.db.getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Client item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBProvider.db.deleteClient(item.id);
                  },
                  child: ListTile(
                    title: Text(item.Name),
                    leading: Text(item.id.toString()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(userid: item),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
//          Client rnd = testClients[math.Random().nextInt(testClients.length)];
//          await DBProvider.db.newClient(rnd);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute()),
          );
          setState(() {});
        },
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Client"),
      ),
      body: Center(child: MyCustomForm()),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// ignore: must_be_immutable
class MyEditForm extends StatefulWidget {
  Client userid = new Client();
  MyEditForm(Client userid) {
    this.userid = userid;
  }
  @override
  Mdetail createState() {
    return Mdetail(userid);
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  var mname, maddress, mmobile;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter Name'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please Enter Name';
              } else {
                mname = value;
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter Address'),
            validator: (value2) {
              if (value2.isEmpty) {
                return 'Please Enter Address';
              } else {
                maddress = value2;
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter Mobile Number'),
            validator: (value3) {
              if (value3.isEmpty) {
                return 'Please Enter Mobile Number';
              } else {
                mmobile = value3;
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar

                  Client testClients =
                      Client(Name: mname, Address: maddress, Mobile: mmobile);
                  await DBProvider.db.newClient(testClients);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Client Inserted Successfully...!')));
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DetailScreen extends StatelessWidget {
  Client userid = new Client();

  DetailScreen({Key key, @required this.userid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User Details"),
        ),
        body: Center(
          child: MyEditForm(userid),
        ));
  }
}

class Mdetail extends State<MyEditForm> {
  Client userid = new Client();
  int mid;
  Mdetail(Client userid) {
    this.userid = userid;
    mid = this.userid.id;
  }
  String mmobile, maddress, mname;

  final _fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              initialValue: userid.Name,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Enter Name';
                } else {
                  mname = value;
                }
              },
            ),
            TextFormField(
              initialValue: userid.Address,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
              validator: (value2) {
                if (value2.isEmpty) {
                  return 'Please Enter Address';
                } else {
                  maddress = value2;
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              initialValue: userid.Mobile,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
              ),
              validator: (value3) {
                if (value3.isEmpty) {
                  return 'Please Enter Mobile Number';
                } else {
                  mmobile = value3;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () async {
                  if (_fKey.currentState.validate()) {
                    Client tClients = Client(
                        id: mid,
                        Name: mname,
                        Address: maddress,
                        Mobile: mmobile);
                    await DBProvider.db.updateClient(tClients);
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Client Updated Successfully...!')));
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ]),
    );
  }
}
