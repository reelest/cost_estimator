import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';

class IntroScreenDefaultState extends State<IntroScreen> {
  List<ContentConfig> listContentConfig = [];
  @override
  void initState() {
    super.initState();
    const TextStyle headerStyles = TextStyle(
        color: Colors.black87, fontSize: 30, fontWeight: FontWeight.bold);
    const TextStyle descriptionStyles = TextStyle(
        color: Colors.black45, fontSize: 18, fontWeight: FontWeight.normal);

    listContentConfig.add(
      const ContentConfig(
        title: "GET BUILDING COSTS",
        styleTitle: headerStyles,
        textOverFlowTitle: null,
        styleDescription: descriptionStyles,
        description:
            "Get accurate estimation of the resources needed to complete your project",
        pathImage: "assets/images/budget_and_finance.jpg",
        foregroundImageFit: BoxFit.cover,
        backgroundColor: Color(0xFFFFFFFF),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "MAKE YOUR PLANS WITH INSIGHTS",
        styleTitle: headerStyles,
        styleDescription: descriptionStyles,
        description: "Use insights gained to plan correctly and reduce costs",
        pathImage: "assets/images/save_money_piggy.jpg",
        backgroundColor: Color(0xFFFFFFFF),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "SPEED UP THE BUILDING PROCESS",
        styleTitle: headerStyles,
        styleDescription: descriptionStyles,
        description: "Spend less time designing and begin work faster",
        pathImage: "assets/images/work_icon.jpg",
        backgroundColor: Color(0xFFFFFFFF),
      ),
    );
  }

  _onDonePress() {
    Navigator.of(context).pushNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).primaryColor.withAlpha(64)),
      overlayColor: MaterialStateProperty.all<Color>(
          Theme.of(context).primaryColor.withAlpha(64)),
    );

    return IntroSlider(
        key: UniqueKey(),
        listContentConfig: listContentConfig,
        onDonePress: _onDonePress,
        indicatorConfig: IndicatorConfig(
            colorIndicator: Theme.of(context).primaryColor,
            typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition),
        skipButtonStyle: buttonStyle,
        nextButtonStyle: buttonStyle,
        doneButtonStyle: buttonStyle,
        renderSkipBtn: const Icon(Icons.skip_next_outlined),
        renderNextBtn: const Icon(Icons.navigate_next));
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<IntroScreen> createState() => IntroScreenDefaultState();
}
