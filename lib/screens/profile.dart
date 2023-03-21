import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/services/storage_service.dart';
import 'package:pu_frontend/widgets/app_bar.dart';
import 'package:pu_frontend/widgets/progress_card.dart';

import '../common/bottom_bar.dart';
import '../models/excercise.dart';
import '../models/user.dart';

/// Inspired by this template https://www.fluttertemplates.dev/widgets/must_haves/profile_page

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, this.userUid}) : super(key: key);
  String? userUid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  BottomBar bottomBar = BottomBar(4);

  @override
  Widget build(BuildContext context) {
    final myUid = Provider.of<AuthService>(context).uid;
    if (userUid != myUid && userUid != null) {
      bottomBar = BottomBar(3);
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
            return const Scaffold(
              body: Center(
                child: Text("No data"),
              ),
            );
          }

          User user = snapshot.data as User;

          bool areFreinds = user.freinds.contains(myUid);
          print(areFreinds);

          return Scaffold(
            appBar: GlobalAppBar(title: user.name ?? 'No name'),
            body: ListView(
              children: [
                const SizedBox(height: 16),
                _TopPortion(user),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        user.name ?? 'No name',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      widget.userUid == null
                          ? const SizedBox()
                          : const SizedBox(height: 16),
                      widget.userUid == null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton.extended(
                                  onPressed: () async {
                                    if (areFreinds) {
                                      await _removeFreind(context, user, myUid);
                                      setState(() {
                                        areFreinds = false;
                                      });
                                    } else {
                                      await _addFreind(context, user);
                                      setState(() {
                                        areFreinds = true;
                                      });
                                    }
                                  },
                                  heroTag: 'Add Freind',
                                  elevation: 0,
                                  label: areFreinds
                                      ? const Text('UnFreind')
                                      : const Text("Add Freind"),
                                  icon: areFreinds
                                      ? const Icon(Icons.person_remove_alt_1)
                                      : const Icon(Icons.person_add_alt_1),
                                ),
                              ],
                            ),
                      const SizedBox(height: 16),
                      _ProfileInfoRow(user),
                      _ProfileExcerciseProgressionColumn(user),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: bottomBar.getBar(context),
          );
        },
        future: widget.userUid == null
            ? Provider.of<DatabaseService>(context).getUser(myUid)
            : Provider.of<DatabaseService>(context).getUser(widget.userUid!));
  }

  _addFreind(BuildContext context, User user) async {
    user.addFreindRequest(Provider.of<AuthService>(context, listen: false).uid);

    await Provider.of<DatabaseService>(context, listen: false).updateUser(user);
  }

  _removeFreind(BuildContext context, User user, String myUid) async {
    User? myUser = await Provider.of<DatabaseService>(context, listen: false)
        .getUser(myUid);

    user.removeFreind(myUid);
    myUser!.removeFreind(user.uid);

    await Provider.of<DatabaseService>(context, listen: false)
        .updateUser(myUser);
    await Provider.of<DatabaseService>(context, listen: false).updateUser(user);
  }
}

class _ProfileInfoRow extends StatelessWidget {
  _ProfileInfoRow(this.user, {Key? key}) : super(key: key);
  final User user;

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
            ProfileInfoItem("Workouts", snapshot.data!),
            ProfileInfoItem("Friends", user.freinds.length),
            ProfileInfoItem("Groups", user.groups.length),
          ];

          return Container(
            height: 80,
            constraints: const BoxConstraints(maxWidth: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items
                  .map((item) => GestureDetector(
                        onTap: items.indexOf(item) == 1
                            ? () => _showFreinds(context)
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
        future:
            Provider.of<DatabaseService>(context).getSessionCount(user.uid));
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

  void _showFreinds(BuildContext context) async {
    List<User?> freinds = [];

    for (String freindUid in user.freinds) {
      freinds.add(await Provider.of<DatabaseService>(context, listen: false)
          .getUser(freindUid));
    }

    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
            title: const Text('Notifications'),
            contentPadding: EdgeInsets.all(0),
            content: ListView(
              children: freinds
                  .map((freind) => ListTile(
                        title: Text(freind!.name ?? 'No name'),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(freind.profilePicture!),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      userUid: freind.uid,
                                    ))),
                      ))
                  .toList(),
            ));
      }),
    );
  }
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatefulWidget {
  const _TopPortion(this.user, {Key? key}) : super(key: key);

  final User user;

  static String cameraIcon =
      "https://www.creativefabrica.com/wp-content/uploads/2019/05/Camera-icon-by-demolabid-580x386.jpg";

  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
  // Basic image for users without a profile picture
  NetworkImage profilePic = NetworkImage(
      "https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg");

  @override
  Widget build(BuildContext context) {
    bool userIsMe = widget.user.uid == Provider.of<AuthService>(context).uid;
    widget.user.profilePicture != null
        ? profilePic = NetworkImage(widget.user.profilePicture!)
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
                    child: userIsMe
                        ? GestureDetector(
                            onTap: () async {
                              StorageService storageService = StorageService();
                              String? url =
                                  await storageService.showPicker(context);

                              if (url != null) {
                                setState(() {
                                  profilePic = NetworkImage(url);
                                });

                                widget.user.profilePicture = url;

                                // ignore: use_build_context_synchronously
                                await Provider.of<DatabaseService>(context,
                                        listen: false)
                                    .updateUser(widget.user);
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

class _ProfileExcerciseProgressionColumn extends StatelessWidget {
  const _ProfileExcerciseProgressionColumn(this.user, {super.key});
  final User user;

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

          List<Excercise> excercises = snapshot.data as List<Excercise>;
          print(excercises);

          return Column(
            children: [
              const SizedBox(height: 16),
              ..._getExcerciseProgressionTiles(excercises, context),
            ],
          );
        }),
        future: Provider.of<DatabaseService>(context)
            .getExcercisesUserHasDone(user.uid));
  }

  List<FutureBuilder> _getExcerciseProgressionTiles(
      List<Excercise> excercises, BuildContext context) {
    List<FutureBuilder> tiles = [];

    for (Excercise excercise in excercises) {
      tiles.add(
        FutureBuilder(
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Log> logs = snapshot.data as List<Log>;

            return ProgressCard(excercise, logs);
          }),
          future: Provider.of<DatabaseService>(context, listen: false).getLogs(
              excercise.name,
              Provider.of<AuthService>(context, listen: false).uid),
        ),
      );
    }

    return tiles;
  }
}
