import 'package:shifaa/features/book_appointments/data/models/doctor_model.dart';

abstract class DoctorRemoteDataSource {
  Future<DoctorModel> getDoctorDetails(String doctorId);
}
