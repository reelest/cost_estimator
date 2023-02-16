class PriceList {
  final String currency;
  final double bagOfCement;
  final double tripOfSand;
  final double doorD1;
  final double doorD2;
  final double doorD3;
  final double windowW1;
  final double windowW2;
  final double waterInM3;
  final double tilesPerM2;
  final double graniteInKG;
  final double steelPerM3;

  const PriceList({
    this.currency = "N",
    this.bagOfCement = 5.0,
    this.tripOfSand = 1.0,
    this.waterInM3 = 1.0,
    this.doorD1 = 1.0,
    this.doorD2 = 1.0,
    this.doorD3 = 1.0,
    this.windowW1 = 1.0,
    this.windowW2 = 1.0,
    this.tilesPerM2 = 1.0,
    this.graniteInKG = 1.0,
    this.steelPerM3 = 1.0,
  });
}
