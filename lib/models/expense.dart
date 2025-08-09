import 'dart:convert';

class Expense {
  final String id;
  final double amount;
  final String category;
  final String? note;
  final DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      note: map['note'] as String?,
      date: DateTime.parse(map['date'] as String),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Expense.fromJson(String source) =>
      Expense.fromMap(jsonDecode(source) as Map<String, dynamic>);
}