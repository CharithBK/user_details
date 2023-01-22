import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_details/services/user.dart';


class Services {
  //get all user details of user details table
  static Future<List<User>> getUsers() async {
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http
          .get(Uri.parse("http://con.myreptile.de/getUser.php"), headers: headers);
      if (200 == response.statusCode) {
        List<User> list = parseResponse(response.body);
        return list;
      } else {
        return List<User>.of([]);
      }
    } catch (e) {
      return List<User>.of([]); // return an empty list on exception/error
    }
  }
  static List<User> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }
  //Add a new user
  static Future<String> addUser(
      String name,
      ) async {
    try {
      var map = Map<String, dynamic>();
      map["username"] = name;
      final data = json.encode(map);
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
          Uri.parse('http://con.myreptile.de/addUser.php'),
          headers: headers,
          body: data);
      //print('addUser Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
}