import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/components/constant.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  //firebase sends reset password link
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      const snackBar = SnackBar(
        content: Text('Email Sent'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Exception catch (e) {
      // TODO
      print(e);
      const snackBar = SnackBar(
        content: Text('Please Enter Your Email'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    //Utils.showSnackBar('Password Reset Email Sent');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0.0,
          titleSpacing: 24.0,
          centerTitle: false,
          toolbarHeight: 96.0,
          backgroundColor: black,
          title: Text(
            "Forgot Password",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(35),
                  child: Column(
                    children: [
                      const Text(
                          'We will send a reset password link to your email',
                          style: TextStyle(
                              fontSize: 25,
                              color: black,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please Enter Your Email'
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        color: black,
                        //minWidth: double.infinity,
                        onPressed: resetPassword,
                        //color: Colors.black,
                        textColor: Colors.white,

                        child: const Text('Reset Password'),
                      ),
                    ],
                  ))
            ]));
  }
}
