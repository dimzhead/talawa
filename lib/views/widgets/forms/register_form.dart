import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talawa/controllers/auth_controller.dart';
import 'package:talawa/controllers/user_controller.dart';
import 'package:talawa/services/Queries.dart';
import 'package:talawa/utils/GQLClient.dart';
import 'package:talawa/utils/uidata.dart';
import 'package:talawa/utils/validator.dart';
import 'package:talawa/view_models/vm_register.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:talawa/services/preferences.dart';
import 'package:talawa/model/token.dart';
import 'package:talawa/views/pages/join_organization.dart';

class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController originalPassword = new TextEditingController();
  RegisterViewModel model = new RegisterViewModel();
  bool _progressBarState = false;
  Queries signupQuery = Queries();
  bool _validate = false;
  Preferences _pref = Preferences();

  void toggleProgressBarState() {
    _progressBarState = !_progressBarState;
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql(signupQuery.signUp),
        update: (Cache cache, QueryResult result) {
          if (result.hasException) {
            setState(() {
              _progressBarState = false;
            });
            print("exception");
            final snackBar = SnackBar(
                content: Text(result.exception.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 5));
            Scaffold.of(context).showSnackBar(snackBar);
          }
          return cache;
        },
        onCompleted: (dynamic resultData) {

          if (resultData != null) {
            setState(() {
              _progressBarState = true;
            });
            //Store user token in local storage
            void getToken() async {
              final Token token =
                  new Token(tokenString: resultData['signUp']['token']);
              await _pref.saveToken(token);

              final String currentUserId = resultData['signUp']['userId'];
              await _pref.saveUserId(currentUserId);
            }

            getToken();

            //Navigate user to join organization screen
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => new JoinOrganization()));
          }
        },
      ),
      builder: (RunMutation runMutation, QueryResult result) {
        return Form(
            key: _formKey,
            autovalidate: _validate,
            child: Column(
              children: <Widget>[
                Text('Register',
                    style: TextStyle(fontSize: 35, color: Colors.white)),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => Validator.validateFirstName(value),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    prefixIcon: Icon(Icons.person),
                    labelText: "First Name",
                    labelStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                    hintText: 'Earl',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onSaved: (value) {
                    model.firstName = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => Validator.validateLastName(value),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    prefixIcon: Icon(Icons.person),
                    labelText: "Last Name",
                    labelStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                    hintText: 'John',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onSaved: (value) {
                    model.lastName = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => Validator.validateEmail(value),
                  controller: emailController,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                    hintText: 'foo@bar.com',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onSaved: (value) {
                    model.email = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  controller: originalPassword,
                  validator: (value) => Validator.validatePassword(value),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    focusColor: UIData.quitoThemeColor,
                    alignLabelWithHint: true,
                    hintText: 'password',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onSaved: (value) {
                    model.password = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  validator: (value) => Validator.validatePasswordConfirm(
                      originalPassword.text, value),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(color: Colors.white),
                    focusColor: UIData.quitoThemeColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.all(12.0),
                    shape: StadiumBorder(),
                    child: _progressBarState
                        ? const CircularProgressIndicator()
                        : Text(
                            "SIGN UP",
                          ),
                    color: Colors.white,
                    onPressed: () async {
                      _validate = true;
                      if (_formKey.currentState.validate()) {
                        print("run mutation");
                        _formKey.currentState.save();

                        runMutation({
                          "firstName": model.firstName,
                          "lastName": model.lastName,
                          "email": model.email,
                          "password": model.password
                        });
                        setState(() {
                          toggleProgressBarState();
                        });
                      }
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }
}
