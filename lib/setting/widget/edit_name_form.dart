import 'package:chat_wave/utils/blocs/app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/name_bloc/name_bloc.dart';

class EditNameForm extends StatefulWidget {
  const EditNameForm(
    this.currentName, {
    super.key,
  });

  final String currentName;

  @override
  State<EditNameForm> createState() => _EditNameFormState();
}

class _EditNameFormState extends State<EditNameForm> {
  late final TextEditingController _nameFieldController;

  @override
  void initState() {
    _nameFieldController = TextEditingController(text: widget.currentName);
    super.initState();
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forceDarkMode = BlocProvider.of<AppBloc>(context).state.forceDarkMode;
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return BlocConsumer<NameBloc, NameState>(
      listener: (context, state) {
        if (state is UpdatedUserName) {
          // Then we should roll back to DefaultNameState
          BlocProvider.of<NameBloc>(context).add(FinishedNameChange());
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Theme(
              data: ThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  hintStyle: TextStyle(
                    color: isDarkMode || forceDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              child: TextField(
                maxLines: 1,
                textInputAction: TextInputAction.done,
                controller: _nameFieldController,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<NameBloc>(context)
                        .add(EditUserName(_nameFieldController.text));
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(width: 8),
              ],
            )
          ],
        );
      },
    );
  }
}
