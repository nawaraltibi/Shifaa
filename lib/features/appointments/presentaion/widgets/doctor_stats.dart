import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_stats_item.dart';

class DoctorStats extends StatelessWidget {
  const DoctorStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DoctorStatsItem(
          icon: FontAwesomeIcons.users,
          statName: 'Patients',
          statNum: 7500,
        ),
        DoctorStatsItem(
          icon: FontAwesomeIcons.briefcase,
          statName: 'Years Exp',
          statNum: 10,
        ),
        DoctorStatsItem(
          icon: FontAwesomeIcons.solidStar,
          statName: 'Rating',
          showPlus: false,
          statNum: 4.8,
        ),
        DoctorStatsItem(
          icon: FontAwesomeIcons.solidCommentDots,
          statName: 'Reviews',
          showPlus: false,
          statNum: 3572,
        ),
      ],
    );
  }
}
