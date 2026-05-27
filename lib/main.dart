import 'dart:convert';
import 'package:ad_manager/ad_manager.dart';
import 'package:daily_cash/l10n/app_localizations.dart';
import 'package:daily_cash/res/theme_dark.dart';
import 'package:daily_cash/res/theme_light.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gma_mediation_unity/gma_mediation_unity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:izooto_plugin/iZooto_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'db/app_db.dart';
import 'di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Injector.initModules();
  // assetToFilePath(Assets.images.onBoarding2.path);
  await Injector.instance.isReady<AppDB>();
  await GoogleSignIn.instance.initialize();
  // await RemoteSettingsService.instance.init();
  await Injector.instance<AppDB>().handleAppOpen();
  await MobileAds.instance.initialize();
  await GmaMediationUnity().setCCPAConsent(true);
  await GmaMediationUnity().setGDPRConsent(true);
  await _iZootoInitialise();
  tz.initializeTimeZones();
  // 🔒 Lock orientation (portrait only)
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // final locale = context.watch<LocaleProvider>().selectedLocale;
        return MaterialApp.router(
          title: 'Daily Cash',
          debugShowCheckedModeBanner: false,
          // locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: ThemeMode.dark,
          theme: lightTheme,
          darkTheme: darkTheme,
          routerConfig: appRouter,
        );
      },
    );
  }
}

// The below lines should be added in the main app
const platform = MethodChannel("iZooto-flutter");
const landingURLPlateform = MethodChannel("iZooto-flutter_webview");
// iZooto initialisation
Future<void> _iZootoInitialise() async {
  iZooto.androidInit(false); // for Android
  // false will trigger WebView listener
  // true will trigger default WebView

  // DeepLink Android/iOS
  iZooto.shared.onNotificationOpened((data) {
    print('iZooto DeepLink Datadata : $data');
  });

  // LandingURLDelegate Android/iOS
  iZooto.shared.onWebView((landingUrl) {
    print(landingUrl);
    print('iZooto Landing URL  : $landingUrl');
  });

  // Received paylaod Android/iOS
  iZooto.shared.onNotificationReceived((payload) {
    print('iZooto Flutter Paylaod : $payload ');
    List<dynamic> list = json.decode(payload!);
    print(list.toString());
    List<dynamic> receivedpayload = list.reversed.toList();
    print(receivedpayload);
  });

  // Device token Android/iOS
  iZooto.shared.onTokenReceived((token) {
    print('iZooto Flutter Token : $token ');
  });

  // iOS WebView Listener Killed State
  try {
    String value = await landingURLPlateform.invokeMethod("handleLandingURL");
    print('iZooto Killed state ios data : $value ');
  } on Exception {}

  //iOS DeepLink Killed state code
  try {
    String value = await platform.invokeMethod("OpenNotification");
    print('iZooto Killed state ios data : $value ');
  } catch (Exception) {}
}
