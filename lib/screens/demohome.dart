import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/models/counter.dart';

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                'This is a demo app',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                'Click the button below to return to login',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushReplacement('/demo');
                },
                child: const Text('return to login'),
              ),
              Text(
                'Press the below button to increment the counter',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              IconButton(
                onPressed: (() => context.read<Counter>().increment()),
                icon: const Icon(Icons.add_circle),
                color: Colors.yellow,
                iconSize: 50,
              ),
              Consumer<Counter>(
                builder: (context, counter, child) {
                  return Text(
                    'Counter: ${counter.count}',
                    style: Theme.of(context).textTheme.displayLarge,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
