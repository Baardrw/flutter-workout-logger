import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/excercise.dart';
import '../services/db_service.dart';
import '../widgets/excercise_progression_widgets/add_excercise_button.dart';
import '../widgets/excercise_progression_widgets/excercise_list_view.dart';
import '../widgets/excercise_progression_widgets/excercise_tile.dart';
import '../common/bottom_bar.dart';
import 'excercise_history.dart';

class ExcerciseProgression extends StatefulWidget {
  const ExcerciseProgression({
    super.key,
    this.tile,
    this.gestureDetectorOnTap,
  });
  final String? tile;
  final Function(Excercise)? gestureDetectorOnTap;

  @override
  State<ExcerciseProgression> createState() => _ExcerciseProgressionState();
}

class _ExcerciseProgressionState extends State<ExcerciseProgression> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService dbservice = Provider.of<DatabaseService>(context);
    BottomBar bottomBar = BottomBar(1);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const AddExcerciseButton(),
      body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return [
              // Sliver bar holding title, only for stylistic purposes
              // TODO : add search bar
              SliverAppBar(
                elevation: 10,
                expandedHeight: 56,
                floating: false,
                foregroundColor: Colors.black,
                pinned: true,
                stretch: true,
                backgroundColor: Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(8),
                  collapseMode: CollapseMode.parallax,
                  title: Text(widget.tile ?? "Excercises",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: Colors.white)),
                ),
              ),
            ];
          }),
          // holds the ExcerciseScroller, in a stream builder and future builder
          // the stream builder listens to the db if it is updated scroller
          body: StreamBuilder(
            stream: dbservice.excerciseStream,
            builder: (context, snapshot) {
              return FutureBuilder(
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ExcerciseScroller(
                        snapshot.data as List<Excercise>,
                        gestureDetectorOnTap: widget.gestureDetectorOnTap,
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
                  future: dbservice.excercises);
            },
          )),
      bottomNavigationBar: bottomBar.getBar(context),
    );
  }
}
