import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shifaa/features/appointments/presentaion/widgets/doctor_stats_item.dart';
import 'package:shifaa/generated/l10n.dart';

class DoctorStats extends StatelessWidget {
  const DoctorStats({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DoctorStatsItem(
          icon: FontAwesomeIcons.users,
          statName: S.of(context).patients,
          statNum: 7500,
        ),
        DoctorStatsItem(
          icon: FontAwesomeIcons.briefcase,
          statName: S.of(context).experience,
          statNum: 10,
        ),
        DoctorStatsItem(
          icon: FontAwesomeIcons.solidStar,
          statName: S.of(context).rating,
          showPlus: false,
          statNum: 4.8,
        ),
        DoctorStatsItem(
          icon: FontAwesomeIcons.solidCommentDots,
          statName: S.of(context).reviews,
          showPlus: false,
          statNum: 3572,
        ),
      ],
    );
  }
}
