enum MeasurementUnit {
  // Volume - Metric
  milliliters('ml', 'Milliliters'),
  liters('L', 'Liters'),
  
  // Volume - Imperial
  teaspoons('tsp', 'Teaspoons'),
  tablespoons('tbsp', 'Tablespoons'),
  cups('cups', 'Cups'),
  pints('pt', 'Pints'),
  quarts('qt', 'Quarts'),
  gallons('gal', 'Gallons'),
  fluid_ounces('fl oz', 'Fluid Ounces'),
  
  // Weight - Metric
  grams('g', 'Grams'),
  kilograms('kg', 'Kilograms'),
  milligrams('mg', 'Milligrams'),
  
  // Weight - Imperial
  ounces('oz', 'Ounces'),
  pounds('lb', 'Pounds'),
  
  // Count/Pieces
  pieces('pcs', 'Pieces'),
  items('items', 'Items'),
  cloves('cloves', 'Cloves'),
  slices('slices', 'Slices'),
  
  // Special measurements
  pinch('pinch', 'Pinch'),
  dash('dash', 'Dash'),
  handful('handful', 'Handful'),
  bunch('bunch', 'Bunch'),
  
  // No unit
  none('', 'No unit');

  const MeasurementUnit(this.symbol, this.displayName);
  
  final String symbol;
  final String displayName;

  static MeasurementUnit fromString(String value) {
    return MeasurementUnit.values.firstWhere(
      (unit) => unit.name == value,
      orElse: () => MeasurementUnit.none,
    );
  }

  String toJson() => name;

  static MeasurementUnit fromJson(String json) => fromString(json);

  @override
  String toString() => symbol.isEmpty ? displayName : '$displayName ($symbol)';
}
