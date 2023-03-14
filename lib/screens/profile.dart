import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pu_frontend/services/auth_service.dart';
import 'package:pu_frontend/services/db_service.dart';
import 'package:pu_frontend/services/storage_service.dart';
import 'package:pu_frontend/widgets/progress_card.dart';

import '../common/bottom_bar.dart';
import '../models/excercise.dart';
import '../models/user.dart';

/// Inspired by this template https://www.fluttertemplates.dev/widgets/must_haves/profile_page

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key, this.userUid}) : super(key: key);
  String? userUid;
  BottomBar bottomBar = BottomBar(4);

  @override
  Widget build(BuildContext context) {
    final myUid = Provider.of<AuthService>(context).uid;

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

          return Scaffold(
            appBar: AppBar(title: Text('${user.name ?? 'No name'}')),
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
                      userUid == null
                          ? const SizedBox()
                          : const SizedBox(height: 16),
                      userUid == null
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton.extended(
                                  onPressed: () {},
                                  heroTag: 'Add Freind',
                                  elevation: 0,
                                  label: const Text("Add Freind"),
                                  icon: const Icon(Icons.person_add_alt_1),
                                ),
                                const SizedBox(width: 16.0),
                                FloatingActionButton.extended(
                                  onPressed: () {},
                                  heroTag: 'mesage',
                                  elevation: 0,
                                  backgroundColor: Colors.red,
                                  label: const Text("Message"),
                                  icon: const Icon(Icons.message_rounded),
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
        future: userUid == null
            ? Provider.of<DatabaseService>(context).getUser(myUid)
            : Provider.of<DatabaseService>(context).getUser(userUid!));
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
            ProfileInfoItem("Freinds", user.freinds.length),
            ProfileInfoItem("Groups", user.groups.length),
          ];

          return Container(
            height: 80,
            constraints: const BoxConstraints(maxWidth: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items
                  .map((item) => Expanded(
                          child: Row(
                        children: [
                          if (items.indexOf(item) != 0) const VerticalDivider(),
                          Expanded(child: _singleItem(context, item)),
                        ],
                      )))
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
            padding: const EdgeInsets.all(8.0),
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
