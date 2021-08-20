import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {

  String serverUrl = "http://192.168.1.25:3000/api";


  loginData(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;

    String myUrl = "$serverUrl/users/login";
    var  response = await http.post(myUrl,
        body: {
          "email": "$email",
          "password": "$password"
        });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        sharedPreferences.setString("token", jsonResponse['token']);
        return true ;
      }
    }
    else {
      print(response.body);
      return false ;
    }
  }


  Future<List> AllHotels() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/hotel/hotels";
    http.Response response = await http.get(myUrl,
      headers: {},
    );
    return json.decode(response.body);
  }


  Future<List> getHotelByID(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/hotel/$ID";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        });
    return json.decode(response.body);
  }

  void addReservation(String hotel_booking,int room_no ,String arrival_date, String departure_date ,int num_adults ,int num_children) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String final_response ;

    String myUrl = "$serverUrl/reservation/AddReservation";
    await http.post(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
//          'Authorization': 'token eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxMWQ4ZTU1MDg1NmRiNmQxYzRhOTBlNSIsImlhdCI6MTYyOTQ3MDk5Mn0.okrH9Yv7A-PsYOb8CMQTey6nZ1RlAC6MkOSS6Z229zc'
        },
        body: {
          "hotel_booking": "$hotel_booking",
          "room_no": "$room_no",
          "arrival_date": "$arrival_date",
          "departure_date": "$departure_date",
          "num_adults": "$num_adults",
          "num_children": "$num_children"
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      final_response =response.body;
    });
    return json.decode(final_response);

  }

  Future<List> getReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/reservation/reservations";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
//          'Authorization': 'token eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxMWQ4ZTU1MDg1NmRiNmQxYzRhOTBlNSIsImlhdCI6MTYyOTQyMTYzMX0.mCp5eUIByNNBfdn4vF5IgTd_XANo0M1psmtHSshpsaU'
        });
    return json.decode(response.body);
  }

  Future<List> getReservationByID(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/reservation/detail";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        });
    return json.decode(response.body);
  }
}
