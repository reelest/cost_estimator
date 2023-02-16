import 'package:cost_estimator/logic/housing_cost.dart';
import 'package:flutter/material.dart';

enum FieldType { number, decimal, multiline, text, radio, checkbox, submit }

class FieldConfig<T> {
  static const fieldValueMax = "--max";
  static const fieldValueMin = "--min";

  final FieldType type;
  final CostVariable name;
  T value;
  final String label;
  final String hint;
  final Map<String, T>? options;
  FieldConfig(this.type, this.name, this.value, this.label,
      [this.hint = "", this.options]);

  TextInputType getTextInputType() {
    switch (type) {
      case FieldType.text:
        return TextInputType.text;
      case FieldType.number:
        return TextInputType.number;
      case FieldType.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case FieldType.multiline:
        return TextInputType.multiline;
      case FieldType.radio:
      case FieldType.checkbox:
      case FieldType.submit:
      //Do nothing
    }
    return TextInputType.text;
  }
}

List<FieldConfig> defaultFields({lengthUnit = "ft"}) {
  String length(text) {
    return '$text (in $lengthUnit)';
  }

  return [
    FieldConfig<double>(
        FieldType.decimal,
        CostVariable.mainFloorLengthInFt,
        0,
        length("Main floor length"),
        "Enter the length in $lengthUnit of the main floor. The living area does not include garage, porches or decks."),
    FieldConfig<double>(
        FieldType.decimal,
        CostVariable.mainFloorBreadthInFt,
        0,
        length("Main floor breadth"),
        "Enter the breadth in $lengthUnit of the main floor. The living area does not include garage, porches or decks."),
    FieldConfig<double>(
        FieldType.radio,
        CostVariable.ceilingHeightInFt,
        11,
        length("Ceiling height"),
        "Select the height of the main floor of the building.", {
      "8ft": 8,
      "9ft": 9,
      "10ft": 10,
      "11ft": 11,
      "12ft": 12,
    }),
    FieldConfig<int>(
        FieldType.number,
        CostVariable.numberOfFloors,
        0,
        "Number of floors",
        "Enter the number of floors or the number of storeys the building has excluding the main ground floor."),
    FieldConfig<int>(
        FieldType.number,
        CostVariable.numberOfKitchens,
        0,
        "Number of kitchens",
        "Enter the number of kitchens the house will contain."),
    FieldConfig<int>(
        FieldType.number,
        CostVariable.numberOfStandaloneToilets,
        0,
        "Number of standalone toilets",
        "Enter the number of toilets without bathroom elements inside."),
    FieldConfig<int>(
        FieldType.number,
        CostVariable.numberOfFullBathrooms,
        0,
        "Number of floors",
        "A full bathroom will have a tub/shower, sink and toilet."),
    FieldConfig<int>(FieldType.number, CostVariable.numberOfRooms, 0,
        "Number of rooms", "Enter the number of rooms in the house."),
    FieldConfig(FieldType.submit, CostVariable.done, false, "Estimate cost")
  ];
}
