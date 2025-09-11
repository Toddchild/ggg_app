import 'package:shared_preferences/shared_preferences.dart';

class CredStore {
  static const _kUser = 'ggg_user';
  static const _kPass = 'ggg_app_pass';

  Future<void> save(String user, String pass) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kUser, user);
    await p.setString(_kPass, pass);
  }

  Future<(String?, String?)> load() async {
    final p = await SharedPreferences.getInstance();
    return (p.getString(_kUser), p.getString(_kPass));
  }

  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kUser);
    await p.remove(_kPass);
  }
}
