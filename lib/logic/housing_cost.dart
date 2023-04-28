import 'dart:convert';

import 'package:cost_estimator/logic/price_list.dart';
import 'package:http/http.dart' as http;

const PriceList defaultPriceList = PriceList();
const apiEndpoint = 'https://cost-estimator-backend.onrender.com';
// const apiEndpoint = 'http://localhost:5000';
const outputHeaders = [
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
];

enum CostVariable {
  mainFloorLengthInFt,
  mainFloorBreadthInFt,
  ceilingHeightInFt,
  numberOfFloors,
  numberOfKitchens,
  numberOfStandaloneToilets,
  numberOfFullBathrooms,
  numberOfRooms,
  done
}

typedef CostInfoMap = Map<CostVariable, double>;

class CostInfo {
  final double mainFloorLengthInFt;
  final double mainFloorBreadthInFt;
  final double ceilingHeightInFt;
  final double numberOfFloors;
  final double numberOfKitchens;
  final double numberOfStandaloneToilets;
  final double numberOfFullBathrooms;
  final double numberOfRooms;
  final PriceList priceList;
  late final Future<void> estimatesReady;
  dynamic _data;
  CostInfo._({
    required this.mainFloorLengthInFt,
    required this.mainFloorBreadthInFt,
    required this.ceilingHeightInFt,
    required this.numberOfFloors,
    required this.numberOfKitchens,
    required this.numberOfStandaloneToilets,
    required this.numberOfFullBathrooms,
    required this.numberOfRooms,
    required this.priceList,
  }) {
    estimatesReady = _calculate();
  }

  static CostInfo from(CostInfoMap data,
          [PriceList priceList = defaultPriceList]) =>
      CostInfo._(
          mainFloorLengthInFt: data[CostVariable.mainFloorLengthInFt]!,
          mainFloorBreadthInFt: data[CostVariable.mainFloorBreadthInFt]!,
          ceilingHeightInFt: data[CostVariable.ceilingHeightInFt]!,
          numberOfFloors: 1 + data[CostVariable.numberOfFloors]!,
          numberOfKitchens: data[CostVariable.numberOfKitchens]!,
          numberOfStandaloneToilets:
              data[CostVariable.numberOfStandaloneToilets]!,
          numberOfFullBathrooms: data[CostVariable.numberOfFullBathrooms]!,
          numberOfRooms: data[CostVariable.numberOfRooms]!,
          priceList: priceList);

  Future<void> _calculate() async {
    var input = <double>[
      mainFloorLengthInFt,
      mainFloorBreadthInFt,
      ceilingHeightInFt,
      numberOfFloors,
      numberOfKitchens,
      numberOfStandaloneToilets,
      numberOfFullBathrooms,
      numberOfRooms,
      priceList.bagOfCement,
      priceList.tripOfSand,
      priceList.waterInLiters,
      priceList.doorD1,
      priceList.doorD2,
      priceList.doorD3,
      priceList.windowW1,
      priceList.windowW2,
      priceList.tilesPerM2,
      priceList.graniteInTonnes,
      priceList.steelPerM3,
      priceList.costOfRoofHalfPlot
    ];
    final res = await http.post(
      Uri.parse(apiEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(input),
    );
    _data = json.decode(res.body);
  }

  double _getResponse(String name) {
    if (_data == null) {
      throw StateError("Request is yet to be completed");
    }
    return _data[outputHeaders.indexOf(name)];
  }

  double estimateBlocksNeeded() => _getResponse("estimatedBlocksNeeded");
  double estimateCementBagsNeeded() =>
      _getResponse("estimatedCementBagsNeeded");
  double estimateConcreteNeeded() => _getResponse("estimatedConcreteNeeded");
  double estimateCost() => _getResponse("estimatedCost");
  double estimateCostOfRoofing() => _getResponse("estimatedCostOfRoofing");
  double estimateNumDoors() => _getResponse("estimatedNumDoors");
  double estimateNumDoorsD1() => _getResponse("estimatedNumDoorsD1");
  double estimateNumDoorsD2() => _getResponse("estimatedNumDoorsD2");
  double estimateNumDoorsD3() => _getResponse("estimatedNumDoorsD3");
  double estimateNumWindows() => _getResponse("estimatedNumWindows");
  double estimateNumWindowsW1() => _getResponse("estimatedNumWindowsW1");
  double estimateNumWindowsW2() => _getResponse("estimatedNumWindowsW2");
  double estimatePricePerConcreteInM3() =>
      _getResponse("estimatedPricePerConcreteInM3");
  double estimateSandInTonnesNeeded() =>
      _getResponse("estimatedSandInTonnesNeeded");
  double estimateVolumeOfSlabNeeded() =>
      _getResponse("estimatedVolumeOfSlabNeeded");
  double estimateTripsOfSandsNeeded() =>
      _getResponse("estimatedTripsOfSandsNeeded");
  double estimateSteelNeeded() => _getResponse("estimatedSteelNeeded");
  double debug() {
    final cementBagsNeeded = estimateCementBagsNeeded();

    final numDoors = estimateNumDoors();
    final numWindows = estimateNumWindows();
    final tripsOfSandsNeeded = estimateTripsOfSandsNeeded();
    final sandInTonnesNeeded = estimateSandInTonnesNeeded();
    final blocksNeeded = estimateBlocksNeeded();
    final pricePerConcreteInM3 = estimatePricePerConcreteInM3();
    final concreteNeeded = estimateConcreteNeeded();
    final volumeOfSlabNeeded = estimateVolumeOfSlabNeeded();
    final steelNeeded = estimateSteelNeeded();
    // final tilingNeeded = estimateTilingNeeded();
    final numWindowsW1 = estimateNumWindowsW1();
    final numWindowsW2 = estimateNumWindowsW2();
    final numDoorsD1 = estimateNumDoorsD1();
    final numDoorsD2 = estimateNumDoorsD2();
    final numDoorsD3 = estimateNumDoorsD3();
    final costOfRoofing = estimateCostOfRoofing();

    //! Add debug point here
    return cementBagsNeeded +
        numDoors +
        numWindows +
        tripsOfSandsNeeded +
        sandInTonnesNeeded +
        pricePerConcreteInM3 +
        concreteNeeded +
        volumeOfSlabNeeded +
        steelNeeded +
        // tilingNeeded +
        blocksNeeded +
        numWindowsW1 +
        numWindowsW2 +
        numDoorsD1 +
        numDoorsD2 +
        numDoorsD3 +
        costOfRoofing;
  }
}

double getHousingCost(CostInfoMap rawData) {
  return CostInfo.from(rawData).estimateCost();
}
