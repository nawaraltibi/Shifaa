import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/core/services/notification_service.dart';
import 'package:shifaa/dependency_injection.dart';
import 'package:shifaa/features/search/presentation/manager/search_cubit.dart';
import 'package:shifaa/features/search/presentation/views/widgets/search_view_body.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    NotificationService.login();
    return BlocProvider(
      create: (context) => sl<SearchCubit>(),
      child: const SearchViewBody(),
    );
  }
}