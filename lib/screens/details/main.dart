import 'package:cost_estimator/logic/housing_cost.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(description, style: theme.bodyMedium),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
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
      ]),
    );
  }
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    CostInfoMap map = ModalRoute.of(context)?.settings.arguments as CostInfoMap;
    CostInfo info = CostInfo.from(map);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breakdown of Cost"),
      ),
      body: ListView(
        children: [
          Detail(
            description: "The estimated total cost of building is",
            quantity: "N${info.estimateCost().toInt()}",
            unit: "naira",
          ),
        ],
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.title});

  final String title;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}
