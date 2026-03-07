import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/edit_profile_controller.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            const CircleAvatar(
              radius: 40,
            ),

            const SizedBox(height: 20),

            TextField(
              decoration: const InputDecoration(labelText: "Name"),
              onChanged: (v) =>
                  ref.read(profileProvider.notifier).updateName(v),
            ),

            TextField(
              decoration: const InputDecoration(labelText: "Email"),
              onChanged: (v) =>
                  ref.read(profileProvider.notifier).updateEmail(v),
            ),

            TextField(
              decoration: const InputDecoration(labelText: "Phone"),
              onChanged: (v) =>
                  ref.read(profileProvider.notifier).updatePhone(v),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Save Changes"),
            ),

            const SizedBox(height: 30),

            const Text("SECURITY DETAILS"),

            TextField(
              decoration: const InputDecoration(
                labelText: "Current Password",
              ),
            ),

            TextField(
              decoration: const InputDecoration(
                labelText: "New Password",
              ),
            ),

            TextField(
              decoration: const InputDecoration(
                labelText: "Confirm Password",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Save Password"),
            ),
          ],
        ),
      ),
    );
  }
}