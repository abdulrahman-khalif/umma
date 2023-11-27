//import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:umma/views/adminScreen.dart';
import 'package:umma/views/customerScreen.dart';

import '../ServerConfig.dart';
import '../model/user.dart';
import 'RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  bool _passwordVisible = true;
  TextEditingController email_input = TextEditingController();
  TextEditingController pass_input = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        // appBar: AppBar(
        //   title: const Text("Login:",
        //       style: TextStyle(
        //         color: Colors.black,
        //       )),
        // ),
        body: Center(
            child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/most-beautiful-mosques.jpg"),
                  fit: BoxFit.cover,
                )),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const SizedBox(height: 50),

                    // logo
                    const Icon(
                      Icons.lock,
                      color: Colors.greenAccent,
                      size: 100,
                    ),

                    const SizedBox(height: 50),
                    Container(
                        child: Card(
                      color: Colors.greenAccent,
                      margin: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(children: [
                            TextFormField(
                                controller: email_input,
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty ||
                                        !val.contains("@") ||
                                        !val.contains(".")
                                    ? "enter a valid email"
                                    : null,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    labelText: 'Email',
                                    icon: Icon(Icons.email),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                            TextFormField(
                                controller: pass_input,
                                keyboardType: TextInputType.emailAddress,
                                obscureText: _passwordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: const Icon(Icons.password),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value!;
                                      saveremovepref(value);
                                    });
                                  },
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: null,
                                    child: const Text('Remember Me',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  minWidth: 115,
                                  height: 50,
                                  color: Colors.green,
                                  child: const Text('Login'),
                                  elevation: 10,
                                  onPressed: _loginUser,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text("Register new account? ",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      )),
                                  GestureDetector(
                                      onTap: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        const RegistrationScreen()))
                                          },
                                      child: const Text(
                                        " Click here",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))
                                ]),
                          ]),
                        ),
                      ),
                    )),
                  ],
                )))));
  }

  void _loginUser() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    String _email = email_input.text;
    String _pass = pass_input.text;
    http.post(Uri.parse("${ServerConfig.SERVER}/php/login_user.php"),
        body: {"email": _email, "password": _pass}).then((response) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        print(jsonResponse);
        User user = User.fromJson(jsonResponse['data']);
        print(user.phone);

        if (user.userType == "customer") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => customer_screen(user: user)));
        } else if (user.userType == "admin") {
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => adminside(user: user)));
        }
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }

  void saveremovepref(bool value) async {
    String email = email_input.text;
    String password = pass_input.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        email_input.text = '';
        pass_input.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        email_input.text = email;
        pass_input.text = password;
        _isChecked = true;
      });
    }
  }
}
