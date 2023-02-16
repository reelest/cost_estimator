import 'package:cost_estimator/components/theme.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';

class IntroImage extends StatelessWidget {
  final String src;
  const IntroImage(this.src, {super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
      src,
      width: 250,
      height: 250,
      fit: BoxFit.scaleDown,
    ));
  }
}

class _IntroScreenState extends State<IntroScreen> {
  List<ContentConfig> listContentConfig = [];
  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      const ContentConfig(
        title: "Estimate building costs",
        maxLineTitle: 3,
        styleTitle: GlobalTheme.h1,
        styleDescription: GlobalTheme.description,
        description:
            "Get accurate estimation of the resources needed to complete your project",
        centerWidget: IntroImage("assets/images/budget_and_finance.jpg"),
        backgroundColor: GlobalTheme.splashBackground,
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "Gain insights to budget wisely",
        maxLineTitle: 3,
        styleTitle: GlobalTheme.h1,
        styleDescription: GlobalTheme.description,
        description: "Use insights gained to plan correctly and reduce costs",
        centerWidget: IntroImage("assets/images/save_money_piggy.jpg"),
        backgroundColor: GlobalTheme.splashBackground,
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "Accelerate the time to work",
        maxLineTitle: 3,
        styleTitle: GlobalTheme.h1,
        styleDescription: GlobalTheme.description,
        description: "Spend less time designing and start work faster",
        centerWidget: IntroImage("assets/images/work_icon.jpg"),
        backgroundColor: GlobalTheme.splashBackground,
      ),
    );
  }

  _onDonePress() {
    Navigator.of(context).pushReplacementNamed('/form');
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = GlobalTheme.getIntroButtonStyle(context);

    return IntroSlider(
        key: UniqueKey(),
        listContentConfig: listContentConfig,
        onDonePress: _onDonePress,
        onSkipPress: _onDonePress,
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
  State<IntroScreen> createState() => _IntroScreenState();
}
