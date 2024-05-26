
import 'package:famitree/src/data/repositories/achievement_type_repository.dart';
import 'package:famitree/src/data/repositories/death_cause_repository.dart';
import 'package:famitree/src/data/repositories/member_repository.dart';
import 'package:famitree/src/data/repositories/place_repository.dart';
import 'package:famitree/src/data/repositories/relationship_type_repository.dart';
import 'package:famitree/src/data/repositories/tree_repository.dart';

import 'job_repository.dart';

class AllRepository {
  late final PlaceRepository placeRepository;
  late final JobRepository jobRepository;
  late final RelationshipTypeRepository relationshipTypeRepository;
  late final AchievementTypeRepository achievementTypeRepository;
  late final DeathCauseRepository deathCauseRepository;
  late final TreeRepository treeRepository;
  late final MemberRepository memberRepository;

  AllRepository() {
    placeRepository = PlaceRepository();
    jobRepository = JobRepository();
    relationshipTypeRepository = RelationshipTypeRepository();
    achievementTypeRepository = AchievementTypeRepository();
    deathCauseRepository = DeathCauseRepository();
    treeRepository = TreeRepository();
    memberRepository = MemberRepository();
  }
}
