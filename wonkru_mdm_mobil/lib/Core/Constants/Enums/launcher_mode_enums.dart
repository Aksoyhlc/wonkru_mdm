import 'package:wonkrumdm/Core/Extensions/enum.dart';
export 'package:wonkrumdm/Core/Extensions/enum.dart';

enum IconSize implements StringEnum {
  small('small', 'Small'),
  medium('medium', 'Medium'),
  large('large', 'Large');

  @override
  final String value;
  final String label;
  const IconSize(this.value, this.label);
}

enum LayoutType implements StringEnum {
  grid('grid', 'Grid'),
  list('list', 'List');

  @override
  final String value;
  final String label;
  const LayoutType(this.value, this.label);
}