import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/services/job_services/job_firebase_service.dart';

class JobRepository {
  late JobRemoteService remoteService;

  JobRepository() {
    remoteService = JobRemoteService();
  }

  Future<List<Job>> getAllJobs()
  => remoteService.getAllJobs();

  Future<Job?> getJobById(String jobId)
  => remoteService.getJobById(jobId);

  Future<bool> addJob(Job job)
  => remoteService.addJob(job);

  Future<int> updateJob(
    Job job, {
    Map<String, dynamic>? updateData,
  }) => remoteService.updateJob(job, updateData: updateData);

  Future<int> deleteJob(Job job)
  => remoteService.deleteJob(job);
}
