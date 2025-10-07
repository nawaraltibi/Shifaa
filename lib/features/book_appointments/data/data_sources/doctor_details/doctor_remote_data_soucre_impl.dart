import 'package:shifaa/core/api/api_consumer.dart';
import 'package:shifaa/core/api/end_ponits.dart';
import 'package:shifaa/features/book_appointments/data/data_sources/doctor_details/doctor_remote_data_soucre.dart';
import 'package:shifaa/features/book_appointments/data/models/doctor_model.dart';

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final ApiConsumer api;

  DoctorRemoteDataSourceImpl(this.api);

  @override
  Future<DoctorModel> getDoctorDetails(String doctorId) async {
    final response = await api.get(EndPoint.doctorDetails(doctorId));
    final doctorData = response['data']['doctor'];
    return DoctorModel.fromJson(doctorData);
  }
}
