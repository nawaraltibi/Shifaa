import 'package:equatable/equatable.dart';

class GetHomeAppointmentsParams extends Equatable {
  final bool forceRefresh;
  const GetHomeAppointmentsParams({this.forceRefresh = false});
  @override
  List<Object> get props => [forceRefresh];
}
