import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:narai/blocs/interpreterBloc.dart';
import 'package:narai/blocs/lessonBloc.dart';
import 'package:narai/blocs/lessonsBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/etc/extendedState.dart';
import 'package:narai/etc/theme.dart';
import 'package:narai/models/lesson.dart';
import 'package:narai/pages/lesson/cards.dart';
import 'package:narai/pages/lesson/lesson.dart';
import 'package:narai/pages/lesson/result.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';
import 'package:narai/widgets/components/fabMenu.dart';
import 'package:narai/widgets/components/successModal.dart';
import 'package:narai/routing.dart';

class LessonPage extends StatefulWidget {
  LessonPage({ Key key, name: String }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _LessonPageState();
  }
}

class _LessonPageState extends State<LessonPage> with ExtendedState {
  PageController _pageController;
  int _page = 0;

  StreamSubscription<void> qrsCapturedSubs;

  StreamSubscription<void> ranSubs;

  StreamSubscription<int> successSubs;

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);
    var interpreterBloc = ApplicationBlocProviderWidget.of<InterpreterBloc>(context);
    var lessonBloc = ApplicationBlocProviderWidget.of<LessonBloc>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(title: Text(loc.lesson), icon: Container(child: const Icon(FontAwesomeIcons.fileAlt, size: 20), padding: EdgeInsets.only(bottom: 3))),
          BottomNavigationBarItem(title: Text(loc.cards), icon: Container(child: const Icon(FontAwesomeIcons.qrcode, size: 19), padding: EdgeInsets.only(bottom: 3))),
          BottomNavigationBarItem(title: Text(loc.result), icon: const Icon(Icons.playlist_play, size: 26)), // BottomNavigationBarItem(title: Text(loc.result), icon: Container(child: const Icon(FontAwesomeIcons.code, size: 24), padding: const EdgeInsets.only(right: 4.25))),
        ],
        onTap: navigateTo,
        currentIndex: _page
      ),
      floatingActionButton: FabMenu(
        onPressed: () => null,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.delete_forever),
            onPressed: () => interpreterBloc.reset.add(null),
            tooltip: loc.clear,
            heroTag: "clearfab",
            backgroundColor: secondaryColorLight
          ),
          FloatingActionButton(
            child: const Icon(Icons.add_a_photo),
            onPressed: () => null,
            tooltip: loc.scanAdditionalCards,
            heroTag: "scanaddfab",
            backgroundColor: primaryColorLight
          ),
          FloatingActionButton(
            child: const Icon(Icons.photo_camera),
            onPressed: () => interpreterBloc.requestQRs.add(null),
            tooltip: loc.scanCards,
            heroTag: "scanfab",
            backgroundColor: primaryColor
          ),
          FloatingActionButton(
            backgroundColor: secondaryGreen,
            tooltip: loc.run,
            child: const Icon(FontAwesomeIcons.play, size: 17),
            onPressed: () => lessonBloc.run.add(null),
            heroTag: "runfab",
          )
        ],
      ),
      body: SafeArea(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            LessonDescriptionPage(),
            LessonCardsPage(),
            LessonResultPage(),
          ],
          controller: _pageController,
          onPageChanged: onPageChanged
        )
      )
    );
  }

  void navigateTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease
    );
  }
  void onPageChanged(int page){
    setState((){
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() async {
    super.dispose();
    await qrsCapturedSubs.cancel();
    await ranSubs.cancel();
    await successSubs.cancel();

    // var interpreterBloc = ApplicationBlocProviderWidget.of<InterpreterBloc>(context);
    // interpreterBloc.reset.add(null);

    _pageController.dispose();
  }

  @override
  afterBuild() {
    var interpreterBloc = ApplicationBlocProviderWidget.of<InterpreterBloc>(context);
    var lessonBloc = ApplicationBlocProviderWidget.of<LessonBloc>(context);
    var lessonsBloc = ApplicationBlocProviderWidget.of<LessonsBloc>(context);
    qrsCapturedSubs = interpreterBloc.qrsCaptured.listen((_) => navigateTo(1));
    ranSubs = lessonBloc.ran.listen((_) {
      navigateTo(2);
    });
    successSubs = lessonBloc.success.listen((r) async {
      await Future.delayed(Duration(seconds: 1));
      showDialog(
        context: context,
        builder: (context) => StreamBuilder<String>(
          stream: lessonsBloc.nextLesson,
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) => SuccessModal(
            rating: r,
            onNextLessonPressed:
            snapshot.data != null ?
              (() => 
                router.navigateTo(context, "/lesson?name=${snapshot.data}", clearStack: true)
              ) : null
          )
        ),
      );
    });
  }
}