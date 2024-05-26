// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_page_bloc.dart';

class HomePageState extends Equatable {
  const HomePageState({
    this.places = const [],
    this.jobs = const [],
    this.achievementTypes = const [],
    this.relationshipTypes = const [],
    this.deathCauses = const [],
    this.members = const [],
    this.isLoading = false,
  });

  final bool isLoading;
  final List<Place> places;
  final List<Job> jobs;
  final List<AchievementType> achievementTypes;
  final List<RelationshipType> relationshipTypes;
  final List<CauseOfDeath> deathCauses;
  final List<Member> members;
  
  @override
  List<Object> get props => [ 
    isLoading, 
    places,
    jobs,
    achievementTypes,
    relationshipTypes,
    deathCauses,
    members,
  ];

  HomePageState copyWith({
    bool? isLoading,
    List<Place>? places,
    List<Job>? jobs,
    List<AchievementType>? achievementTypes,
    List<RelationshipType>? relationshipTypes,
    List<CauseOfDeath>? deathCauses,
    List<Member>? members,
  }) {
    return HomePageState(
      isLoading: isLoading ?? this.isLoading,
      places: places ?? this.places,
      jobs: jobs ?? this.jobs,
      achievementTypes: achievementTypes ?? this.achievementTypes,
      relationshipTypes: relationshipTypes ?? this.relationshipTypes,
      deathCauses: deathCauses ?? this.deathCauses,
      members: members ?? this.members,
    );
  }
}


class ErrorUpdateHomePageState extends HomePageState {
  const ErrorUpdateHomePageState({
    super.places = const [],
    super.jobs = const [],
    super.achievementTypes = const [],
    super.relationshipTypes = const [],
    super.deathCauses = const [],
    super.isLoading = false,
    this.errorMessage = "",
  });

  final String errorMessage;

  factory ErrorUpdateHomePageState.fromHomePageState(
    HomePageState mps, {
    String? errorMessage,
  }) {
    return ErrorUpdateHomePageState(
      places: mps.places,
      jobs: mps.jobs,
      achievementTypes: mps.achievementTypes,
      relationshipTypes: mps.relationshipTypes,
      deathCauses: mps.deathCauses,
      isLoading: mps.isLoading,
      errorMessage: errorMessage ?? ''
    );
  }
}

class CompleteUpdateHomePageState extends HomePageState {
  const CompleteUpdateHomePageState({
    super.places = const [],
    super.jobs = const [],
    super.achievementTypes = const [],
    super.relationshipTypes = const [],
    super.deathCauses = const [],
    super.isLoading = false,
  });

  factory CompleteUpdateHomePageState.fromHomePageState(
      HomePageState mps) {
    return CompleteUpdateHomePageState(
      places: mps.places,
      jobs: mps.jobs,
      achievementTypes: mps.achievementTypes,
      relationshipTypes: mps.relationshipTypes,
      deathCauses: mps.deathCauses,
      isLoading: mps.isLoading,
    );
  }
}
