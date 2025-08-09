import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/expense.dart';

class BudgetProvider extends ChangeNotifier {
  double initialMoney = 0;
  DateTime? periodStart;
  List<Expense> expenses = [];

  // User settings
  String name = '';
  String currency = 'USD';
  int reminderDays = 7;

  // Gamification
  int streak = 0;
  DateTime? lastExpenseDate;
  bool challengeActive = false;
  DateTime? challengeStart;

  final _uuid = const Uuid();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    initialMoney = prefs.getDouble('initialMoney') ?? 0;
    final start = prefs.getString('periodStart');
    if (start != null) {
      periodStart = DateTime.tryParse(start);
    }
    final expList = prefs.getStringList('expenses') ?? [];
    expenses = expList
        .map((e) => Expense.fromJson(e))
        .toList();
    name = prefs.getString('name') ?? '';
    currency = prefs.getString('currency') ?? 'USD';
    reminderDays = prefs.getInt('reminderDays') ?? 7;
    streak = prefs.getInt('streak') ?? 0;
    final last = prefs.getString('lastExpenseDate');
    if (last != null) {
      lastExpenseDate = DateTime.tryParse(last);
    }
    challengeActive = prefs.getBool('challengeActive') ?? false;
    final challenge = prefs.getString('challengeStart');
    if (challenge != null) {
      challengeStart = DateTime.tryParse(challenge);
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('initialMoney', initialMoney);
    if (periodStart != null) {
      await prefs.setString('periodStart', periodStart!.toIso8601String());
    }
    await prefs.setStringList(
        'expenses', expenses.map((e) => e.toJson()).toList());
    await prefs.setString('name', name);
    await prefs.setString('currency', currency);
    await prefs.setInt('reminderDays', reminderDays);
    await prefs.setInt('streak', streak);
    if (lastExpenseDate != null) {
      await prefs.setString(
          'lastExpenseDate', lastExpenseDate!.toIso8601String());
    }
    await prefs.setBool('challengeActive', challengeActive);
    if (challengeStart != null) {
      await prefs.setString(
          'challengeStart', challengeStart!.toIso8601String());
    }
  }

  void updateSettings({
    required String newName,
    required String newCurrency,
    required int newReminderDays,
  }) {
    name = newName;
    currency = newCurrency;
    reminderDays = newReminderDays;
    _save();
    notifyListeners();
  }

  void setInitialMoney(double amount) {
    initialMoney = amount;
    periodStart = DateTime.now();
    _save();
    notifyListeners();
  }

  void addExpense({
    required double amount,
    required String category,
    String? note,
    DateTime? date,
  }) {
    final exp = Expense(
        id: _uuid.v4(),
        amount: amount,
        category: category,
        note: note,
        date: date ?? DateTime.now());
    expenses.add(exp);
    _updateStreak(exp.date);
    _save();
    notifyListeners();
  }

  void _updateStreak(DateTime date) {
    if (lastExpenseDate == null) {
      streak = 1;
    } else {
      final diff = date.difference(lastExpenseDate!).inDays;
      if (diff == 1) {
        streak += 1;
      } else if (diff > 1) {
        streak = 1;
      }
    }
    lastExpenseDate = DateTime(date.year, date.month, date.day);
  }

  double get totalSpent =>
      expenses.fold(0, (sum, item) => sum + item.amount);

  double get percentSpent => initialMoney == 0
      ? 0
      : (totalSpent / initialMoney) * 100;

  String get alertState {
    final pct = percentSpent;
    if (pct >= 90) return 'red';
    if (pct > 50) return 'yellow';
    return 'green';
  }

  String alertMessage() {
    final pct = percentSpent.toStringAsFixed(0);
    switch (alertState) {
      case 'red':
        return 'Alerta roja: has usado el $pct%. Congela gastos discrecionales 48h y activa un reto de ahorro.';
      case 'yellow':
        return 'Vas por el $pct% de tu dinero. ¡Aún puedes ajustar! Revisa tus gastos grandes.';
      default:
        return '¡Vas bien! Lleva tu racha a $streak días.';
    }
  }

  void startChallenge() {
    challengeActive = true;
    challengeStart = DateTime.now();
    _save();
    notifyListeners();
  }

  void completeChallenge() {
    challengeActive = false;
    challengeStart = null;
    _save();
    notifyListeners();
  }

  Duration? get challengeRemaining {
    if (!challengeActive || challengeStart == null) return null;
    final end = challengeStart!.add(const Duration(hours: 48));
    final diff = end.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }
}