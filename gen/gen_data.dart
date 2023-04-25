import "dart:io";
import "dart:math";
import './housing_cost.dart';
import 'package:cost_estimator/logic/price_list.dart';

final _random = Random(1);
const List<double> min = [
  25,
  25,
  9,
  1,
  0,
  0,
  0,
  0,
  4100,
  28000,
  5.0,
  15000,
  11000,
  6000,
  35000,
  25000,
  5500,
  9000 /*cost*/ + 7000 /*transportation*/,
  1.5 /*convert to tonnes*/ * 170000,
  800000
];
const List<double> max = [
  525,
  525,
  16,
  10,
  10,
  10,
  10,
  10,
  9000,
  56000,
  10.0,
  30000,
  22000,
  12000,
  70000,
  50000,
  7500,
  18000 /*cost*/ + 7000 /*transportation*/,
  4.5 /*convert to tonnes*/ * 170000,
  1800000
];
void main() {
  stdout.write("Generating data....    ");

  IOSink file = File("./data.csv").openWrite(mode: FileMode.write);
  writeHeader(file);

  List<double> columns = List<double>.filled(37, 0);
  for (var i = 0; i < 1000; i++) {
    for (var j = 0; j < 20; j++) {
      columns[j] = pick(min[j], max[j]);
    }
    stdout.write('\b\b\b\b${(1 + i).toString().padLeft(4)}');
    columns.setAll(20, costMapToOutput(inputToCostMap(columns)));
    writeLine(file, columns);
  }
  file.close();
  file.done.then((value) => stdout.write('\nDone'));
}

void writeHeader(IOSink file) {
  file.writeln([
    //Input
    "mainFloorLengthInFt",
    "mainFloorBreadthInFt",
    "ceilingHeightInFt",
    "numberOfFloors",
    "numberOfKitchens",
    "numberOfStandaloneToilets",
    "numberOfFullBathrooms",
    "numberOfRooms",
    "priceOfBagOfCement",
    "priceOfTripOfSand",
    "priceOfWaterInLiters",
    "priceOfDoorD1",
    "priceOfDoorD2",
    "priceOfDoorD3",
    "priceOfWindowW1",
    "priceOfWindowW2",
    "priceOfTilesPerM2",
    "priceOfGraniteInTonnes",
    "priceOfSteelPerM3",
    "priceOfCostOfRoofHalfPlot",

    //Output
    "estimatedBlocksNeeded",
    "estimatedCementBagsNeeded",
    "estimatedConcreteNeeded",
    "estimatedCost",
    "estimatedCostOfRoofing",
    "estimatedNumDoors",
    "estimatedNumDoorsD1",
    "estimatedNumDoorsD2",
    "estimatedNumDoorsD3",
    "estimatedNumWindows",
    "estimatedNumWindowsW1",
    "estimatedNumWindowsW2",
    "estimatedPricePerConcreteInM3",
    "estimatedSandInTonnesNeeded",
    "estimatedVolumeOfSlabNeeded",
    "estimatedTripsOfSandsNeeded",
    "estimatedSteelNeeded"
  ].join(","));
}

void writeLine(IOSink file, List<double> columns) {
  file.writeln(columns.map((e) => e.toStringAsFixed(2)).join(","));
}

double pick(double min, double max) {
  return (min + _random.nextDouble() * (max - min));
}

CostInfo inputToCostMap(List<double> data) {
  return CostInfo.from(
      {
        CostVariable.mainFloorLengthInFt: data[0],
        CostVariable.mainFloorBreadthInFt: data[1],
        CostVariable.ceilingHeightInFt: data[2],
        CostVariable.numberOfFloors: data[3],
        CostVariable.numberOfKitchens: data[4],
        CostVariable.numberOfStandaloneToilets: data[5],
        CostVariable.numberOfFullBathrooms: data[6],
        CostVariable.numberOfRooms: data[7],
      },
      PriceList(
        currency: "N",
        bagOfCement: data[8],
        tripOfSand: data[9],
        waterInLiters: data[10],
        doorD1: data[11],
        doorD2: data[12],
        doorD3: data[13],
        windowW1: data[14],
        windowW2: data[15],
        tilesPerM2: data[16],
        graniteInTonnes: data[17],
        steelPerM3: data[18],
        costOfRoofHalfPlot: data[19],
      ));
}

List<double> costMapToOutput(CostInfo data) {
  return [
    data.estimateBlocksNeeded(),
    data.estimateCementBagsNeeded(),
    data.estimateConcreteNeeded(),
    data.estimateCost(),
    data.estimateCostOfRoofing(),
    data.estimateNumDoors(),
    data.estimateNumDoorsD1(),
    data.estimateNumDoorsD2(),
    data.estimateNumDoorsD3(),
    data.estimateNumWindows(),
    data.estimateNumWindowsW1(),
    data.estimateNumWindowsW2(),
    data.estimatePricePerConcreteInM3(),
    data.estimateSandInTonnesNeeded(),
    data.estimateVolumeOfSlabNeeded(),
    data.estimateTripsOfSandsNeeded(),
    data.estimateSteelNeeded()
  ];
}
