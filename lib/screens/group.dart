import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/screens/profile.dart';
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
            print("data");
            return const Scaffold(
              body: Center(
                child: Text("No data"),
              ),
            );
          }

          bool isAdmin = false;

          User currentUser = snapshot.data as User;
          List<Membership> groups = currentUser.groups;

          for (var group in groups) {
            if (group.groupName == widget.groupName && group.isAdmin == true) {
              isAdmin = true;
            }
          }

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
                print("data");
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(group.groupGoal)
                          ),
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
                          _GroupInfoRow(group, isAdmin)
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: bottomBar.getBar(context),
              );
            },
            future: DatabaseService().getGroup(widget.groupName!));
          },
          future: DatabaseService().getUser(Provider.of<AuthService>(context).uid),
        );
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
  user.joinGroup(group, false);
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
  // Basic image for groups without a group picture
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
                    child: GestureDetector(
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

class GroupInfoItem {
  final String title;
  final int value;
  const GroupInfoItem(this.title, this.value);
}

class _GroupInfoRow extends StatefulWidget {
  _GroupInfoRow(this.group, this.isAdmin, {Key? key}) 
  : gm = group.groupMembers.length, 
   super(key: key);

  final Group group;
  final bool isAdmin;
  int gm;

  void decrementGm() {
    gm--;
  }

  @override
  State<_GroupInfoRow> createState() => _GroupInfoRowState();
}

class _GroupInfoRowState extends State<_GroupInfoRow> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<ProfileInfoItem> items = [
            ProfileInfoItem("Members", widget.gm),
          ];

          return Container(
            height: 80,
            constraints: const BoxConstraints(maxWidth: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items
                  .map((item) => GestureDetector(
                        onTap: items.indexOf(item) == 0
                            ? () => _showMembers(context, widget)
                            : () {},
                        child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: _singleItem(
                                  context,
                                  item,
                                )),
                              ],
                            )),
                      ))
                  .toList(),
            ),
          );
        }),
        future: DatabaseService().getGroup(widget.group.name));
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
  );

  void _showMembers(BuildContext context, _GroupInfoRow gir) async {
    List<User?> members = [];

    for (String memberUid in widget.group.groupMembers) {
      members.add(await Provider.of<DatabaseService>(context, listen: false)
          .getUser(memberUid));
    }

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
            elevation: 100,
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Members'),
            ),
            contentPadding: const EdgeInsets.all(0),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.6,
              child: membersList(members, widget.isAdmin, widget.group, gir)
            ));
      }),
    );
  }
}

class membersList extends StatefulWidget {
  const membersList(this. members, this.isAdmin, this.group, this.gir, {super.key});
  final List<User?> members;
  final bool isAdmin;
  final Group group;
  final _GroupInfoRow gir;

  @override
  State<membersList> createState() => _membersListState();
}

class _membersListState extends State<membersList> {
  _leaveGroup(BuildContext context, Group group, User member) async {
    DatabaseService dbservice = DatabaseService();
    member.leaveGroup(group);
    group.removeMember(member.uid);
    dbservice.updateGroup(group);
    dbservice.updateUser(member);
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
                children: widget.members
                    .map((member) => ListTile(
                          title: Text(member!.name ?? 'No name'),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(member.profilePicture!),
                          ),
                          trailing: widget.isAdmin
                              ? ElevatedButton.icon(
                                onPressed: () async {
                                  await _leaveGroup(context, widget.group, member);
                                  setState(() {
                                    widget.members.remove(member);
                                    widget.gir.decrementGm();
                                  });
                                },
                                icon: Icon(Icons.delete_outline),
                                label: Text(""))
                              : const SizedBox(),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        userUid: member.uid,
                                      ))),
                        ))
                    .toList(),
              );
  }
}
