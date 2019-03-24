import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:narai/blocs/lessonsBloc.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/pages/home/help/settingsPage.dart';
import 'package:narai/pages/home/helpPage.dart';
import 'package:narai/pages/home/learnPage.dart';
import 'package:narai/pages/home/lessonsPage.dart';
import 'package:narai/pages/home/playgroundPage.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';

class HomePage extends StatefulWidget {
  int _screen;
  HomePage({ Key key, int screen }) : _screen = screen, super(key: key);
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 1;
  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(title: Text(loc.learn), icon: Container(child: const Icon(FontAwesomeIcons.bookOpen, size: 22), padding: const EdgeInsets.only(right: 2))),
          BottomNavigationBarItem(title: Text(loc.lessons), icon: const Icon(Icons.code)),
          BottomNavigationBarItem(title: Text(loc.playground), icon: const Icon(FontAwesomeIcons.child)),
          BottomNavigationBarItem(title: Text(loc.info), icon: Icon(Icons.info)),
          // BottomNavigationBarItem(title: Text(loc.settings), icon: Icon(Icons.settings)),
        ],
        onTap: bottomNavigationBarItemTapped,
        currentIndex: min(_page, 3)
      ),
      body: SafeArea(
        child: PageView(
          children: [
            LearnPage(),
            LessonsPage(),
            PlaygroundPage(),
            HelpPage(),
            SettingsPage(),
          ],
          controller: _pageController,
          onPageChanged: onPageChanged
        )
      )
    );
  }
  void bottomNavigationBarItemTapped(int page) {
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
    _page = widget._screen ?? _page;
    _pageController = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
