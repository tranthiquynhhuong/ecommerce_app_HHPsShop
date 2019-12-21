import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc {
  static ThemeBloc _themeBloc;

  PublishSubject<bool> _publishSubjectTheme;
  bool _dartThemeEnabled = false;

  bool get dartThemeEnabled => _dartThemeEnabled;

  factory ThemeBloc() {
    if (_themeBloc == null) _themeBloc = new ThemeBloc._();

    return _themeBloc;
  }

  ThemeBloc._() {
    _publishSubjectTheme = new PublishSubject<bool>();
  }

  Observable<bool> get observableTheme => _publishSubjectTheme.stream;

  void changeTheme() async {
    try {
      _dartThemeEnabled = !_dartThemeEnabled;
      if (_dartThemeEnabled == true) {
        enableDarkThemeToSF();
      } else if (_dartThemeEnabled == false) {
        disableDarkThemeToSF();
      }
      getThemeValuesSF();
      _updateTheme();
    } catch (e) {
      print(e);
    }
  }



  getThemeValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('darkThemeEnable');
    _dartThemeEnabled=boolValue??false;
    _updateTheme();
    return boolValue;
  }

  enableDarkThemeToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkThemeEnable', true);
  }

  disableDarkThemeToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkThemeEnable', false);
  }

  void _updateTheme() {
    _publishSubjectTheme.sink.add(_dartThemeEnabled);
  }

  dispose() {
    _themeBloc = null;
    _publishSubjectTheme.close();
  }
}
