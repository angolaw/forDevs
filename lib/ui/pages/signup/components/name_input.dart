import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/helpers.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: R.strings.name,
        icon: Icon(
          Icons.person_outline,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }
}
