import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:whatsapp_clone/constants/color_constant.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/repo/contact_repo.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/chat/chat_room.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: FutureBuilder<List<Contact>>(
          future: ContactRepo.instance.getContactFromFirebase(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              log(snapshot.error.toString());
              return Center(
                  child: Text(
                      'Contacts permission was denied. Enable it from settings',
                      textAlign: TextAlign.center,
                      style:
                          CustomFont.regularText.copyWith(color: Colors.red)));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.hexagonDots(
                      color: tabColor, size: 50));
            }
            if (snapshot.hasData) {
              List<Contact> contacts = snapshot.data!;
              return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (_, index) {
                    Contact contact = contacts[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: backgroundColor,
                        elevation: 10,
                        child: InkWell(
                          onTap: () async {
                            UserModel model = await ContactRepo.instance
                                .selectedContact(contact);
                            if (!mounted) return;
                            push(context, ChatRoom(userModel: model));
                          },
                          child: ListTile(
                            title: Text(
                              contact.displayName,
                              style: CustomFont.regularText
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            leading: contact.photo == null
                                ? const CircleAvatar(
                                    radius: 20,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.photo!),
                                    radius: 20,
                                  ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                  child:
                      Text("No contacts found", style: CustomFont.regularText));
            }
          }),
    );
  }
}
