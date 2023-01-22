import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/service.dart';
import '../services/user.dart';

class UserDetails extends StatefulWidget {
  final String title = "USER DETAILS";
  const UserDetails();

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  //variable initialization
  List<User> _filterUsers = [];
  late GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _name = TextEditingController();
  String _titleProgress = '';

  @override
  void initState() {
    super.initState();
    _filterUsers = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _name = TextEditingController();

    //When page load all user details will load to the table
    _getUsers();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  //get all user details
  _getUsers() {
    _showProgress('Loading Users...');
    Services.getUsers().then((users) {
      setState(() {
        _filterUsers = users;
      });
      _showProgress(widget.title); // Reset the title...
    });
  }

  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('ID',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
            ),
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
            ),
          ],
          //load data in to the table one by one
          rows: _filterUsers
              .map(
                (user) => DataRow(cells: [
                  DataCell(
                    Text(user.id),
                  ),
                  DataCell(SizedBox(
                    width: 190,
                    child: Text(user.username),
                  ))
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newUser = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           SizedBox(
            width: 250,
            child: TextField(
              controller: _name,
              decoration: const InputDecoration(
                hintText: 'Enter new user',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            onPressed: () {

              if(_name.text !='') {
                saveUserDetails();
              }
              else{
                Fluttertoast.showToast(msg: "Field can't be empty" );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(_titleProgress), // we show the progress in the title...
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _getUsers();
            },
          )
        ],
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              newUser,
              const SizedBox(height: 25.0),
              Expanded(child: _dataBody()),
            ],
          ),
        ),
      ),
    );
  }
  //new user details will pass to Services class
  void saveUserDetails() {
    Services.addUser(
      _name.text,
    ).then((result) {
      String jsonString = result;
      var jsonData = jsonDecode(jsonString);
      Fluttertoast.showToast(msg: jsonData['message']);
    });
  }
}
