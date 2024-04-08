import 'package:flutter/cupertino.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';

class AuthenticationException implements Exception {
  final String? _message;
  final AuthenticationExceptionType _type;

  AuthenticationException(this._message, this._type);

  AuthenticationException.firebase(String? message) : this(message, AuthenticationExceptionType.firebase);

  AuthenticationException.unknown() : this(null, AuthenticationExceptionType.unknown);

  String? message() {
    return _message;
  }
}

enum AuthenticationExceptionType { unknown, firebase }

extension AuthenticationExceptionMessageFormatting on AuthenticationException {
  String getMessage(BuildContext context) {
    switch (_type) {
      case AuthenticationExceptionType.unknown:
        return context.strings.unknownLoginError;
      case AuthenticationExceptionType.firebase:
        return _message ?? context.strings.unknownLoginError;
    }
  }
}
