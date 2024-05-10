// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_job_bloc.dart';

class ManageJobState extends Equatable {
  const ManageJobState({
    this.jobs = const [],
    this.isLoading = false,
  });

  final bool isLoading;
  final List<Job> jobs;
  
  @override
  List<Object> get props => [ isLoading, jobs ];

  ManageJobState copyWith({
    bool? isLoading,
    List<Job>? jobs,
  }) {
    return ManageJobState(
      isLoading: isLoading ?? this.isLoading,
      jobs: jobs ?? this.jobs,
    );
  }
}


class ErrorUpdateManageJobState extends ManageJobState {
  const ErrorUpdateManageJobState({
    super.jobs = const [],
    super.isLoading = false,
    this.errorMessage = "",
  });

  final String errorMessage;

  factory ErrorUpdateManageJobState.fromManageJobState(
    ManageJobState mps, {
    String? errorMessage,
  }) {
    return ErrorUpdateManageJobState(
      jobs: mps.jobs,
      isLoading: mps.isLoading,
      errorMessage: errorMessage ?? ''
    );
  }
}

class CompleteUpdateManageJobState extends ManageJobState {
  const CompleteUpdateManageJobState({
    super.jobs = const [],
    super.isLoading = false,
  });

  factory CompleteUpdateManageJobState.fromManageJobState(
      ManageJobState mps) {
    return CompleteUpdateManageJobState(
      jobs: mps.jobs,
      isLoading: mps.isLoading,
    );
  }
}
