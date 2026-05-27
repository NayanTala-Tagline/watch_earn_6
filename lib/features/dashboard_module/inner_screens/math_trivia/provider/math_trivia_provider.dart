import 'dart:math';
import 'package:daily_cash/services/coin_service.dart';
import 'package:daily_cash/utils/remote_settings_service.dart';
import 'package:flutter/material.dart';

class MathTriviaProvider with ChangeNotifier {
  static const int totalQuestions = 5;
  int coinsPerCorrect = RemoteSettingsService.instance.quizPerQuestionReward;

  String _equation = '';
  String get equation => _equation;

  List<int> _options = [];
  List<int> get options => _options;

  int _correctAnswer = 0;
  int get correctAnswer => _correctAnswer;

  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;

  bool _isAnswerChecked = false;
  bool get isAnswerChecked => _isAnswerChecked;

  bool? _isCorrect;
  bool? get isCorrect => _isCorrect;

  int _questionNumber = 0;
  int get questionNumber => _questionNumber;
  int get questionDisplay => _questionNumber + 1;

  int _sessionCoins = 0;
  int get sessionCoins => _sessionCoins;

  bool _sessionComplete = false;
  bool get sessionComplete => _sessionComplete;

  MathTriviaProvider() {
    generateNewQuestion();
  }


  void generateNewQuestion() {
    final r = Random();
    final type = r.nextInt(8);

    switch (type) {
      case 0:
        _addition(r);
      case 1:
        _subtraction(r);
      case 2:
        _multiplication(r);
      case 3:
        _division(r);
      case 4:
        _square(r);
      case 5:
        _squareRoot(r);
      case 6:
        _percentage(r);
      case 7:
        _modulo(r);
    }

    _buildOptions(r);
    _selectedIndex = null;
    _isAnswerChecked = false;
    _isCorrect = null;
    notifyListeners();
  }

  void _addition(Random r) {
    final a = 5 + r.nextInt(50);
    final b = 5 + r.nextInt(50);
    _equation = '$a + $b = ?';
    _correctAnswer = a + b;
  }

  void _subtraction(Random r) {
    final a = 20 + r.nextInt(80);
    final b = 1 + r.nextInt(a);
    _equation = '$a − $b = ?';
    _correctAnswer = a - b;
  }

  void _multiplication(Random r) {
    final a = 2 + r.nextInt(12);
    final b = 2 + r.nextInt(12);
    _equation = '$a × $b = ?';
    _correctAnswer = a * b;
  }

  void _division(Random r) {
    final b = 2 + r.nextInt(10);
    final result = 2 + r.nextInt(12);
    final a = b * result;
    _equation = '$a ÷ $b = ?';
    _correctAnswer = result;
  }

  void _square(Random r) {
    final a = 2 + r.nextInt(12); // 2²–13²
    _equation = '$a² = ?';
    _correctAnswer = a * a;
  }

  void _squareRoot(Random r) {
    final result = 2 + r.nextInt(10); // √4–√121
    final a = result * result;
    _equation = '√$a = ?';
    _correctAnswer = result;
  }

  void _percentage(Random r) {
    final percents = [10, 20, 25, 50, 75];
    final pct = percents[r.nextInt(percents.length)];
    final base = (2 + r.nextInt(18)) * 10;
    _equation = '$pct% of $base = ?';
    _correctAnswer = (pct * base) ~/ 100;
  }

  void _modulo(Random r) {
    final b = 2 + r.nextInt(9);
    final a = b + r.nextInt(b * 5);
    _equation = '$a mod $b = ?';
    _correctAnswer = a % b;
  }

  void _buildOptions(Random r) {
    final Set<int> set = {_correctAnswer};
    int attempts = 0;
    while (set.length < 4 && attempts < 50) {
      attempts++;
      final offset = r.nextInt(10) - 5;
      final wrong = _correctAnswer + (offset == 0 ? 3 : offset);
      if (wrong >= 0) set.add(wrong);
    }
    int fill = _correctAnswer + 6;
    while (set.length < 4) {
      set.add(fill++);
    }
    _options = set.toList()..shuffle();
  }


  void selectOption(int index) {
    if (_isAnswerChecked) return;
    _selectedIndex = index;
    notifyListeners();
  }

  bool checkAnswer() {
    if (_selectedIndex == null) return false;
    _isAnswerChecked = true;
    _isCorrect = _options[_selectedIndex!] == _correctAnswer;
    if (_isCorrect!) _sessionCoins += coinsPerCorrect;
    notifyListeners();
    return _isCorrect!;
  }

  /// [earnedCoins] overrides sessionCoins when dynamic ad revenue is higher.
  Future<void> advanceQuestion({int? earnedCoins}) async {
    _questionNumber++;
    if (_questionNumber >= totalQuestions) {
      _sessionComplete = true;
      notifyListeners();
      final coins = earnedCoins ?? _sessionCoins;
      if (coins > 0) await CoinService.addCoins(coins);
    } else {
      generateNewQuestion();
    }
  }

  void resetSession() {
    _questionNumber = 0;
    _sessionCoins = 0;
    _sessionComplete = false;
    generateNewQuestion();
  }
}
