import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/excercise.dart';
import '../services/db_service.dart';
import '../widgets/excercise_progression_widgets/add_excercise_button.dart';
import '../widgets/excercise_progression_widgets/excercise_scroller.dart';
import '../widgets/excercise_progression_widgets/excercise_tile.dart';
import 'excercise_history.dart';

class ExcerciseProgression extends StatefulWidget {
  const ExcerciseProgression({super.key});

  @override
  State<ExcerciseProgression> createState() => _ExcerciseProgressionState();
}

class _ExcerciseProgressionState extends State<ExcerciseProgression> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService dbservice = Provider.of<DatabaseService>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const AddExcerciseButton(),
      body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return [
              // Sliver bar holding title, only for stylistic purposes
              // TODO : add search bar
              SliverAppBar(
                expandedHeight: 100.0,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 10),
                    collapseMode: CollapseMode.pin,
                    title: Text("Excercises",
                        style: Theme.of(context).textTheme.displayLarge)),
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
                          snapshot.data as List<Excercise>);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
                  future: dbservice.excercises);
            },
          )),
    );
  }
}
