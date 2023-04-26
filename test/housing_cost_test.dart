import 'package:cost_estimator/logic/formulas.dart';
import 'package:flutter_test/flutter_test.dart';
import '../gen/housing_cost.dart';

void main() {
  //Tests from https://structville.com/2017/07/how-to-calculate-the-number-of-blocks-required-to-complete-a-3-bedroom-flat.html
  test("Estimates length of walls", () {
    CostInfo info = CostInfo.from({
      CostVariable.ceilingHeightInFt: 12.0,
      CostVariable.mainFloorBreadthInFt: 9.700,
      CostVariable.mainFloorLengthInFt: 13.70,
      CostVariable.numberOfFloors: 0,
      CostVariable.numberOfFullBathrooms: 3,
      CostVariable.numberOfKitchens: 1,
      CostVariable.numberOfRooms: 3,
      CostVariable.numberOfStandaloneToilets: 1,
    });
    expect(info.estimateTotalWallLength(), closeTo(100, 7));
  });
  test("Estimates blocks needed", () {
    CostInfo info = CostInfo.from({
      CostVariable.ceilingHeightInFt: m2ft(2.1),
      CostVariable.mainFloorBreadthInFt: m2ft(9.700),
      CostVariable.mainFloorLengthInFt: m2ft(13.70),
      CostVariable.numberOfFloors: 0,
      CostVariable.numberOfFullBathrooms: 3,
      CostVariable.numberOfKitchens: 1,
      CostVariable.numberOfRooms: 3,
      CostVariable.numberOfStandaloneToilets: 1,
    });
    expect(info.estimateBlocksNeeded(), closeTo(3032, 70));
  });

  test("Estimates length of bathroom walls", () {
    CostInfo info = CostInfo.from({
      CostVariable.ceilingHeightInFt: 12.0,
      CostVariable.mainFloorBreadthInFt: 9.700,
      CostVariable.mainFloorLengthInFt: 13.70,
      CostVariable.numberOfFloors: 0,
      CostVariable.numberOfFullBathrooms: 3,
      CostVariable.numberOfKitchens: 1,
      CostVariable.numberOfRooms: 0,
      CostVariable.numberOfStandaloneToilets: 1,
    });
    expect(info.estimateBathroomLength(), closeTo(12, 1));
  });

  test("Estimates length of room walls", () {
    CostInfo info = CostInfo.from({
      CostVariable.ceilingHeightInFt: 12.0,
      CostVariable.mainFloorBreadthInFt: 9.700,
      CostVariable.mainFloorLengthInFt: 13.70,
      CostVariable.numberOfFloors: 0,
      CostVariable.numberOfFullBathrooms: 3,
      CostVariable.numberOfKitchens: 1,
      CostVariable.numberOfRooms: 3,
      CostVariable.numberOfStandaloneToilets: 1,
    });
    expect(info.estimateRoomLength(), closeTo(22, 5));
  });

  // https://www.nairaland.com/4208200/how-many-blocks-it-take
  test("Estimates blocks needed for one bedroom flat", () {
    CostInfo info = CostInfo.from({
      CostVariable.ceilingHeightInFt: m2ft(2.1),
      CostVariable.mainFloorBreadthInFt: 45,
      CostVariable.mainFloorLengthInFt: 45,
      CostVariable.numberOfFloors: 0,
      CostVariable.numberOfFullBathrooms: 1,
      CostVariable.numberOfKitchens: 1,
      CostVariable.numberOfRooms: 1,
      CostVariable.numberOfStandaloneToilets: 0,
    });
    expect(info.estimateBlocksNeeded(), closeTo(/*4146*/ 2700, 100));
  });
}
