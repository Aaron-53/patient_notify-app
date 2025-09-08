import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/treatment_plan_service.dart';
import '../../models/treatment_plan_models.dart';
import 'treatment_plan_event.dart';
import 'treatment_plan_state.dart';

class TreatmentPlanBloc extends Bloc<TreatmentPlanEvent, TreatmentPlanState> {
  List<PatientTreatmentSummary> _currentPatients = [];

  TreatmentPlanBloc() : super(const TreatmentPlanInitial()) {
    on<LoadTreatmentPlansSummary>(_onLoadTreatmentPlansSummary);
    on<CreatePatientWithTreatment>(_onCreatePatientWithTreatment);
    on<RefreshTreatmentPlansSummary>(_onRefreshTreatmentPlansSummary);
  }

  Future<void> _onLoadTreatmentPlansSummary(
    LoadTreatmentPlansSummary event,
    Emitter<TreatmentPlanState> emit,
  ) async {
    emit(const TreatmentPlanLoading());
    try {
      final patients = await TreatmentPlanService.getTreatmentPlansSummary();
      _currentPatients = patients;
      emit(TreatmentPlansSummaryLoaded(patients));
    } catch (e) {
      emit(TreatmentPlanError(e.toString()));
    }
  }

  Future<void> _onCreatePatientWithTreatment(
    CreatePatientWithTreatment event,
    Emitter<TreatmentPlanState> emit,
  ) async {
    emit(const TreatmentPlanCreateLoading());
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

      emit(PatientWithTreatmentCreated(response, updatedPatients));
    } catch (e) {
      emit(TreatmentPlanError(e.toString()));
    }
  }

  Future<void> _onRefreshTreatmentPlansSummary(
    RefreshTreatmentPlansSummary event,
    Emitter<TreatmentPlanState> emit,
  ) async {
    try {
      final patients = await TreatmentPlanService.getTreatmentPlansSummary();
      _currentPatients = patients;
      emit(TreatmentPlansSummaryLoaded(patients));
    } catch (e) {
      emit(TreatmentPlanError(e.toString()));
    }
  }
}
