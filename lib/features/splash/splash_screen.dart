// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:daily_cash/extension/ext_context.dart';
// import 'package:daily_cash/gen/assets.gen.dart';
// import 'package:daily_cash/routes/app_routes.dart';
// import 'package:daily_cash/utils/app_size.dart';
// import 'package:daily_cash/utils/logger.dart';
// import 'package:daily_cash/widgets/app_button.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   bool isInternet = true;

//   @override
//   void initState() {
//     super.initState();
//     checkInternet();

//     Future.delayed(Duration.zero, () async {
//       if (context.mounted) {
//         await precacheImage(Assets.images.intro1.provider(), context);
//         await precacheImage(Assets.images.intro2.provider(), context);
//         await precacheImage(Assets.images.intro3.provider(), context);
//       }
//     });

//     Future.delayed(const Duration(seconds: 10), () {
//       if (!mounted) return;

//       context.goNamed(AppRoutes.onBoardring);
//     });
//   }

//   Future<bool> checkInternet() async {
//     final status = await Connectivity().checkConnectivity();

//     if (status.contains(ConnectivityResult.none)) {
//       isInternet = false;
//       'no Internet'.logD;
//       setState(() {});
//       return false;
//     }
//     'Internet'.logD;
//     // try {
//     //   await RemoteConfigService.instance.init();
//     //   loadAds();
//     // } catch (_) {}

//     isInternet = true; // FIXED ✔️
//     setState(() {});
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isInternet
//           ? Stack(
//         children: [
//           Positioned.fill(
//             child: Container(
//               height: context.height,
//               width: context.width,
//               color: Color(0xFF00002D),
//               // decoration: BoxDecoration(
//               //   image: DecorationImage(
//               //     image: Assets.splash.splashBg.provider(),
//               //     fit: BoxFit.cover,
//               //   ),
//               // ),
//               alignment: Alignment.center,
//               child: Assets.splash.splash.image(height: AppSize.sp264, width: AppSize.sp264),
//             ),
//           ),
//           Positioned(
//             bottom: AppSize.w20,
//             left: AppSize.w0,
//             right: AppSize.w0,
//             child: SafeArea(
//               top: false,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: AppSize.w30),
//                     child: LinearProgressIndicator(
//                       color: context.themeColors.primaryGradient2,
//                       backgroundColor: context.themeColors.secondaryGradient3
//                     ),
//                   ),
//                   SizedBox(height: AppSize.h10),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       )
//           : Padding(
//         padding: EdgeInsets.symmetric(horizontal: AppSize.w20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(AppSize.r20)),
//                 color: context.themeColors.blueGradient2,
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(AppSize.r50),
//                 child: Icon(Icons.wifi_off_sharp, color: context.themeColors.primaryGradient1, size: AppSize.h100),
//               ),
//             ),
//             SizedBox(height: AppSize.h20),
//             Text('Connect the internet', style: context.textTheme.bodyLarge),
//             SizedBox(height: AppSize.h20),
//             AppButton(
//               text: 'Retry',
//               onPressed: () {
//                 checkInternet();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
