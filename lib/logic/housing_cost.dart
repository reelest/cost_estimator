import 'dart:math';

import 'package:cost_estimator/logic/price_list.dart';

//A way to estimate how much walls are shared between rooms and other enclosed spaces
const double estimatedHousePlanDensity = 0.5;

const double blockWallArea = 0.225 * 0.45;

double tripOfSandInTonnes =
    5 /* Trailer Capacity ie 5 tonne trailer */ * 1.24 /* Overload factor */;

double columnSize = inch2m(9) * inch2m(9);

double beamSize = inch2m(9) * inch2m(12);

// https://structville.com/2017/07/how-to-estimate-the-quantity-of-sand-and-cement-required-for-moulding-blocks.html#:~:text=The%20ideal%20mix%20ratio%20for,1%20bag%20to%2025%20blocks.
const blockFormula = {"tripsOfSand": 11, "bagsOfCement": 86, "blocks": 3000};
const concreteFormula = {
  "tripsOfSand": 1,
  "bagsOfCement": 11,
  "water": 3000,
  "concrete": 1
};

const PriceList defaultPriceList = PriceList();

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
  const CostInfo._(
      {required this.mainFloorLengthInFt,
      required this.mainFloorBreadthInFt,
      required this.ceilingHeightInFt,
      required this.numberOfFloors,
      required this.numberOfKitchens,
      required this.numberOfStandaloneToilets,
      required this.numberOfFullBathrooms,
      required this.numberOfRooms});

  static CostInfo from(CostInfoMap data) => CostInfo._(
      mainFloorLengthInFt: data[CostVariable.mainFloorLengthInFt]!,
      mainFloorBreadthInFt: data[CostVariable.mainFloorBreadthInFt]!,
      ceilingHeightInFt: data[CostVariable.ceilingHeightInFt]!,
      numberOfFloors: 1 + data[CostVariable.numberOfFloors]!,
      numberOfKitchens: data[CostVariable.numberOfKitchens]!,
      numberOfStandaloneToilets: data[CostVariable.numberOfStandaloneToilets]!,
      numberOfFullBathrooms: data[CostVariable.numberOfFullBathrooms]!,
      numberOfRooms: data[CostVariable.numberOfRooms]!);

  double estimateCementBagsNeededForWalls(numBlocks) {
    return (numBlocks / blockFormula["blocks"]) * blockFormula["bagsOfCement"];
  }

  double estimateTripsOfSandNeededForWalls(numBlocks) {
    return (numBlocks / blockFormula["blocks"]) * blockFormula["tripsOfSand"];
  }

  double estimateNumberOfColumns() {
    const estimationFactor = 2;
    return 4 +
        (numberOfRooms +
                numberOfKitchens +
                numberOfFullBathrooms +
                numberOfStandaloneToilets +
                numberOfFloors) *
            estimationFactor;
  }

  double estimateTotalBeamLength() {
    return estimateTotalWallLength();
  }

  // double estimatePricePerConcreteInM3(){
  //   return
  // }

  // double estimateConcreteNeeded() {
  //   const volumeOfConcrete =
  //       estimateNumberOfColumns() * ft2m(ceilingHeightInFt) * columnSize +
  //           estimateTotalBeamLength() * beamSize;
  //   return volumeOfConcrete * estimatePricePerConcreteInM3()
  // }

  double estimateCost([PriceList prices = defaultPriceList]) {
    double numBlocks = estimateBlocksNeeded();

    double costOfBlocksWalls =
        estimateCementBagsNeededForWalls(numBlocks) * prices.bagOfCement +
            estimateTripsOfSandNeededForWalls(numBlocks) * prices.tripOfSand;

    double cost = costOfBlocksWalls;
    return cost;
  }

  double getAverageLength() {
    return 0.5 * (mainFloorLengthInFt + mainFloorBreadthInFt);
  }

  double estimateBlocksNeeded() {
    final wallLength = ft2m(estimateTotalWallLength());
    final hangingWallLength = ft2m(estimateHangingWallLength());
    final ceilingHeightInMeters = ft2m(ceilingHeightInFt);
    final totalWallAreaFoundationToDPC = 0.9 * numberOfFloors * wallLength;
    final totalWallAreaDPCToLintelUnadjusted =
        ceilingHeightInMeters * (wallLength - hangingWallLength);
    final totalAreaOfDoors = estimateTotalAreaOfDoors();
    final totalAreaOfWindows = estimateTotalAreaOfWindows();
    final totalWallAreaDPCToLintel = totalWallAreaDPCToLintelUnadjusted -
        totalAreaOfDoors -
        totalAreaOfWindows;
    final totalWallAreaLintelToOverhead =
        ceilingHeightInMeters * 0.33 * wallLength;

    final totalWallArea = totalWallAreaFoundationToDPC +
        totalWallAreaDPCToLintel +
        totalWallAreaLintelToOverhead;
    return max(0, totalWallArea / blockWallArea);
  }

  double estimateHangingWallLength() {
    return getAverageLength();
  }

  double estimateTotalAreaOfWindows() {
    return estimateNumWindowsW1() * 1.2 * 1.2 +
        estimateNumWindowsW2() * 0.6 * 0.6;
  }

  double estimateNumWindowsW1() {
    return (2 + numberOfRooms * 2.5) * getAverageLength() / 40;
  }

  double estimateNumWindowsW2() {
    return numberOfStandaloneToilets + numberOfFullBathrooms;
  }

  double estimateTotalAreaOfDoors() {
    var doorHeight = 2.1;
    return estimateNumDoorsD1() * doorHeight * 1.2 +
        estimateNumDoorsD2() * doorHeight * 0.9 +
        estimateNumDoorsD3() * doorHeight * 0.7;
  }

  double estimateNumDoorsD1() {
    return numberOfFloors;
  }

  double estimateNumDoorsD2() {
    const estimationFactor = 1.5;
    return estimationFactor * (numberOfRooms + 1);
  }

  double estimateNumDoorsD3() {
    return numberOfFullBathrooms + numberOfStandaloneToilets;
  }

  double estimateTotalWallLength() {
    final avgWallLength = getAverageLength();

    return (
        //Exterior walls on each floor
        (avgWallLength * 4 * numberOfFloors) +

            //Estimate bathroom length
            estimateBathroomLength() +
            //Estimate room length
            estimateRoomLength() +
            estimateOtherWallsLength() +
            //Estimate kitchen length
            estimateKitchenLength() +
            //Estimate toilet length
            estimateToiletLength());
  }

  double estimateOtherWallsLength() {
    const estimationFactor = 0.4;
    return estimationFactor *
        getAverageLength() *
        numberOfRooms *
        numberOfFloors;
  }

  double estimateBathroomLength() {
    const estimationFactor = 0.95;
    return numberOfFullBathrooms > 0
        ? (numberOfFullBathrooms /
                (estimatedHousePlanDensity * numberOfRooms +
                    numberOfFullBathrooms) *
                estimationFactor) *
            getAverageLength() *
            numberOfFloors
        : 0;
  }

  double estimateToiletLength() {
    const estimationFactor = 0.75;
    return numberOfStandaloneToilets > 0
        ? (numberOfStandaloneToilets /
                (estimatedHousePlanDensity * numberOfRooms +
                    numberOfStandaloneToilets) *
                estimationFactor) *
            getAverageLength() *
            numberOfFloors
        : 0;
  }

  double estimateKitchenLength() {
    const estimationFactor = 0.9;
    return numberOfKitchens > 0
        ? (numberOfKitchens /
                (estimatedHousePlanDensity * numberOfRooms + numberOfKitchens) *
                estimationFactor) *
            getAverageLength() *
            numberOfFloors
        : 0;
  }

  double estimateRoomLength() {
    const estimationFactor = 0.7;
    return numberOfRooms *
        estimationFactor *
        getAverageLength() *
        numberOfFloors;
  }
}

double m2ft(m) {
  return m * 3.28;
}

double ft2m(ft) {
  return ft / 3.28;
}

double ft2inch(ft) {
  return ft * 12;
}

double inch2m(inch) {
  return inch * 0.0254;
}

double getHousingCost(CostInfoMap rawData) {
  return CostInfo.from(rawData).estimateCost();
}
