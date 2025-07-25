import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_web_app/core/constants/app_constants.dart';
import 'package:to_do_web_app/core/provider/theme_provider.dart';
import 'package:to_do_web_app/feature/main_layout_page.dart';
import 'package:to_do_web_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform.copyWith(
        databaseURL: "https://todowebapp-f175c-default-rtdb.firebaseio.com",
      ),
    );
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ScreenUtilInit(
      designSize: Size(393, 852),
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppConstants.lightTheme,
            darkTheme: AppConstants.darkTheme,
            themeMode: themeMode,
            home: MainLayout(),
          ),
        );
      },
    );
  }
}
