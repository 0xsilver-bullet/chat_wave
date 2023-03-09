import 'package:formz/formz.dart';

class Name extends FormzInput<String, String> {
  const Name.pure() : super.pure('');

  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'field can\'t be empty';
    }
    return null;
  }
}
