import 'package:shifaa/features/appointments/data/models/doctor_model.dart';

abstract class DoctorRemoteDataSource {
  Future<DoctorModel> getDoctorDetails(String doctorId);
}
