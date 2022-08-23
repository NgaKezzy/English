class InfoUserModel {
  int? typeHand;
  int? countWin;
  int? countAutoPlay;
  int? utype;
  bool? isExitGame;
  int? currentFormationKey;
  List<String>? curentPosition;
  List<String>? changedPosition;
  int? countGoal;
  int? styleId;
  int? countOwnGoal;
  bool? isLeft;
  int? level;
  String? avatarID;
  String? username;
  String? viewname;
  bool? isStop;
  int? id;
  int? moneyForBet;
  bool? isWin;
  bool? isGiveUp;
  int? cash;
  int? currentMatchID;
  bool? isReady;
  int? index;
  int? pos;
  bool? isOut;
  int? registOut;
  int? experience;
  int? wonMoney;
  int? lastActivated;
  bool? isMonitor;
  int? betOther;
  int? multiBetMoney;
  bool? chan;
  bool? confirmBetOther;
  bool? showHand;
  int? betChan;
  int? betLe;
  String? isRealMoney;
  int? countTimeoutPlayFlag;
  int? lastIndex;
  bool? isLevelUp;
  int? durability;

  InfoUserModel(
      {this.typeHand,
        this.countWin,
        this.countAutoPlay,
        this.utype,
        this.isExitGame,
        this.currentFormationKey,
        this.curentPosition,
        this.changedPosition,
        this.countGoal,
        this.styleId,
        this.countOwnGoal,
        this.isLeft,
        this.level,
        this.avatarID,
        this.username,
        this.viewname,
        this.isStop,
        this.id,
        this.moneyForBet,
        this.isWin,
        this.isGiveUp,
        this.cash,
        this.currentMatchID,
        this.isReady,
        this.index,
        this.pos,
        this.isOut,
        this.registOut,
        this.experience,
        this.wonMoney,
        this.lastActivated,
        this.isMonitor,
        this.betOther,
        this.multiBetMoney,
        this.chan,
        this.confirmBetOther,
        this.showHand,
        this.betChan,
        this.betLe,
        this.isRealMoney,
        this.countTimeoutPlayFlag,
        this.lastIndex,
        this.isLevelUp,
        this.durability});

  InfoUserModel.fromJson(Map<String, dynamic> json) {
    typeHand = json['typeHand'];
    countWin = json['countWin'];
    countAutoPlay = json['countAutoPlay'];
    utype = json['utype'];
    isExitGame = json['isExitGame'];
    currentFormationKey = json['currentFormationKey'];
    curentPosition = json['curentPosition'].cast<String>();
    changedPosition = json['changedPosition'].cast<String>();
    countGoal = json['countGoal'];
    styleId = json['styleId'];
    countOwnGoal = json['countOwnGoal'];
    isLeft = json['isLeft'];
    level = json['level'];
    avatarID = json['avatarID'];
    username = json['username'];
    viewname = json['viewname'];
    isStop = json['isStop'];
    id = json['id'];
    moneyForBet = json['moneyForBet'];
    isWin = json['isWin'];
    isGiveUp = json['isGiveUp'];
    cash = json['cash'];
    currentMatchID = json['currentMatchID'];
    isReady = json['isReady'];
    index = json['index'];
    pos = json['pos'];
    isOut = json['isOut'];
    registOut = json['registOut'];
    experience = json['experience'];
    wonMoney = json['wonMoney'];
    lastActivated = json['lastActivated'];
    isMonitor = json['isMonitor'];
    betOther = json['betOther'];
    multiBetMoney = json['multiBetMoney'];
    chan = json['chan'];
    confirmBetOther = json['confirmBetOther'];
    showHand = json['showHand'];
    betChan = json['betChan'];
    betLe = json['betLe'];
    isRealMoney = json['isRealMoney'];
    countTimeoutPlayFlag = json['countTimeoutPlayFlag'];
    lastIndex = json['lastIndex'];
    isLevelUp = json['isLevelUp'];
    durability = json['durability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeHand'] = this.typeHand;
    data['countWin'] = this.countWin;
    data['countAutoPlay'] = this.countAutoPlay;
    data['utype'] = this.utype;
    data['isExitGame'] = this.isExitGame;
    data['currentFormationKey'] = this.currentFormationKey;
    data['curentPosition'] = this.curentPosition;
    data['changedPosition'] = this.changedPosition;
    data['countGoal'] = this.countGoal;
    data['styleId'] = this.styleId;
    data['countOwnGoal'] = this.countOwnGoal;
    data['isLeft'] = this.isLeft;
    data['level'] = this.level;
    data['avatarID'] = this.avatarID;
    data['username'] = this.username;
    data['viewname'] = this.viewname;
    data['isStop'] = this.isStop;
    data['id'] = this.id;
    data['moneyForBet'] = this.moneyForBet;
    data['isWin'] = this.isWin;
    data['isGiveUp'] = this.isGiveUp;
    data['cash'] = this.cash;
    data['currentMatchID'] = this.currentMatchID;
    data['isReady'] = this.isReady;
    data['index'] = this.index;
    data['pos'] = this.pos;
    data['isOut'] = this.isOut;
    data['registOut'] = this.registOut;
    data['experience'] = this.experience;
    data['wonMoney'] = this.wonMoney;
    data['lastActivated'] = this.lastActivated;
    data['isMonitor'] = this.isMonitor;
    data['betOther'] = this.betOther;
    data['multiBetMoney'] = this.multiBetMoney;
    data['chan'] = this.chan;
    data['confirmBetOther'] = this.confirmBetOther;
    data['showHand'] = this.showHand;
    data['betChan'] = this.betChan;
    data['betLe'] = this.betLe;
    data['isRealMoney'] = this.isRealMoney;
    data['countTimeoutPlayFlag'] = this.countTimeoutPlayFlag;
    data['lastIndex'] = this.lastIndex;
    data['isLevelUp'] = this.isLevelUp;
    data['durability'] = this.durability;
    return data;
  }
}