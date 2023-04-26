import 'package:cost_estimator/components/format_amount.dart';
import 'package:cost_estimator/components/theme.dart';
import 'package:cost_estimator/logic/housing_cost.dart';
import 'package:cost_estimator/components/hooks.dart';
import 'package:flutter/material.dart';

enum DetailLevel { summary, detailed, extraneous }

class Detail extends StatelessWidget {
  final String description;
  final String quantity;
  final String unit;
  final DetailLevel level;
  const Detail({
    super.key,
    required this.description,
    this.quantity = "",
    this.unit = "",
    this.level = DetailLevel.summary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(description, style: theme.bodyMedium),
        Expanded(
          flex: useMobile(context) ? 0 : 1,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: useMobile(context)
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          quantity,
                          style: (level == DetailLevel.summary
                                  ? theme.headlineLarge
                                  : level == DetailLevel.detailed
                                      ? theme.headlineMedium
                                      : theme.headlineSmall)!
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                        Text(
                          unit,
                          style: theme.bodySmall!.copyWith(
                            color: const Color.fromARGB(255, 252, 2, 98),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class _DetailsScreenState extends State<DetailsScreen> {
  //The various details that will be rendered.
  // On mobile screens, they are rendered in a ListView while on larger screens, they are
  //   rendered on a GridView.
  List<Widget> renderDetails(CostInfo info) {
    return [
      Detail(
        description: "The estimated total cost of building is",
        quantity: formatAmount(info.estimateCost()),
      ),
      Detail(
        description: "The estimated cost of roofing is",
        quantity: formatAmount(info.estimateCostOfRoofing()),
      ),
      Detail(
        description: "The estimated amount of cement blocks needed is",
        quantity: "${info.estimateBlocksNeeded().round()}",
        unit: "blocks",
      ),
      Detail(
        description: "The estimated amount of cement bags needed",
        quantity: "${info.estimateCementBagsNeeded().round()}",
        unit: "bags",
      ),
      Detail(
        description: "The estimated amount of sand needed",
        quantity: "${info.estimateSandInTonnesNeeded().round()}",
        unit: "tonnes",
      ),
      Detail(
        description: "The estimated amount of steel needed",
        quantity: info.estimateSteelNeeded().toStringAsFixed(2),
        unit: "tonnes",
      ),
      Detail(
        description: "The estimated number of doors to be purchased",
        quantity: "${info.estimateNumDoors().round()}",
        unit: "doors",
      ),
      Detail(
        description: "The estimated number of windows to be purchased",
        quantity: "${info.estimateNumWindows().round()}",
        unit: "windows",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    CostInfo info = ModalRoute.of(context)?.settings.arguments as CostInfo;
    info.debug();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Breakdown of Cost"),
        ),
        body: (({padding, children}) => useMobile(context)
            ? ListView(padding: padding, children: children)
            : GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 150,
                    crossAxisSpacing: 16),
                padding: padding,
                children: children))(
          padding: EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: GlobalTheme.getWindowPadding(context)),
          children: renderDetails(info),
        ));
  }
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.title});

  final String title;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}
