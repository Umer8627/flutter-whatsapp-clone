import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user_model.dart';

UserModel? senderModel;

final spinkit = SpinKitCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.grey : Colors.grey,
      ),
    );
  },
);
final threepoints = SpinKitCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.grey : Colors.grey,
      ),
    );
  },
);

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

String standardFormatTime(DateTime dataTime) {
  final DateFormat formatter = DateFormat('h:mm a');
  return formatter.format(dataTime);
}

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

Widget getLoader() => Center(child: spinkit);

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

bool isKeyboardOpen(BuildContext context) =>
    MediaQuery.of(context).viewInsets.bottom != 0;

Future<File?> pickImage(
    {required BuildContext context, required ImageSource imageSource}) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);

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
