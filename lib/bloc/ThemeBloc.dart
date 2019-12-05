import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ThemeBloc{
//  final _themeControler = StreamController<bool>();
//  get changeTheme => _themeControler.sink.add;
//  get dartThemeEnabled => _themeControler.stream;

//  PublishSubject<bool> _publishSubjectTheme;
//  bool get dartThemeEnabled => _publishSubjectTheme.stream;
//  get changeTheme => _publishSubjectTheme.sink.add;

  static ThemeBloc _themeBloc;

  PublishSubject<bool> _publishSubjectTheme;
  bool _dartThemeEnabled;
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
      _dartThemeEnabled != _dartThemeEnabled;
      _updateTheme();
    } catch (e) {
      print(e);
    }
  }

  void _updateTheme() {
    _publishSubjectTheme.sink.add(_dartThemeEnabled);
  }


  dispose() {
    _themeBloc = null;
    _publishSubjectTheme.close();
  }

}
