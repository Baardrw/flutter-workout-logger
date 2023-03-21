import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../widgets/login_widgets/login_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late User? _user;

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //"Logg inn"-text
        Expanded(
          child: Container(),
        ),

        const Text(
          "Logify",
          style: TextStyle(fontSize: 42),
        ),

        const SizedBox(
          height: 50,
        ),

        //Text field username input
        LoginTextfield(
          hintText: "E-mail",
          obscureText: false,
          controller: _emailController,
        ),

        const SizedBox(
          height: 10,
        ),

        //Text field password input
        LoginTextfield(
          hintText: "Password",
          obscureText: true,
          controller: _passwordController,
        ),

        const SizedBox(
          height: 30,
        ),

        //Login button
        OutlinedButton(
            onPressed: () async {
              print(_emailController.text + _passwordController.text);
              User? user = await _authService
                  .signIn(_emailController.text, _passwordController.text)
                  .onError((error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Sorry, the password is wrong'),
                  duration: Duration(seconds: 3),
                ));
              });
              print('user: $user');
              // If this line of code is reached then the user has failed to log in
            },
            style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.all(20.0),
                fixedSize: const Size(300, 80),
                shape: const StadiumBorder()),
            child: const Text(
              "Log in",
              style: TextStyle(fontSize: 30, color: Colors.white),
            )),

        Expanded(
          child: Container(),
        ),

        //Register user button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No user?"),
            OutlinedButton(
                onPressed: () => context.go("/signup"), //Update path
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                child: const Text(
                  "Sign up",
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
      ],
    )));
  }
}
