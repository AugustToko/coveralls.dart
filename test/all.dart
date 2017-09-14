import 'client_test.dart' as client_test;
import 'configuration_test.dart' as configuration_test;
import 'git_commit_test.dart' as git_commit_test;
import 'git_data_test.dart' as git_data_test;
import 'git_remote_test.dart' as git_remote_test;
import 'job_test.dart' as job_test;
import 'parsers/clover_test.dart' as clover_test;
import 'parsers/lcov_test.dart' as lcov_test;
import 'source_file_test.dart' as source_file_test;

/// Tests all the features of the package.
void main() {
  clover_test.main();
  lcov_test.main();

  client_test.main();
  configuration_test.main();
  git_commit_test.main();
  git_data_test.main();
  git_remote_test.main();
  job_test.main();
  source_file_test.main();
}
