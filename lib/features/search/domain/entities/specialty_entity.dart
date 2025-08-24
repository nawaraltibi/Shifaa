import 'package:equatable/equatable.dart';

class SpecialtyEntity extends Equatable {
  final String name;

  const SpecialtyEntity({required this.name});

  @override
  List<Object?> get props => [name];
}
