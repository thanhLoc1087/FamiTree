import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/models/pair.dart';

class JobRemoteService {
  final _ref =
      FirebaseFirestore.instance.collection(AppCollections.jobs);

  Future<List<Job>> getAllJobs() async {
    final result = await _ref
        .where("deleted", isEqualTo: false)
        .get();

    List<Job> causes = result.docs
        .map((e) => Job.fromJson(id: e.id, json: e.data()))
        .toList();

    return causes;
  }

  Future<Job?> getJobById(String jobId) async {
    final data = await _ref
        .doc(jobId)
        .get();
    if (data.exists) {
      return Job.fromJson(id: data.id, json: data.data()!);
    }
    return null;
  }

  Future<bool> addJob(
    // 1 - tạo thành công
    // 0 - that bai
    Job job
  ) async {
    try {
      final countExistedName =
          await countExistingNames(job.name.trim());
      if (countExistedName.a + countExistedName.b > 0) {
        return false;
      }
      await _ref.add(job.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }
  
  Future<Pair> countExistingNames(String jobName) async {
    // xóa lẫn thường, có trùng tên là lấy
    // Trả về pair, số name đã xóa, số name còn sống
    final result = await _ref
        .where("name", isEqualTo: jobName)
        .get();
    int countDeleted = 0;
    int countUndeleted = 0;
    for (var doc in result.docs) {
      if (cvToBool(doc['deleted'], false)) {
        countDeleted++;
      } else {
        countUndeleted++;
      }
    }
    return Pair(countDeleted, countUndeleted);
  }

  Future<int> updateJob(
    Job job, {
    Map<String, dynamic>? updateData,
  }) async {
    if (updateData != null) {
      await _ref.doc(job.id).update(updateData);
    } else {
      await _ref.doc(job.id).update(job.toJson());
    }
    return 1;
  }

  Future<int> deleteJob(
    Job job
  ) async {
    final res = await updateJob(
      job,
      updateData: {"deleted": true});
    return res;
  }
}
