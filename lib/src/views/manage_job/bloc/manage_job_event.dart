part of 'manage_job_bloc.dart';

abstract class ManageJobEvent extends Equatable {
  const ManageJobEvent();

  @override
  List<Object> get props => [];
}

class LoadDataJobEvent extends ManageJobEvent {
  final List<Job> jobs;

  const LoadDataJobEvent(this.jobs);
}

class AddJobEvent extends ManageJobEvent {
  final Job job;

  const AddJobEvent(this.job);
}

class UpdateJobEvent extends ManageJobEvent {
  final Job job;

  const UpdateJobEvent(this.job);
}

class DeleteJobEvent extends ManageJobEvent {
  final Job job;

  const DeleteJobEvent(this.job);
}

class RestoreJobEvent extends ManageJobEvent {
  final Job job;

  const RestoreJobEvent(this.job);
}