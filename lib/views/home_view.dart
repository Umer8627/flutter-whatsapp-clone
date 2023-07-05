import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/repo/auth_repo.dart';
import 'package:whatsapp_clone/state/user_state.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/chat/chats_list_view.dart';
import 'package:whatsapp_clone/views/contacts/contacts_view.dart';

import '../constants/color_constant.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  int _currentIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    pageController = PageController(initialPage: _currentIndex);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserState>(context, listen: false)
          .setUserModel(FirebaseAuth.instance.currentUser!.uid);
    });
 
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        AuthRepo.instance.setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        AuthRepo.instance.setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whatsapp'),
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 17,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        elevation: 0,
        bottom: TabBar(
          controller: tabBarController,
          indicatorColor: tabColor,
          indicatorWeight: 4,
          labelColor: tabColor,
          unselectedLabelColor: Colors.grey,
          onTap: (index) {
            _currentIndex = index;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          labelStyle:
              CustomFont.regularText.copyWith(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Status'),
            Tab(text: 'Calls'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tabBarController.index == 0) {
            push(context, const ContactsView());
          }
        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.comment,
          color: Colors.white,
        ),
      ),
      body: PageView(
        onPageChanged: (index) {
          _currentIndex = index;

          tabBarController.animateTo(index);
        },
        controller: pageController,
        children: [
          const ChatListView(),
          Center(
            child: ElevatedButton(
              onPressed: () async {},
              child: const Text('Status'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Calls'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
