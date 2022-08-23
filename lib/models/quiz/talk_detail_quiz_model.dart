class TalkDetailQuizModel {
  int? id;
  String? contentVi;
  String? contentZh;
  String? contentJa;
  String? contentHi;
  String? contentEs;
  String? contentRu;
  String? contentTr;
  String? contentPt;
  String? contentId;
  String? contentTh;
  String? contentMs;
  String? contentAr;
  String? contentFr;
  String? contentIt;
  String? contentDe;
  String? contentKo;
  String? contentZh_Hant_TW;
  String? contentSk;
  String? contentSl;
  String? content;
  int? starttime;
  int? endtime;
  String? mainSentence;
  String? author;
  String? createdtime;
  String? updatetime;

  TalkDetailQuizModel(
      {this.id,
      this.contentVi,
      this.contentZh,
      this.contentJa,
      this.contentHi,
      this.contentEs,
      this.contentRu,
      this.contentTr,
      this.contentPt,
      this.contentId,
      this.contentTh,
      this.contentMs,
      this.contentAr,
      this.contentFr,
      this.contentIt,
      this.contentDe,
      this.contentKo,
      this.contentZh_Hant_TW,
      this.contentSk,
      this.contentSl,
      this.content,
      this.starttime,
      this.endtime,
      this.mainSentence,
      this.author,
      this.createdtime,
      this.updatetime});

  TalkDetailQuizModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentVi = json['content_vi'];
    contentZh = json['content_zh'];
    contentJa = json['content_ja'];
    contentHi = json['content_hi'];
    contentEs = json['content_es'];
    contentRu = json['content_ru'];
    contentTr = json['content_tr'];
    contentPt = json['content_pt'];
    contentId = json['content_id'];
    contentTh = json['content_th'];
    contentMs = json['content_ms'];
    contentAr = json['content_ar'];
    contentFr = json['content_fr'];
    contentIt = json['content_it'];
    contentDe = json['content_de'];
    contentKo = json['content_ko'];
    contentZh_Hant_TW = json['content_zh_hant_tw'];
    contentSk = json['content_sk'];
    contentSl = json['content_sl'];
    content = json['content'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    mainSentence = json['mainSentence'];
    author = json['author'];
    createdtime = json['createdtime'];
    updatetime = json['updatetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content_vi'] = this.contentVi;
    data['content_zh'] = this.contentZh;
    data['content_ja'] = this.contentJa;
    data['content_hi'] = this.contentHi;
    data['content_es'] = this.contentEs;
    data['content_ru'] = this.contentRu;
    data['content_tr'] = this.contentTr;
    data['content_pt'] = this.contentPt;
    data['content_id'] = this.contentId;
    data['content_th'] = this.contentTh;
    data['content_ms'] = this.contentMs;
    data['content_ar'] = this.contentAr;
    data['content_fr'] = this.contentFr;
    data['content_it'] = this.contentIt;
    data['content_de'] = this.contentDe;
    data['content_ko'] = this.contentKo;
    data['content_zh_hant_tw'] = this.contentZh_Hant_TW;
    data['content_sk'] = this.contentSk;
    data['content_sl'] = this.contentSl;
    data['content'] = this.content;
    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    data['mainSentence'] = this.mainSentence;
    data['author'] = this.author;
    data['createdtime'] = this.createdtime;
    data['updatetime'] = this.updatetime;
    return data;
  }
}
