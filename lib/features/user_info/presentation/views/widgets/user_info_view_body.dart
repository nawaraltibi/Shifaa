import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifaa/features/user_info/presentation/manager/user_info_cubit.dart';
import 'package:shifaa/features/user_info/presentation/views/widgets/info_tile.dart';

class UserInfoViewBody extends StatelessWidget {
  const UserInfoViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<UserInfoCubit, UserInfoState>(
        builder: (context, state) {
          if (state.status == UserInfoStatus.loading || state.status == UserInfoStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == UserInfoStatus.error || state.userInfo == null) {
            return Center(child: Text(state.errorMessage ?? 'Failed to load information.'));
          }

          final userInfo = state.userInfo!;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    )
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        child: CircleAvatar(
                          radius: 48,
                           backgroundImage: AssetImage('assets/images/avatar_placeholder.png'), // Add a placeholder
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        userInfo.fullName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       const SizedBox(height: 20),
                    ],
                  ),
                ),
                
                // Info List Section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      InfoTile(title: 'Phone Number', value: userInfo.phoneNumber),
                      InfoTile(title: 'Age', value: '${userInfo.age} Years Old'),
                      InfoTile(title: 'Weight', value: userInfo.weight != null ? '${userInfo.weight} Kg' : 'Not specified'),
                      InfoTile(title: 'Height', value: userInfo.height != null ? '${userInfo.height} cm' : 'Not specified'),
                      const InfoTile(title: 'Allergies', value: 'Not specified'),
                      const InfoTile(title: 'Terminal Illnesses', value: 'None'),
                      const InfoTile(title: 'Previous Surgeries', value: 'None'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}