import 'package:flutter/material.dart';
import 'package:shifaa/core/errors/failure.dart';
import 'package:shifaa/features/home/domain/entities/appointments_summary.dart';
import 'package:shifaa/features/home/domain/repositories/home_repository.dart';

import '../../domain/entities/previous_appointment_entity.dart';
import '../../domain/entities/upcoming_appointment_entity.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository homeRepository;

  HomeProvider({required this.homeRepository});

  List<UpcomingAppointment>? _upcomingAppointments;
  List<PreviousAppointment>? _previousAppointments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Failure? _failure;
  Failure? get failure => _failure;

  AppointmentsSummary<UpcomingAppointment> get upcomingSummary {
    final filtered = _upcomingAppointments
        ?.where((app) => app.status != 'canceled')
        .toList() ??
        [];
    return AppointmentsSummary(
      totalCount: filtered.length,
      latestAppointment: filtered.isNotEmpty ? filtered.first : null,
    );
  }

  AppointmentsSummary<PreviousAppointment> get previousSummary {
    final filtered = _previousAppointments
        ?.where((app) => app.status != 'canceled')
        .toList() ??
        [];
    return AppointmentsSummary(
      totalCount: filtered.length,
      latestAppointment: filtered.isNotEmpty ? filtered.first : null,
    );
  }

  List<UpcomingAppointment> get allUpcomingAppointments {
    return _upcomingAppointments
        ?.where((app) => app.status != 'canceled')
        .toList() ??
        [];
  }

  List<PreviousAppointment> get allPreviousAppointments {
    return _previousAppointments
        ?.where((app) => app.status != 'canceled')
        .toList() ??
        [];
  }

  Future<void> fetchAllData() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    final upcomingResult = await homeRepository.getUpcomingAppointments();
    final previousResult = await homeRepository.getPreviousAppointments();

    upcomingResult.fold(
          (fail) => _failure = fail,
          (data) => _upcomingAppointments = data,
    );

    if (_failure == null) {
      previousResult.fold(
            (fail) => _failure = fail,
            (data) => _previousAppointments = data,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshAllData() async {
    await fetchAllData();
  }
}
