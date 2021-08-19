import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:tunav/Services/DatabaseHelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    List<Marker> list = [
      Marker(
        width: 80.0,
        height: 80.0,
        point: latLng.LatLng(36.802707, 10.107387),
        builder: (ctx) => Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.green,
            onPressed: () {
              print("Pressed ");
              openAlertBox();
            },
          ),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: latLng.LatLng(43.108707, 12.375898),
        builder: (ctx) => Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.green,
            onPressed: () {
              print("Pressed ");
              openAlertBox();
            },
          ),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: latLng.LatLng(48.859826, 2.341818),
        builder: (ctx) => Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.green,
            onPressed: () {
              print("Pressed ");
              openAlertBox();
            },
          ),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: latLng.LatLng(51.5, -0.09),
        builder: (ctx) => Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.green,
            onPressed: () {
              print("Pressed ");
            },
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FlutterMap(
        options: MapOptions(
          center: latLng.LatLng(51.5, -0.09),
          zoom: 10.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/blackhummer/cksj155yfakkz17pjxkvn22ya/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYmxhY2todW1tZXIiLCJhIjoiY2tlNzdvMnVrMWthejJ0cGQyMjhodWV6bCJ9.5Grv-SWxNKLsz_ulw9B9Hw",
              additionalOptions: {
                'accessToken': 'pk.eyJ1IjoiYmxhY2todW1tZXIiLCJhIjoiY2tlNzdvMnVrMWthejJ0cGQyMjhodWV6bCJ9.5Grv-SWxNKLsz_ulw9B9Hw',
                'id': 'mapbox.mapbox-streets-v8'
              }),
          MarkerLayerOptions(
            markers: list,
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => displayBottomSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }


  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Text("Welcome to AndroidVille!"),
            ),
          );
        });
  }

  openAlertBox() {
    final halfMediaWidth = MediaQuery.of(context).size.width / 4.0;
    final _formKey = GlobalKey<FormState>();
    Model model = Model();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(22.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Rate",
                        style: TextStyle(fontSize: 24.0),
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        MyTextFormField(
                          hintText: 'First Name',
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Enter your first name';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.firstName = value;
                          },
                        ),
                        MyTextFormField(
                          hintText: 'Last Name',
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Enter your last name';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.lastName = value;
                          },
                        ),
                        MyTextFormField(
                          hintText: 'Email',
                          isEmail: true,
                          validator: (String value) {
                            if (value.length < 7) {
                              return 'Password should be minimum 7 characters';
                            }
                            _formKey.currentState.save();
                            return null;
                          },
                          onSaved: (String value) {
                            model.email = value;
                          },
                        ),
                        MyTextFormField(
                          hintText: 'Password',
                          isPassword: true,
                          validator: (String value) {
                            if (value.length < 7) {
                              return 'Password should be minimum 7 characters';
                            }
                            _formKey.currentState.save();
                            return null;
                          },
                          onSaved: (String value) {
                            model.password = value;
                          },
                        ),
                        MyTextFormField(
                          hintText: 'Confirm Password',
                          isPassword: true,
                          validator: (String value) {
                            if (value.length < 7) {
                              return 'Password should be minimum 7 characters';
                            } else if (model.password != null &&
                                value != model.password) {
                              print(value);
                              print(model.password);
                              return 'Password not matched';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Color(0xff00bfa5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(22.0),
                            bottomRight: Radius.circular(22.0)),
                      ),
                      child: Text(
                        "Reservation",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          );
        });
  }
}

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final bool isPassword;
  final bool isEmail;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[100],
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }
}

class Model {
  String firstName;
  String lastName;
  String email;
  String password;

  Model({this.firstName, this.lastName, this.email, this.password});
}
