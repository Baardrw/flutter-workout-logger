import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/counter.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushReplacement('/demo2');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                child: const Text('ENTER'),
              ),
              const SizedBox(
                height: 24,
              ),
              Consumer<Counter>(builder: (context, counter, child) {
                return Text(
                  'Counter: ${counter.count}',
                  style: Theme.of(context).textTheme.displayLarge,
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
