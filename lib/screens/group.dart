import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/db_service.dart';

import '../common/bottom_bar.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../widgets/app_bar.dart';

class GroupPage extends StatefulWidget {
  final String? groupName;
  
  const GroupPage({
    super.key,
    required this.groupName
  });

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  BottomBar bottomBar = BottomBar(3);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: Text("No data"),
              ),
            );
          }

          Group group = snapshot.data as Group;
          bool isMember = group.groupMembers.contains(Provider.of<AuthService>(context).uid);

          return Scaffold(
            appBar: GlobalAppBar(title: group.name),
            body: ListView(
              children: [
                const SizedBox(height: 16),
                _TopPortion(group),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        group.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(group.groupGoal),
                      widget.groupName == null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton.extended(
                                  onPressed: () async {
                                    if (isMember) {
                                      await _leaveGroup(context, group);
                                      setState(() {
                                        isMember = false;
                                      });
                                    } else {
                                      await _joinGroup(context, group);
                                      setState(() {
                                        isMember = true;
                                      });
                                    }
                                  },
                                  heroTag: 'Join Group',
                                  elevation: 0,
                                  label: isMember
                                      ? const Text('Leave Group')
                                      : const Text("Join Group"),
                                  icon: isMember
                                      ? const Icon(Icons.person_remove_alt_1)
                                      : const Icon(Icons.person_add_alt_1),
                                ),
                              ],
                            ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: bottomBar.getBar(context),
          );
        },
        future: DatabaseService().getGroup(widget.groupName!));
  }

_leaveGroup(BuildContext context, Group group) async {
  DatabaseService dbservice = DatabaseService();
  User user = await dbservice.getUser(Provider.of<AuthService>(context, listen: false).uid) as User;
  user.leaveGroup(group);
  group.removeMember(user.uid);
  dbservice.updateGroup(group);
  dbservice.updateUser(user);
}

_joinGroup(BuildContext context, Group group) async {
  DatabaseService dbservice = DatabaseService();
  User user = await dbservice.getUser(Provider.of<AuthService>(context, listen: false).uid) as User;
  user.joinGroup(group);
  group.addMember(user.uid);
  dbservice.updateGroup(group);
  dbservice.updateUser(user);
}
}

class _TopPortion extends StatefulWidget {
  const _TopPortion(this.group, {Key? key}) : super(key: key);

  final Group group;

  static String cameraIcon =
      "https://www.creativefabrica.com/wp-content/uploads/2019/05/Camera-icon-by-demolabid-580x386.jpg";

  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
  // Basic image for users without a profile picture
  NetworkImage profilePic = NetworkImage(
      "https://farm5.static.flickr.com/4007/4177211228_9fc2029702_z.jpg");

  @override
  Widget build(BuildContext context) {

    widget.group.profilePicture != null
        ? profilePic = NetworkImage(widget.group.profilePicture!)
        : '';

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: profilePic,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: true
                        ? GestureDetector(
                            onTap: () async {
                              StorageService storageService = StorageService();
                              String? url =
                                  await storageService.showPicker(context);

                              if (url != null) {
                                setState(() {
                                  profilePic = NetworkImage(url);
                                });

                                widget.group.profilePicture = url;

                                // ignore: use_build_context_synchronously
                                await Provider.of<DatabaseService>(context,
                                        listen: false)
                                    .updateGroup(widget.group);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(_TopPortion.cameraIcon)),
                                  shape: BoxShape.circle),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                          ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}