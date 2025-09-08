import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/treatment_plan_service.dart';
import '../../models/treatment_plan_models.dart';
import 'patient_event.dart';
import 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  List<PatientTreatmentSummary> _currentPatients = [];

  PatientBloc() : super(const PatientInitial()) {
    on<LoadPatientsSummary>(_onLoadPatientsSummary);
    on<CreatePatientWithTreatment>(_onCreatePatientWithTreatment);
    on<RefreshPatientsSummary>(_onRefreshPatientsSummary);
  }

  Future<void> _onLoadPatientsSummary(
    LoadPatientsSummary event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientLoading());
    try {
      final patients = await TreatmentPlanService.getTreatmentPlansSummary();
      _currentPatients = patients;
      emit(PatientsSummaryLoaded(patients));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onCreatePatientWithTreatment(
    CreatePatientWithTreatment event,
    Emitter<PatientState> emit,
  ) async {
    emit(const PatientCreateLoading());
    try {
      final response = await TreatmentPlanService.createPatientWithTreatment(
        event.data,
      );

      // Create a new patient summary from the response
      final newPatientSummary = PatientTreatmentSummary(
        name: response.patient.name,
        totalUpperTrays: response.treatmentPlan.totalUpperTrays,
        totalLowerTrays: response.treatmentPlan.totalLowerTrays,
        upperTrayProgress: response.treatmentPlan.currentUpperTray,
        lowerTrayProgress: response.treatmentPlan.currentLowerTray,
        nextChangeDate: response.treatmentPlan.nextTrayChangeDate,
      );

      // Add to current patients list
      final updatedPatients = [..._currentPatients, newPatientSummary];
      _currentPatients = updatedPatients;

      emit(PatientCreated(response, updatedPatients));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onRefreshPatientsSummary(
    RefreshPatientsSummary event,
    Emitter<PatientState> emit,
  ) async {
    try {
      final patients = await TreatmentPlanService.getTreatmentPlansSummary();
      _currentPatients = patients;
      emit(PatientsSummaryLoaded(patients));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }
}
