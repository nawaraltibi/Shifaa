import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/core/usecase/usecase.dart';
import 'package:shifaa/features/search/domain/entities/dtoctor_entity.dart';
import 'package:shifaa/features/specialty_details/domain/repositories/specialty_details_repository.dart';


class GetSpecialtyDoctorsUsecase implements UseCase<List<DoctorEntity>, GetSpecialtyDoctorsParams> {
  final SpecialtyDetailsRepository repository;

  GetSpecialtyDoctorsUsecase(this.repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(GetSpecialtyDoctorsParams params) async {
    return await repository.getDoctorsBySpecialty(params.specialtyId);
  }
}

class GetSpecialtyDoctorsParams extends Equatable {
  final int specialtyId;

  const GetSpecialtyDoctorsParams({required this.specialtyId});

  @override
  List<Object?> get props => [specialtyId];
}