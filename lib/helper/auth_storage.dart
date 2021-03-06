import 'dart:async';
import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:aad_oauth/model/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static AuthStorage shared = AuthStorage();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final String _tokenIdentifier;

  AuthStorage({String tokenIdentifier = 'Token'})
      : _tokenIdentifier = tokenIdentifier;

  Future<void> saveTokenToCache(Token token) async {
    var data = Token.toJsonMap(token);
    var json = jsonEncode(data);
    await _secureStorage.write(key: _tokenIdentifier, value: json);
  }

  Future<T> loadTokenFromCache<T extends Token>() async {
    var emptyToken = Token() as T;
    var json = await _secureStorage.read(key: _tokenIdentifier);
    if (json == null) return emptyToken;
    try {
      var data = jsonDecode(json);
      return _getTokenFromMap<T>(data);
    } catch (exception) {
      print(exception);
      return emptyToken;
    }
  }

  T _getTokenFromMap<T extends Token>(Map<String, dynamic> data) =>
      Token.fromJson(data) as T;

  Future clear() async {
    await _secureStorage.delete(key: _tokenIdentifier);
  }
}
