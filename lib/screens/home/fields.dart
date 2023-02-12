import 'package:flutter/material.dart';

enum FieldType { number, decimal, multiline, text, radio, checkbox, submit }

class FieldConfig<T> {
  final FieldType type;
  final String name;
  T? value;
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
      case FieldType.decimal:
        return TextInputType.number;
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
        "mainFloorLength",
        0,
        length("Main floor length"),
        "Enter the length in $lengthUnit of the main floor. The living area does not include garage, porches or decks."),
    FieldConfig<double>(
        FieldType.decimal,
        "mainFloorBreadth",
        0,
        length("Main floor breadth"),
        "Enter the breadth in $lengthUnit of the main floor. The living area does not include garage, porches or decks."),
    FieldConfig<double>(
        FieldType.radio,
        "ceilingHeight",
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
        "numberOfFloors",
        null,
        "Number of floors",
        "Enter the number of floors or the number of storeys the building has excluding the main ground floor."),
    FieldConfig<int>(
        FieldType.number,
        "numberOfKitchens",
        null,
        "Number of kitchens",
        "Enter the number of kitchens the house will contain."),
    FieldConfig<int>(
        FieldType.number,
        "numberOfStandaloneToilets",
        null,
        "Number of standalone toilets",
        "Enter the number of toilets without bathroom elements inside."),
    FieldConfig<int>(
        FieldType.number,
        "numberOfFullBathrooms",
        null,
        "Number of floors",
        "A full bathroom will have a tub/shower, sink and toilet."),
    FieldConfig<int>(FieldType.number, "numberOfRooms", null, "Number of rooms",
        "Enter the number of rooms in the house."),
    FieldConfig(FieldType.submit, "done", false, "Submit")
  ];
}
