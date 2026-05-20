import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_load(_prefs));

  static ThemeMode _load(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    if (saved == 'dark') return ThemeMode.dark;
    if (saved == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  void setLight() {
    _prefs.setString(_key, 'light');
    emit(ThemeMode.light);
  }

  void setDark() {
    _prefs.setString(_key, 'dark');
    emit(ThemeMode.dark);
  }

  void toggle() => state == ThemeMode.dark ? setLight() : setDark();
}
