import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/state/chat_state.dart';
import 'package:whatsapp_clone/state/internet_state.dart';
import 'package:whatsapp_clone/state/timer_state.dart';
import 'package:whatsapp_clone/state/user_state.dart';
import 'package:whatsapp_clone/views/splash_view.dart';
import 'state/loading_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await fastCachedNetworkImageConfig();
  await Hive.openBox('contacts');
  await Hive.openBox('messages');
  await Hive.openBox('users');
  await Hive.openBox('senderUser');


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoadingState()),
      ChangeNotifierProvider(create: (_) => TimerState()),
      ChangeNotifierProvider(create: (_) => UserState()),
      ChangeNotifierProvider(create: (_) => ChatState()),
      ChangeNotifierProvider(create: (_) => InternetState()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Provider.of<InternetState>(context, listen: false)
        .checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatsapp Clone',
      theme: getTheme(),
      home: const SplashView(),
    );
  }
}

Future<void> fastCachedNetworkImageConfig() async {
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 30));
}
