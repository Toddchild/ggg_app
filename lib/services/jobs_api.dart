import '../models/job.dart';

/// Common interface for any jobs data source (live or mock).
abstract class JobsApi {
  Future<List<Job>> listJobs(String status);
  Future<Job> getJob(int id);

  // Actions used by Job Detail (needed so it compiles)
  Future<Job> accept(int id);
  Future<Job> arrive(int id);
  Future<Job> cancel(int id);
  Future<Job> escalate(int id, {String? message});
  Future<Job> complete(int id);
}
