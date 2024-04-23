import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/features/auth/controller/auth_controller.dart';
import 'package:papa_mama_recipe/features/settings/controller/settings_controller.dart';
import 'package:papa_mama_recipe/models/user_model.dart';

class EditSettingsScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => EditSettingsScreen(),
      );

  EditSettingsScreen({Key? key}) : super(key: key);

  @override
  _EditSettingsScreenState createState() => _EditSettingsScreenState();
}

class _EditSettingsScreenState extends ConsumerState<EditSettingsScreen> {
  late TextEditingController emailController;
  late TextEditingController linkedUidController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value?.email ?? '');
    linkedUidController = TextEditingController(
        text: ref.read(currentUserDetailsProvider).value?.linkedUid ?? '');
  }

  @override
  void dispose() {
    emailController.dispose();
    linkedUidController.dispose();
    super.dispose();
  }

  void updateSettings() {
    final email = emailController.text;
    final linkedUid = linkedUidController.text;
    final settingsEntry = UserModel(
        uid: '',
        email: email,
        linkedUid: linkedUid,
        lastLoginDateTime: DateTime.now());
    ref
        .read(userControllerProvider.notifier)
        .updateUserProfile(userModel: settingsEntry, context: context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    if (currentUser != null) {
      emailController.text = currentUser.email ?? '';
    }

    return
        // currentUser == null        ? const Loader()        :
        Scaffold(
      appBar: AppBar(title: Text('設定'), actions: [
        IconButton(
          onPressed: () {
            ref.read(authControllerProvider.notifier).logout(context);
          },
          icon: Icon(Icons.logout),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Text(
              'メールアドレス',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'メールアドレスを入力してください',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '本人UID',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              currentUser?.uid ?? 'UIDが見つかりません',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Text(
              '連携UID',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: linkedUidController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '連携UIDを入力してください',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: updateSettings,
              child: Text('更新'),
            ),
          ],
        ),
      ),
    );
  }
}
