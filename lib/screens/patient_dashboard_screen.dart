import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/treatment_plan/treatment_plan_bloc.dart';
import '../bloc/treatment_plan/treatment_plan_event.dart';
import '../bloc/treatment_plan/treatment_plan_state.dart';
import '../widgets/patient_summary_card.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load patients when screen initializes
    context.read<TreatmentPlanBloc>().add(const LoadTreatmentPlansSummary());
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutRequested());
  }

  void _addPatient() {
    context.go('/add-patient');
  }

  void _refreshPatients() {
    context.read<TreatmentPlanBloc>().add(const RefreshTreatmentPlansSummary());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Patient Dashboard'),
          backgroundColor: Colors.blue.shade50,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshPatients,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: BlocConsumer<TreatmentPlanBloc, TreatmentPlanState>(
          listener: (context, state) {
            if (state is TreatmentPlanError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is PatientWithTreatmentCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Patient created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is TreatmentPlanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TreatmentPlansSummaryLoaded) {
              if (state.patients.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No patients yet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Add your first patient to get started',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _addPatient,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Patient'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 50),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => _refreshPatients(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.patients.length,
                  itemBuilder: (context, index) {
                    return PatientSummaryCard(patient: state.patients[index]);
                  },
                ),
              );
            } else if (state is PatientWithTreatmentCreated) {
              // Show updated patients list after creation
              return RefreshIndicator(
                onRefresh: () async => _refreshPatients(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.updatedPatients.length,
                  itemBuilder: (context, index) {
                    return PatientSummaryCard(
                      patient: state.updatedPatients[index],
                    );
                  },
                ),
              );
            } else if (state is TreatmentPlanError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _refreshPatients,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(150, 50),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addPatient,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
