import 'package:formz/formz.dart';

class Password extends FormzInput<String, String> {
  const Password.pure() : super.pure('');

  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
  );

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'field can\'t be empty';
    }
    if (value.length > 32) {
      return 'too long password';
    }
    return _passwordRegExp.hasMatch(value)
        ? null
        : 'please use more strong password';
  }
}
