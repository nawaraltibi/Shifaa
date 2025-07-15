import 'package:flutter/material.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_details_view_body.dart';

class DoctorDetailsView extends StatelessWidget {
  const DoctorDetailsView({super.key});
  static const String routeName = '/doctor_details';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: DoctorDetailsViewBody());
  }
}
