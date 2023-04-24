import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final spinkit = SpinKitCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.grey : Colors.grey,
      ),
    );
  },
);
String? Function(String?) get mandatoryValidator =>
    (String? val) => val?.isEmpty ?? true ? "This field is mandatory" : null;

String? Function(String?) get emailValidator => (String? email) => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email ?? "")
        ? null
        : "Enter a valid email";
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

DateTime convertDateTimePtBR(String validade) {
  DateTime parsedDate = DateTime.parse('0001-11-30 00:00:00.000');

  List<String> validadeSplit = validade.split('/');

  if (validadeSplit.length > 1) {
    String day = validadeSplit[0].toString();
    String month = validadeSplit[1].toString();
    String year = validadeSplit[2].toString();

    parsedDate = DateTime.parse('$year-$month-$day 00:00:00.000');
  }

  return parsedDate;
}

String? Function(String?) get numberValidator =>
    (String? number) => number?.isEmpty ?? true
        ? "This field is mandatory"
        : RegExp(r"^[0-9]*$").hasMatch(number ?? "")
            ? null
            : "Enter a valid number";

String parseDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

// String parseTime(DateTime time) {
//   return DateFormat.jm().format(time);
// }

String parseDateTime(DateTime date) {
  return "${parseDate(date)} ${parseTime(date)}";
}

String parseTime(DateTime time) => DateFormat.Hm().format(time);
String parseTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return parseTime(date);
}

void pushNamed(BuildContext context, String routeName) =>
    Navigator.pushNamed(context, routeName);

String? Function(String?) get passwordValidator =>
    (String? password) => password!.isEmpty ? "Password is mandatory" : null;
// (password?.length ?? 0) < 8 ? "Password too short" : null;

String? validateConfirmPassword(String password, String? confirm) {
  if (password != confirm) {
    return "Passwords don't match";
  }
  final err = passwordValidator(confirm);
  if (err != null) {
    return err;
  } else {
    return null;
  }
}

Future<T?> push<T>(BuildContext context, Widget child) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => child));

void replace(BuildContext context, Widget child) => Navigator.of(context)
    .pushReplacement(MaterialPageRoute(builder: (_) => child));

void pop(BuildContext context) => Navigator.of(context).pop();

void popToMain(BuildContext context) =>
    Navigator.of(context).popUntil((route) => route.isFirst);

void snack(BuildContext context, String message,
    {bool info = false, Color color = Colors.red}) {
  debugPrint(message);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: info ? Theme.of(context).primaryColor : color,
    // behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
          ),
    ),
  ));
}

// Future<Uint8List?> pickedImage(BuildContext context) async {
//   final image = await FilePicker().pickImage(source: ImageSource.gallery);
//   if (image != null) {
//     final imageBytes = await image.readAsBytes();
//     return imageBytes;
//   }
//   return null;
// }

void alert(BuildContext context, String message,
    {bool info = false, IconData? icon, String? title, double? titleFont}) {
  debugPrint(message);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 120),
      actionsPadding:
          const EdgeInsets.symmetric(vertical: 40, horizontal: 120) -
              const EdgeInsets.only(top: 40),
      actionsAlignment: MainAxisAlignment.center,
      title: info
          ? Icon(
              icon ?? Icons.check_circle_outline,
              color: Theme.of(context).primaryColor,
              size: 90,
            )
          : Icon(
              icon ?? Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 90,
            ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? (info ? "Success" : "Error"),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: titleFont ?? 24,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("Okay"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

void sureAlert({
  required BuildContext context,
  required String message,
  required void Function() onYes,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 40, horizontal: 120),
        actionsPadding:
            const EdgeInsets.symmetric(vertical: 40, horizontal: 120) -
                const EdgeInsets.only(top: 40),
        actionsAlignment: MainAxisAlignment.center,
        title: Icon(
          Icons.help_outline,
          color: Theme.of(context).primaryColor,
          size: 90,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Are you sure?",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("Yes"),
            onPressed: () {
              onYes();
              pop(context);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

Widget getLoader() =>  Center(child: spinkit);

Widget getErrorMessage(BuildContext context, e) {
  debugPrint(e);

  return Center(
    child: Text(
      e is FirebaseException ? e.message ?? e.code : e,
      style:
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red),
      textAlign: TextAlign.center,
    ),
  );
}

// ! Upload categoryImage;

Future<String> uploadImage(
    {required String name,
    required File image,
    required Reference reference}) async {
  final resp = await reference.child('$name.png').putFile(image);
  return resp.ref.getDownloadURL();
}

Widget getShimmer({double width = 40, height = 12}) {
  return Container(
    color: Colors.grey,
    height: height,
    width: width,
  );
}

// Widget getFirebaseError(BuildContext context, error) {
//   return getErrorMessage(context,
//       error is FirebaseException ? error.message ?? error.code : '$error');
// }

bool isKeyboardOpen(BuildContext context) =>
    MediaQuery.of(context).viewInsets.bottom != 0;

Future<String?> alertInput(BuildContext context, String title, String hint,
    {String doneText = "Done"}) async {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      actionsAlignment: MainAxisAlignment.center,
      title: Text(title),
      content: SizedBox(
        width: 500,
        child: TextField(
          decoration: InputDecoration(hintText: hint),
          controller: controller,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Text("Cancel", style: TextStyle(color: Colors.orange)),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(doneText),
          onPressed: () => Navigator.of(context).pop(controller.text),
        ),
      ],
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    snack(context, e.toString());
  }
  return image;
}

String generateRandomString(int length) {
  final random = Random();
  const chars = '0123456789';
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}
