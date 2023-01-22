import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_web/ads/banner_ad.dart';
import 'package:universal_web/utils/colors.dart';
import 'package:universal_web/utils/constants.dart';
import 'package:universal_web/utils/responsible_file.dart';
import 'package:universal_web/widget/checkinternet.dart';
import 'package:universal_web/widget/custom_text.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  bool? isIntro;
  int _currentIndex = 0;

  String _connectionStatus = 'ConnectivityResult.none';

  void _onIntroEnd(context) {
    CheckInternet.initConnectivity().then((value) => setState(() {
          _connectionStatus = value;
          debugPrint(_connectionStatus);
        }));
    saveShareInfo("intro", true);
    Navigator.pushNamed(context, "/homePage", arguments: _connectionStatus);
  }

  saveShareInfo(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  PageController pageViewController = PageController();

  int currentPage = 0;
  int totalPage = 3;

  List introImage = [
    assetsPath.toString() + firstIntroImage,
    assetsPath.toString() + secondIntroImage,
    assetsPath.toString() + thirdIntroImage
  ];

  List introTitle = [firstIntroTitle, secondIntroTitle, thirdIntroTitle];

  List introDescription = [
    firstIntroDescription,
    secondIntroDescription,
    thirdIntroDescription
  ];

  @override
  void initState() {
    // TODO: implement initState

    Platform.isAndroid
        ? bannerAdIs
            ? bannerAd.load()
            : debugPrint("Banner Ad Android not loaded")
        : iosBannerAdIs
            ? bannerAd.load()
            : debugPrint("Banner Ad IOS not loaded");
  }

  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: bannerAd);
    final Container adContainer = Container(
      color: white,
      alignment: Alignment.center,
      child: adWidget,
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
    );
    return Scaffold(
      body: Container(
        color: colorAccent,
        child: Column(
          children: <Widget>[
            Expanded(
                child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  _currentIndex = index;
                });
              },
              itemCount: introImage.length,
              scrollDirection: Axis.horizontal,
              controller: pageViewController,
              itemBuilder: (context, index) {
                return Container(
                  color: transparant,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        introImage[index],
                        height: SizeConfig.heightMultiplier * 30,
                      ),
                    ],
                  ),
                );
              },
            )),
            Stack(children: [
              Container(
                color: transparant,
                child: Image.asset(
                  assetsPath + "shape1.png".toString(),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: double.infinity,
                      height: SizeConfig.heightMultiplier * 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            title: introTitle[_currentIndex],
                            size: SizeConfig.heightMultiplier * 3,
                            colors: colorAccent,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier,
                          ),
                          SizedBox(
                            width: SizeConfig.heightMultiplier * 30,
                            child: CustomText(
                              title: introDescription[_currentIndex],
                              size: SizeConfig.heightMultiplier * 1.8,
                              colors: colorAccent,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: InkWell(
                              onTap: () {
                                if (pageViewController.hasClients) {
                                  pageViewController.animateToPage(
                                    currentPage - 1,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: currentPage != 0
                                  ? Image.asset(
                                      assetsPath + "prev.png",
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                            ),
                          ),
                          Expanded(
                            child: DotsIndicator(
                              dotsCount: 3,
                              position: _currentIndex.toDouble(),
                              decorator: DotsDecorator(
                                color: transparant,
                                spacing:
                                    EdgeInsets.all(SizeConfig.widthMultiplier),
                                size: Size.square(SizeConfig.heightMultiplier),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.heightMultiplier),
                                    side: const BorderSide(
                                      color: colorAccent,
                                    )),
                                activeColor: colorAccent,
                                activeSize: Size(SizeConfig.heightMultiplier,
                                    SizeConfig.heightMultiplier),
                                activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.heightMultiplier)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: InkWell(
                              onTap: (() {
                                if (currentPage != 2) {
                                  pageViewController.animateToPage(
                                    currentPage + 1,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  _onIntroEnd(context);
                                }
                              }),
                              child: Image.asset(
                                assetsPath + "next.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                        ],
                      )),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
