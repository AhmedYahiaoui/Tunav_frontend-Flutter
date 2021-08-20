import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunav/Login.dart';
import 'package:tunav/Services/DatabaseHelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences sharedPreferences;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List listHotels = new List();
  List listReservations = new List();


  List<Marker> listHotelsMarkers = new List();

  final TextEditingController room_no = new TextEditingController();
  final TextEditingController arrival_date = new TextEditingController();
  final TextEditingController departure_date = new TextEditingController();
  final TextEditingController num_adults = new TextEditingController();
  final TextEditingController num_children = new TextEditingController();

  DateTime _selectedarrival_date;
  DateTime _selecteddeparture_date;

  @override
  void initState() {


    databaseHelper.AllHotels().then((value){
      listHotels..addAll(value);
      listHotels.forEach((hotel) {
        listHotelsMarkers.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: latLng.LatLng(
                  double.parse(hotel['coordinates']['LAT']),
                  double.parse(hotel['coordinates']['LNG'])
              ),
              builder: (ctx) => Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.green,
                  onPressed: () {
                    print("Pressed on hotel  =>  "+hotel['title']);
                    //openAlertBox();
                    final halfMediaWidth = MediaQuery.of(context).size.width / 4.0;
                    final _formKey = GlobalKey<FormState>();

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
                                      children: <Widget>[
                                        Text(
                                          hotel['title'],
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                        FlutterRatingBar(
                                          initialRating: hotel['star'].toDouble(),
                                          fillColor: Colors.amber,
                                          borderColor: Colors.amber.withAlpha(50),
                                          itemCount: 5,
                                          itemSize: 20.0,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),

                                          allowHalfRating: true,
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
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
                                    Form  (
                                      key: _formKey,
                                      child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Enter how much rooms you want';
                                              }
                                              return null;
                                            },
                                            controller: room_no,
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.room_service, color: Colors.grey[400]),
                                                border: InputBorder.none,
                                                hintText: "Number rooms",
                                                hintStyle: TextStyle(color: Colors.grey[400])),
//                                            onSaved: (String value) {
//                                              model.firstName = value;
//                                            },
                                          ),
                                          TextFormField(
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Enter how much adults';
                                              }
                                              return null;
                                            },
                                            controller: num_adults,
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.supervised_user_circle, color: Colors.grey[400]),
                                                border: InputBorder.none,
                                                hintText: "Number of adults",
                                                hintStyle: TextStyle(color: Colors.grey[400])),
//                                            onSaved: (String value) {
//                                              model.firstName = value;
//                                            },
                                          ),
                                          TextFormField(
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Enter how much children';
                                              }
                                              return null;
                                            },
                                            controller: num_children,
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.child_care, color: Colors.grey[400]),
                                                border: InputBorder.none,
                                                hintText: "Number of children",
                                                hintStyle: TextStyle(color: Colors.grey[400])),
//                                            onSaved: (String value) {
//                                              model.firstName = value;
//                                            },
                                          ),
                                          //arrival
                                          TextFormField(
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Enter your arrival date';
                                              }
                                              return null;
                                            },
                                            controller: arrival_date,
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.date_range, color: Colors.grey[400]),
                                                border: InputBorder.none,
                                                hintText: "Arrival date",
                                                hintStyle: TextStyle(color: Colors.grey[400])),
                                            onTap: (){
                                              _selectDateArrival_date(context);
                                            },
                                          ),
                                          //depart
                                          TextFormField(
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Enter your departure date';
                                              }
                                              return null;
                                            },
                                            controller: departure_date,
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.date_range, color: Colors.grey[400]),
                                                border: InputBorder.none,
                                                hintText: "Departure date",
                                                hintStyle: TextStyle(color: Colors.grey[400])),
                                            onTap: (){
                                              _selectDateDeparture_date(context);
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
              // String hotel_booking,int room_no ,String arrival_date, String departure_date ,int num_adults ,int num_children
                                      onTap: (){
                                        if (_formKey.currentState.validate()) {
                                          databaseHelper.addReservation(
                                              hotel['_id'], int.parse(room_no.text), arrival_date.text,departure_date.text,int.parse(num_adults.text),int.parse(num_children.text));
                                          Navigator.of(context).pop();

                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                          );
                        });
                  },
                ),
              ),
            )
        );
      });
    });


    databaseHelper.getReservations().then((value){
      listReservations..addAll(value);
    });

    checkLoginStatus();

    super.initState();
}

  _selectDateArrival_date(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedarrival_date != null ? _selectedarrival_date : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedarrival_date = newSelectedDate;
      arrival_date
        ..text = DateFormat.yMMMd().format(_selectedarrival_date)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: arrival_date.text.length,
            affinity: TextAffinity.upstream));
    }
  }


  _selectDateDeparture_date(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selecteddeparture_date != null ? _selecteddeparture_date : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selecteddeparture_date = newSelectedDate;
      departure_date
        ..text = DateFormat.yMMMd().format(_selecteddeparture_date)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: departure_date.text.length,
            affinity: TextAffinity.upstream));
    }
  }


  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("sharedPreferences");
    print(sharedPreferences.getString("token"));

    if (sharedPreferences.getString("token") == null) {
      await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
          (BuildContext context) => LoginPage()
      ),
              (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: FlutterMap(
        options: MapOptions(
          center: latLng.LatLng(33.2665859,9.8406161),
          zoom: 5.88,
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
            markers: listHotelsMarkers,
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
              child: new ListView.builder
                (
                  itemCount: listReservations.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(
                          color: Colors.grey[100],
                          width: 0.1,
                        ),
                      ),
                      margin: EdgeInsets.all(5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Arrival Date :',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[400],
                                    )),
                                Text(listReservations[index]['arrival_date'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Departure Date :',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[400],
                                    )),
                                Text(listReservations[index]['departure_date'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Number of rooms :',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[400],
                                    )),
                                Text(listReservations[index]['room_no'].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Number of children :',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[400],
                                    )),
                                Text(listReservations[index]['num_children'].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 5,
                            ),

                      ]),
                    );
                  }
              ),
            ),
          );
        });
  }
}
