import 'package:flutter/material.dart';
import 'package:narai/localization/appLocalizations.dart';
import 'package:narai/etc/theme.dart';
import 'package:narai/pages/home/help/settingsPage.dart';
import 'package:narai/routing.dart';
import 'package:narai/widgets/applicationBlocProviderWidget.dart';

class HelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  PageController _pageController;
  int _page = 0;

  Widget buildMenu(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(loc.settings),
            onTap: () => router.navigateTo(context, "/home?screen=4"),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(loc.manual),
          ),
          AboutListTile(
            applicationName: loc.appTitle,
            applicationIcon: Image.asset("assets/NaraiIcon.png", height: 100),
            applicationLegalese: '© Made by Filip "botafi" Botai 2018-2019',
          ),
        ],
      );
  }
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return PageView(
        children: [
          this.buildMenu(context),
          SettingsPage(),
        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
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
    _pageController = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigateTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease
    );
  }
}