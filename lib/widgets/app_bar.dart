import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/services/storage_service.dart';

import '../models/user.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalAppBar({
    required this.title,
    this.additionalActions = const [],
    super.key,
  });

  final String title;
  final List<Widget> additionalActions;

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = [
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () async => await _showNotificationDialog(context),
      ),
      IconButton(
          onPressed: () async => await _addImage(context),
          icon: const Icon(Icons.add_a_photo_sharp))
    ];

    actions.addAll(additionalActions);

    return AppBar(
      title: Text(title),
      actions: actions,
    );
  }

  void refresh(BuildContext context) async {
    Navigator.of(context).pop();
    await _showNotificationDialog(context);
  }

  _showNotificationDialog(BuildContext context) async {
    User? myUser = await Provider.of<DatabaseService>(context, listen: false)
        .getUser(Provider.of<AuthService>(context, listen: false).uid);

    List<String> uids = [];

    for (String uid in myUser!.freindRequests) {
      uids.add(uid);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notifications'),
          contentPadding: EdgeInsets.all(0),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              children: uids.isEmpty
                  ? const [Text('No notifications')]
                  : uids
                      .map((e) => FreindRequestTile(e, myUser, refresh))
                      .toList(),
            ),
          ),
        );
      },
    );
  }

  _addImage(BuildContext context) async {
    StorageService ss = StorageService();
    String? url = await ss.showPicker(context);

    if (url == null) {
      SnackBar s = const SnackBar(content: Text('Problem uploading image'));
      ScaffoldMessenger.of(context).showSnackBar(s);
      return;
    }

    User? myUser = await Provider.of<DatabaseService>(context, listen: false)
        .getUser(Provider.of<AuthService>(context, listen: false).uid);

    myUser!.addPicture(url);

    await Provider.of<DatabaseService>(context, listen: false)
        .updateUser(myUser);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => AppBar().preferredSize;
}

class FreindRequestTile extends StatelessWidget {
  const FreindRequestTile(this.uid, this.myUser, this.refresh, {super.key});
  final String uid;
  final User myUser;
  final Function(BuildContext) refresh;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        builder: ((context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          if (snapshot.connectionState == ConnectionState.waiting)
            return const CircularProgressIndicator();

          User user = snapshot.data as User;

          return ListTile(
            title: Text(user.name ?? 'No name'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePicture!),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: (() {
                          myUser.removeFreindRequest(uid);
                          Provider.of<DatabaseService>(context, listen: false)
                              .updateUser(myUser);
                          refresh(context);
                        }),
                        icon: const Icon(Icons.remove)),
                    IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          user.addFreind(myUser);
                          myUser.addFreind(user);
                          myUser.removeFreindRequest(uid);

                          await Provider.of<DatabaseService>(context,
                                  listen: false)
                              .updateUser(user);

                          await Provider.of<DatabaseService>(context,
                                  listen: false)
                              .updateUser(myUser);
                          refresh(context);
                        }),
                  ],
                ),
              ),
            ),
          );
        }),
        future:
            Provider.of<DatabaseService>(context, listen: false).getUser(uid));
  }
}
