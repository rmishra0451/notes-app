import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> cannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Unable to share',
    content: 'Cannot share an empty note!',
    optionsBuilder: () => {'OK': null},
  );
}
