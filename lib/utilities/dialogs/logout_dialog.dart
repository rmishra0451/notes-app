import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
          context: context,
          title: 'Logout',
          content: 'Are you sure you want to logout?',
          optionsBuilder: () => {'Cancel': false, 'Logout': true})
      .then((value) => value ?? false);
}


// import 'package:flutter/material.dart';

// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Log out'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//                 child: const Text('Cancel')),
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: const Text('Log out'))
//           ],
//         );
//       }).then((value) => value ?? false);
// }


