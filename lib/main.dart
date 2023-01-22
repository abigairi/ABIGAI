import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_web/pages/homepage.dart';
import 'package:universal_web/pages/onboarding.dart';
import 'package:universal_web/provider/homepageprovider.dart';
import 'package:universal_web/provider/webview.dart';
import 'package:universal_web/utils/colors.dart';
import 'package:universal_web/utils/global_fuction.dart';
import 'package:universal_web/utils/responsible_file.dart';

import 'utils/constants.dart';

late bool isIntro = false;
loadSharePre() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  isIntro = (prefs.getBool('intro') ?? false);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();
  await Permission.location.request();
  await Permission.microphone.request();

//serviceEnabled = await location.serviceEnabled();
//if (!serviceEnabled!) {
//  serviceEnabled = await location.requestService();
//  if (!serviceEnabled!) {
//    debugPrint(serviceEnabled.toString()+"Demo1"
//    );
//    return;
//  }
//}
//
//permissionGranted = await location.hasPermission();
//if (permissionGranted == PermissionStatus.denied) {
//  permissionGranted = await location.requestPermission();
//  if (permissionGranted != PermissionStatus.granted) {
//    debugPrint(permissionGranted.toString()+"Demo2");
//
//  }
//}
//
//locationData = await location.getLocation();
//location.onLocationChanged.listen((LocationData currentLocation) {
//  print(currentLocation.toString()+"Loc");
//  // Use current location
//});
//print(locationData.toString()+"Demo3");

  MobileAds.instance.initialize();
  loadSharePre();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  checkInternetConnection();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => HomePageProvider()),
      ChangeNotifierProvider(create: (_) => WebViewProvider()),
    ], child: const MyApp()),
  ); //only myapp
}

// this is testing comment

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(statusBarColor: transparant));
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: introScreenOnOff
              ? isIntro
                  ? "/homePage"
                  : "/onBoardingPage"
              : "/homePage",
          routes: {
            "/homePage": (context) => const HomePage(),
            "/onBoardingPage": (context) => const OnBoardingPage()
          },
        );
      });
    });
  }
}
