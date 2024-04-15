import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:papa_mama_recipe/common/error_page.dart';
import 'package:papa_mama_recipe/common/loading_page.dart';
import 'package:papa_mama_recipe/features/auth/controller/auth_controller.dart';
import 'package:papa_mama_recipe/features/auth/view/signup_view.dart';
import 'package:papa_mama_recipe/features/home/view/home_view.dart';
import 'package:papa_mama_recipe/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Twitter Clone',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomeView();
              }
              return const SignUpView();
            },
            error: (error, st) => ErrorPage(
              error: error.toString(),
            ),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
