import 'package:flutter/material.dart';
import 'package:flutter_app/SecondModel.dart';
import 'package:flutter_app/Database.dart';

class MySecond extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MySecond> {


  Second userid = new Second();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mat")),
      body: FutureBuilder<List<Second>>(
        future: DBProvider.db.getAllSecond(),
        builder: (BuildContext context, AsyncSnapshot<List<Second>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Second item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBProvider.db.deleteSecond(item.id);
                  },
                  child: ListTile(
                    title: Text(item.Userdetails+" /Totalprice"+item.Totalprice.toString()),
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
        title: Text("Add Mat"),
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
  Second userid = new Second();
  MyEditForm(Second userid) {
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
  var muserdetails, mquantity, mprice;
  int mtotalprice;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter Name/Address'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please Enter Name/Address';
              } else {
                muserdetails = value;
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter Quantity'),
            validator: (value2) {
              if (value2.isEmpty) {
                return 'Please Enter Quantity';
              } else {
                mquantity = value2;
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter Price'),
            validator: (value3) {
              if (value3.isEmpty) {
                return 'Please Enter Price';
              } else {
                mprice = value3;
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
                        if(mquantity.toString().isNotEmpty&&mprice.toString().isNotEmpty){
                          mtotalprice=int.parse(mquantity)*int.parse(mprice);
                        }
                  Second testClients = Second(
                      Userdetails: muserdetails,
                      Quantity: mquantity,
                      Price: mprice,

                      Totalprice: mtotalprice.toString());
                  await DBProvider.db.newSecond(testClients);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Mat Inserted Successfully...!')));
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
  Second userid = new Second();

  DetailScreen({Key key, @required this.userid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mat Details"),
        ),
        body: Center(
          child: MyEditForm(userid),
        ));
  }
}

class Mdetail extends State<MyEditForm> {
  Second userid = new Second();
  int mid;
  Mdetail(Second userid) {
    this.userid = userid;
    mid = this.userid.id;
  }
  String muserdetails, mquantity, mprice;
  int mtotalprice;

  final _fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              initialValue: userid.Userdetails,
              decoration: InputDecoration(
                labelText: 'Name/Address',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Enter Name/Address';
                } else {
                  muserdetails = value;
                }
              },
            ),
            TextFormField(
              initialValue: userid.Quantity,
              decoration: InputDecoration(
                labelText: 'Quantity',
              ),
              validator: (value2) {
                if (value2.isEmpty) {
                  return 'Please Enter Quantity';
                } else {
                  mquantity = value2;
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              initialValue: userid.Price,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              validator: (value3) {
                if (value3.isEmpty) {
                  return 'Please Enter Price';
                } else {
                  mprice = value3;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () async {
                  if (_fKey.currentState.validate()) {
                    if(mquantity.toString().isNotEmpty&&mprice.toString().isNotEmpty){
                      mtotalprice=int.parse(mquantity)*int.parse(mprice);
                    }
                    Second tClients = Second(
                        id: mid,
                        Userdetails: muserdetails,
                        Quantity: mquantity,
                        Price: mprice,
                        Totalprice: mtotalprice.toString());
                    await DBProvider.db.updateSecond(tClients);
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Mat Updated Successfully...!')));
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
