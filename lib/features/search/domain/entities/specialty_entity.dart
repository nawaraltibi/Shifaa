import 'package:equatable/equatable.dart';

// Corrected: Now includes id and icon to match API and UI needs.
class SpecialtyEntity extends Equatable {
  final int id;
  final String name;
  final String icon;

  const SpecialtyEntity({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, icon];
}
