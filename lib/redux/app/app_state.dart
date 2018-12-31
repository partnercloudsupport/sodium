import 'package:rxdart/rxdart.dart';
import 'package:sodium/data/model/acchievement.dart';
import 'package:sodium/data/model/blood_pressure.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/metal.dart';
import 'package:sodium/data/model/news.dart';
import 'package:sodium/data/model/seasoning.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/ui/ui_state.dart';

class AppState {
  final User user;
  final String token;
  final List<Food> entries;
  final List<Food> foodSearchResults;
  final List<Food> userFoods;
  final Food foodSearchSelected;
  final List<Seasoning> seasonings;
  final List<Achievement> achievements;
  final List<MentalHealth> mentalHealths;
  final List<BloodPressure> bloodPressures;
  final List<News> news;
  final UiState uiState;

  final BehaviorSubject<List<Achievement>> achievementsRecentlyUnlockedStream;
  final BehaviorSubject<List<MentalHealth>> mentalHealthsStream;
  final BehaviorSubject<User> userStream;

  AppState({
    this.user,
    this.token,
    this.entries,
    this.foodSearchResults,
    this.foodSearchSelected,
    this.userFoods,
    this.seasonings,
    this.achievements,
    this.mentalHealths,
    this.bloodPressures,
    this.news,
    this.uiState,
    this.achievementsRecentlyUnlockedStream,
    this.mentalHealthsStream,
    this.userStream,
  });

  factory AppState.initial() {
    return AppState(
      user: null,
      token: null,
      entries: null,
      foodSearchResults: [],
      userFoods: [],
      foodSearchSelected: null,
      seasonings: [],
      achievements: null,
      mentalHealths: null,
      bloodPressures: [],
      news: [],
      achievementsRecentlyUnlockedStream: BehaviorSubject<List<Achievement>>(),
      mentalHealthsStream: BehaviorSubject<List<MentalHealth>>(),
      userStream: BehaviorSubject<User>(),
      uiState: UiState.initial(),
    );
  }

  AppState copyWith({
    User user,
    String token,
    List<Food> entries,
    List<Food> foodSearchResults,
    List<Food> userFoods,
    Food foodSearchSelected,
    List<Seasoning> seasonings,
    List<Achievement> achievements,
    List<MentalHealth> mentalHealths,
    List<BloodPressure> bloodPressures,
    List<News> news,
    BehaviorSubject<BehaviorSubject> achievementStream,
    BehaviorSubject<BehaviorSubject> mentalHealthsStream,
    BehaviorSubject<BehaviorSubject> userStream,
    UiState uiState,
  }) {
    return AppState(
      user: user ?? this.user,
      token: token ?? this.token,
      entries: entries ?? this.entries,
      foodSearchResults: foodSearchResults ?? this.foodSearchResults,
      foodSearchSelected: foodSearchSelected ?? this.foodSearchSelected,
      userFoods: userFoods ?? this.userFoods,
      seasonings: seasonings ?? this.seasonings,
      uiState: uiState ?? this.uiState,
      achievements: achievements ?? this.achievements,
      mentalHealths: mentalHealths ?? this.mentalHealths,
      bloodPressures: bloodPressures ?? this.bloodPressures,
      news: news ?? this.news,
      achievementsRecentlyUnlockedStream: achievementStream ?? this.achievementsRecentlyUnlockedStream,
      mentalHealthsStream: mentalHealthsStream ?? this.mentalHealthsStream,
      userStream: userStream ?? this.userStream,
    );
  }
}
