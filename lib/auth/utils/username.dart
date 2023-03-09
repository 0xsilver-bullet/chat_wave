import 'package:formz/formz.dart';

class Username extends FormzInput<String, String> {
  const Username.pure() : super.pure('');

  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    if (value.isEmpty) {
      return 'field can\'t be empty';
    }
    return null;
  }
}
