import 'dart:math';

import 'package:cost_estimator/logic/formulas.dart';
import 'package:cost_estimator/logic/price_list.dart';

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
  final PriceList priceList;
  const CostInfo._(
      {required this.mainFloorLengthInFt,
      required this.mainFloorBreadthInFt,
      required this.ceilingHeightInFt,
      required this.numberOfFloors,
      required this.numberOfKitchens,
      required this.numberOfStandaloneToilets,
      required this.numberOfFullBathrooms,
      required this.numberOfRooms,
      required this.priceList});

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

  double estimateCost() {
    double numBlocks = estimateBlocksNeeded();

    double costOfBlocksForWalls =
        estimateCementBagsNeededForWalls(numBlocks) * priceList.bagOfCement +
            estimateTripsOfSandNeededForWalls(numBlocks) * priceList.tripOfSand;

    double volumeOfConcrete = estimateConcreteNeeded();
    double costOfConcrete = volumeOfConcrete * estimatePricePerConcreteInM3();

    double costOfSteel = priceList.steelPerM3 * estimateSteelNeeded();

    double costOfTiles = priceList.tilesPerM2 * estimateTilingNeeded();

    double costOfRoofing = estimateCostOfRoofing();

    return costOfBlocksForWalls +
        costOfConcrete +
        costOfSteel +
        costOfTiles +
        costOfRoofing;
  }

  double estimateCostOfRoofing() {
    return getMeanLengthOfSide() / 71 * priceList.costOfRoofHalfPlot;
  }

  double debug() {
    final cementBagsNeeded = estimateCementBagsNeeded();

    final numDoors = estimateNumDoors();
    final numWindows = estimateNumWindows();
    final tripsOfSandsNeeded = estimateTripsOfSandsNeeded();
    final sandInTonnesNeeded = estimateSandInTonnesNeeded();
    final blocksNeeded = estimateBlocksNeeded();
    final cementBagsNeededForWalls =
        estimateCementBagsNeededForWalls(blocksNeeded);
    final tripsOfSandNeededForWalls =
        estimateTripsOfSandNeededForWalls(blocksNeeded);
    final numberOfColumns = estimateNumberOfColumns();
    final totalBeamLength = estimateTotalBeamLength();
    final pricePerConcreteInM3 = estimatePricePerConcreteInM3();
    final concreteNeeded = estimateConcreteNeeded();
    final volumeOfSlabNeeded = estimateVolumeOfSlabNeeded();
    final steelNeeded = estimateSteelNeeded();
    final tilingNeeded = estimateTilingNeeded();
    final hangingWallLength = estimateHangingWallLength();
    final totalAreaOfWindows = estimateTotalAreaOfWindows();
    final numWindowsW1 = estimateNumWindowsW1();
    final numWindowsW2 = estimateNumWindowsW2();
    final totalAreaOfDoors = estimateTotalAreaOfDoors();
    final numDoorsD1 = estimateNumDoorsD1();
    final numDoorsD2 = estimateNumDoorsD2();
    final numDoorsD3 = estimateNumDoorsD3();
    final totalWallLength = estimateTotalWallLength();
    final otherWallsLength = estimateOtherWallsLength();
    final bathroomLength = estimateBathroomLength();
    final toiletLength = estimateToiletLength();
    final costOfRoofing = estimateCostOfRoofing();
    final kitchenLength = estimateKitchenLength();
    final roomLength = estimateRoomLength();

    //! Add debug point here
    return cementBagsNeeded +
        numDoors +
        numWindows +
        tripsOfSandsNeeded +
        sandInTonnesNeeded +
        cementBagsNeededForWalls +
        tripsOfSandNeededForWalls +
        numberOfColumns +
        totalBeamLength +
        pricePerConcreteInM3 +
        concreteNeeded +
        volumeOfSlabNeeded +
        steelNeeded +
        tilingNeeded +
        blocksNeeded +
        hangingWallLength +
        totalAreaOfWindows +
        numWindowsW1 +
        numWindowsW2 +
        totalAreaOfDoors +
        numDoorsD1 +
        numDoorsD2 +
        numDoorsD3 +
        totalWallLength +
        otherWallsLength +
        bathroomLength +
        toiletLength +
        costOfRoofing +
        kitchenLength +
        roomLength;
  }

  double getMeanLengthOfSide() {
    return sqrt(mainFloorLengthInFt * mainFloorBreadthInFt);
  }

  double estimateCementBagsNeeded() {
    return estimateCementBagsNeededForWalls(estimateBlocksNeeded()) +
        (estimateConcreteNeeded() / concreteFormula["concreteInM3"]!) *
            concreteFormula["bagsOfCement"]!;
  }

  double estimateNumDoors() {
    return estimateNumDoorsD1() + estimateNumDoorsD2() + estimateNumDoorsD3();
  }

  double estimateNumWindows() {
    return estimateNumWindowsW1() + estimateNumWindowsW2();
  }

  double estimateTripsOfSandsNeeded() {
    return estimateTripsOfSandNeededForWalls(estimateBlocksNeeded()) +
        (estimateConcreteNeeded() / concreteFormula["concreteInM3"]!) *
            concreteFormula["tripsOfSand"]!;
  }

  double estimateSandInTonnesNeeded() {
    return estimateTripsOfSandsNeeded() * tripOfSandInTonnes;
  }

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

  double estimatePricePerConcreteInM3() {
    return (concreteFormula["tripsOfSand"]! * priceList.tripOfSand +
            concreteFormula["waterInLiters"]! * priceList.waterInLiters +
            concreteFormula["graniteInTonnes"]! * priceList.graniteInTonnes +
            concreteFormula["bagsOfCement"]! * priceList.bagOfCement) /
        concreteFormula["concreteInM3"]!;
  }

  double estimateConcreteNeeded() {
    return estimateNumberOfColumns() * ft2m(ceilingHeightInFt) * columnSize +
        estimateTotalBeamLength() * beamSize +
        estimateVolumeOfSlabNeeded();
  }

  double estimateVolumeOfSlabNeeded() {
    return ft2m(mainFloorLengthInFt) *
        ft2m(mainFloorBreadthInFt) *
        concreteSlabThickness;
  }

  double estimateSteelNeeded() {
    const estimationFactor = 0.01;
    return estimationFactor * estimateConcreteNeeded();
  }

  double estimateTilingNeeded() {
    const estimationFactor = 0.05;
    return (1 - (estimationFactor * numberOfRooms)) *
        ft2m(mainFloorLengthInFt) *
        ft2m(mainFloorBreadthInFt);
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
    return getMeanLengthOfSide();
  }

  double estimateTotalAreaOfWindows() {
    return estimateNumWindowsW1() * 1.2 * 1.2 +
        estimateNumWindowsW2() * 0.6 * 0.6;
  }

  double estimateNumWindowsW1() {
    return (2 + numberOfRooms * 2.5) * getMeanLengthOfSide() / 40;
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
    return estimationFactor *
        (numberOfRooms + max(2, getMeanLengthOfSide() / 30));
  }

  double estimateNumDoorsD3() {
    return numberOfFullBathrooms + numberOfStandaloneToilets;
  }

  double estimateTotalWallLength() {
    final exteriorWallLength =
        2 * numberOfFloors * (mainFloorLengthInFt + mainFloorBreadthInFt);

    return (
        //Exterior walls on each floor
        exteriorWallLength +

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
        getMeanLengthOfSide() *
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
            getMeanLengthOfSide() *
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
            getMeanLengthOfSide() *
            numberOfFloors
        : 0;
  }

  double estimateKitchenLength() {
    const estimationFactor = 0.9;
    return numberOfKitchens > 0
        ? (numberOfKitchens /
                (estimatedHousePlanDensity * numberOfRooms + numberOfKitchens) *
                estimationFactor) *
            getMeanLengthOfSide() *
            numberOfFloors
        : 0;
  }

  double estimateRoomLength() {
    const estimationFactor = 0.7;
    return numberOfRooms *
        estimationFactor *
        getMeanLengthOfSide() *
        numberOfFloors;
  }
}

double getHousingCost(CostInfoMap rawData) {
  return CostInfo.from(rawData).estimateCost();
}
