import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/services/storage_service.dart';
import 'package:pu_frontend/widgets/app_bar.dart';
import 'package:pu_frontend/widgets/progress_card.dart';
import 'package:pu_frontend/widgets/user_admin_widget.dart';

import '../common/bottom_bar.dart';
import '../models/excercise.dart';
import '../models/user.dart';

class Advertiser extends StatefulWidget {
  Advertiser({Key? key}) : super(key: key);

  @override
  State<Advertiser> createState() => _Advertiser();
}

class _Advertiser extends State<Advertiser> {
  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    final AuthService _authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertiser Page'),
        backgroundColor: const Color.fromARGB(255, 51, 100, 140),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  await _authService.signOut();
                  // ignore: use_build_context_synchronously
                  context.go("/");
                },
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text('Add new advertisement as a photo:'),
          SizedBox(
            height: 20,
          ),
          IconButton(
              iconSize: 50,
              onPressed: () {},
              icon: Icon(
                Icons.add_box,
              )),
          SizedBox(
            height: 30,
          ),
          Expanded(child: ListView())
        ],
      )),
    );
  }
}
