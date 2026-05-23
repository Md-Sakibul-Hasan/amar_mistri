import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _key = 'locale';
  final SharedPreferences _prefs;

  LocaleCubit(this._prefs) : super(_load(_prefs));

  static Locale _load(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    if (saved == 'en') return const Locale('en');
    return const Locale('bn');
  }

  void setEnglish() {
    _prefs.setString(_key, 'en');
    emit(const Locale('en'));
  }

  void setBangla() {
    _prefs.setString(_key, 'bn');
    emit(const Locale('bn'));
  }
}
