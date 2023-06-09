import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import '../models/user.dart';
import '../widgets/login_widgets/login_textfield.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => SignUpState();
}

class SignUpState extends State<signUp> {
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
          children: [
            Expanded(
              child: Container(),
            ),

            //"Velkommen" text
            const Text(
              "Welcome",
              style: TextStyle(fontSize: 42),
            ),

            const SizedBox(
              height: 50,
            ),

            //Text field username input
            LoginTextfield(
              hintText: "Full name",
              obscureText: false,
              controller: _nameController,
            ),

            const SizedBox(
              height: 10,
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

            //Register button
            OutlinedButton(
                onPressed: () async {
                  User? user = await _authService
                      .signUp(_emailController.text, _passwordController.text,
                          _nameController.text)
                      .onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Sorry, invalid email or password.'),
                      duration: Duration(seconds: 3),
                    ));
                  });
                  if (user != null) {
                    User? user = await _authService.signIn(
                        _emailController.text, _passwordController.text);
                        context.go("/");
                  }
                  print('user: $user');

                  // If this line of code is reached then the user has failed to log in
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.all(20.0),
                    fixedSize: const Size(300, 80),
                    shape: const StadiumBorder()),
                child: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                )),

            Expanded(
              child: Container(),
            ),

            //Login button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already a member?"),
                OutlinedButton(
                    onPressed: () =>
                        context.go("/login"), //TODO: Update path name
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    child: const Text(
                      "Log in",
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
