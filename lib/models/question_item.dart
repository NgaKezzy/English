// ignore_for_file: file_names, non_constant_identifier_names

class QuestionItem {
  int? id;
  String? question;
  String? answer_one;
  String? answer_two;
  String? true_answer;
  int? cate_id;
  int? noun_id;
  int? adj_id;

  QuestionItem({
    required this.id,
    required this.question,
    required this.answer_one,
    required this.answer_two,
    required this.true_answer,
    required this.cate_id,
    required this.noun_id,
    required this.adj_id,
  });

  factory QuestionItem.fromJson(Map<dynamic, dynamic> json) {
    final user = QuestionItem(
      id: int.parse('${json['id']}'),
      question: json['Question'],
      answer_one: json['answer_one'],
      answer_two: json['answer_two'],
      true_answer: json['true_answer'],
      cate_id: json['cate_id'],
      noun_id: json['noun_id'],
      adj_id: json['adj_id'],
    );

    return user;
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'answer_one': answer_one,
        'answer_two': answer_two,
        'true_answer': true_answer,
        'cate_id': cate_id,
        'noun_id': noun_id,
        'adj_id': adj_id,
      };
}
