import 'package:flutter/material.dart';
import 'package:flutter_app/ThirdModel.dart';
import 'package:flutter_app/ClientModel.dart';
import 'package:flutter_app/Database.dart';

class MyThird extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyThird> {


  Third userid = new Third();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mat")),
      body: FutureBuilder<List<Third>>(
        future: DBProvider.db.getAllThird(),
        builder: (BuildContext context, AsyncSnapshot<List<Third>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Third item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBProvider.db.deleteThird(item.nid);
                  },
                  child: ListTile(
                    title: Text(item.Partyname),
                    leading: Text(item.nid.toString()),
                    trailing: Text("Totalprice"+item.Totalprice.toString()),
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
        title: Text("Add Nool"),
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
  Third userid = new Third();
  MyEditForm(Third userid) {
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
  var mpartyname, mcolorquantity, mcolorprice,mwhitequantity,mwhiteprice,mpaid;
  int mtotalprice;

  List _cities = new List();
  List<Client> ctest;

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    ctest.addAll(DBProvider.db.getAllParty());
    int clen=ctest.length;
    for(int k=0;k<clen;k++){
      _cities.add(ctest.elementAt(k));
    }
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text("Please choose Party: "),
          new Container(
            padding: new EdgeInsets.all(16.0),
          ),
          new DropdownButton(
            value: _currentCity,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter ColorQuantity'),
            validator: (value2) {
              if (value2.isEmpty) {
                return 'Please Enter ColorQuantity';
              } else {
                mcolorquantity = value2;
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter ColorPrice'),
            validator: (value3) {
              if (value3.isEmpty) {
                return 'Please Enter ColorPrice';
              } else {
                mcolorprice = value3;
              }
            },

          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter WhiteQuantity'),
            validator: (value2) {
              if (value2.isEmpty) {
                return 'Please Enter WhiteQuantity';
              } else {
                mwhitequantity = value2;
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter WhitePrice'),
            validator: (value3) {
              if (value3.isEmpty) {
                return 'Please Enter WhitePrice';
              } else {
                mwhiteprice = value3;
              }
            },

          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Total Price'),
            validator: (value3) {
              mtotalprice = int.parse(value3);
            },

          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Paid'),
            validator: (value3) {
              if (value3.isEmpty) {
                return 'Please Enter Paid Price';
              } else {
                mpaid = value3;
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
                  if(mcolorquantity.toString().isNotEmpty&&mcolorprice.toString().isNotEmpty){
                    mtotalprice=int.parse(mcolorquantity)*int.parse(mcolorprice);
                  }
                  if(mwhitequantity.toString().isNotEmpty&&mwhiteprice.toString().isNotEmpty){
                    mtotalprice=mtotalprice+(int.parse(mwhitequantity)*int.parse(mwhiteprice));
                  }
                  Third testClients = Third(
                      Partyname: _currentCity,
                      Colorquantity: mcolorquantity,
                      Colorprice: mcolorprice,
                      Whitequantity: mwhitequantity,
                      Whiteprice: mwhiteprice,
                      Totalprice: mtotalprice.toString(),
                      Paid:mpaid);
                  await DBProvider.db.newThird(testClients);
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
  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
  }
}

// ignore: must_be_immutable
class DetailScreen extends StatelessWidget {
  Third userid = new Third();

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
  Third userid = new Third();
  int mid;
  Mdetail(Third userid) {
    this.userid = userid;
    mid = this.userid.nid;
  }
  String mcolorquantity, mcolorprice,mwhiteprice,mwhitequantity;
  int mtotalprice;

  List _cities = new List();
  List<Client> ctest;

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;

  final _fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _fKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Please choose Party: "),
            new Container(
              padding: new EdgeInsets.all(16.0),
            ),
            new DropdownButton(
              value: _currentCity,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              initialValue: userid.Colorquantity,
              decoration: InputDecoration(
                labelText: 'Quantity',
              ),
              validator: (value2) {
                if (value2.isEmpty) {
                  return 'Please Enter colorQuantity';
                } else {
//                  mcolorq = value2;
                }
              },
            ),
            TextFormField(

              keyboardType: TextInputType.number,
              initialValue: userid.Colorprice,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              validator: (value3) {
                if (value3.isEmpty) {
                  return 'Please Enter colorPrice';
                } else {
//                  mprice = value3;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () async {
//                  if (_fKey.currentState.validate()) {
//                    if(mquantity.toString().isNotEmpty&&mprice.toString().isNotEmpty){
//                      mtotalprice=int.parse(mquantity)*int.parse(mprice);
//                    }
//                    Third tClients = Third(
//                        id: mid,
//                        Userdetails: muserdetails,
//                        Quantity: mquantity,
//                        Price: mprice,
//                        Totalprice: mtotalprice.toString());
//                    await DBProvider.db.updateSecond(tClients);
//                    Scaffold.of(context).showSnackBar(SnackBar(
//                        content: Text('Mat Updated Successfully...!')));
//                    Navigator.pop(context);
//                  }
                },
                child: Text('Submit'),
              ),
            ),
          ]),

    );

  }
  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
  }
}
