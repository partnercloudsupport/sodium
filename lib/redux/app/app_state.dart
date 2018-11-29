import 'package:rxdart/rxdart.dart';
import 'package:sodium/data/model/acchievement.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/metal.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/ui/ui_state.dart';

class AppState {
  final User user;
  final String token;
  final List<Food> entries;
  final List<Food> foodSearchResults;
  final Food foodSearchSelected;
  final List<Achievement> achievements;
  final List<MentalHealth> mentalHealths;
  final UiState uiState;

  final BehaviorSubject<List<Achievement>> achievementsRecentlyUnlockedStream;
  final BehaviorSubject<List<MentalHealth>> mentalHealthsStream;

  AppState({
    this.user,
    this.token,
    this.entries,
    this.foodSearchResults,
    this.foodSearchSelected,
    this.achievements,
    this.mentalHealths,
    this.uiState,
    this.achievementsRecentlyUnlockedStream,
    this.mentalHealthsStream,
  });

  factory AppState.initial() {
    return AppState(
      user: null,
      token: null,
      entries: null,
      foodSearchResults: [],
      foodSearchSelected: null,
      achievements: null,
      mentalHealths: null,
      achievementsRecentlyUnlockedStream: BehaviorSubject<List<Achievement>>(),
      mentalHealthsStream: BehaviorSubject<List<MentalHealth>>(),
      uiState: UiState.initial(),
    );
  }

  AppState copyWith({
    User user,
    String token,
    List<Food> entries,
    List<Food> foodSearchResults,
    Food foodSearchSelected,
    List<Achievement> achievements,
    List<MentalHealth> mentalHealths,
    BehaviorSubject<BehaviorSubject> achievementStream,
    BehaviorSubject<BehaviorSubject> mentalHealthsStream,
    UiState uiState,
  }) {
    return AppState(
      user: user ?? this.user,
      token: token ?? this.token,
      entries: entries ?? this.entries,
      foodSearchResults: foodSearchResults ?? this.foodSearchResults,
      foodSearchSelected: foodSearchSelected ?? this.foodSearchSelected,
      uiState: uiState ?? this.uiState,
      achievements: achievements ?? this.achievements,
      mentalHealths: mentalHealths ?? this.mentalHealths,
      achievementsRecentlyUnlockedStream: achievementStream ?? this.achievementsRecentlyUnlockedStream,
      mentalHealthsStream: mentalHealthsStream ?? this.mentalHealthsStream,
    );
  }
}
