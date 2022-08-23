import 'package:app_learn_english/logError/LogCustom.dart';
import 'package:app_learn_english/models/learn_online/learn_offline.dart';
import 'package:app_learn_english/socket/models/friend_model.dart';
import 'package:app_learn_english/socket/models/list_point.dart';
import 'package:app_learn_english/socket/models/table.dart' as table;
import 'package:app_learn_english/socket/utils/signaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketProvider with ChangeNotifier {
  //Bật sub trong bàn
  bool _isOnSub = false;
  // Check xem có trong tạo phòng hay không
  bool _isInsideLearnRoom = false;

  //Biến check show message turn
  bool _isShowTurn = true;

  int _isStatusCancelTable = 0;

  int _totalNoti=1;

  //biến check trạng thái khi logout không cho nhảy vào popup
  bool _isLogoutCheck = true;

  //Is Show popup đăng nhập
  bool _isShowLogin = false;

  // trạng thái của nút tab trong view dialog mời chơi
  bool _isOffline=false;

  //trạng thái tìm kiếm danh sách user
  bool _isSearchUserOff=false;

  //Last room
  int? _lastRoom;

  //RTC video render
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  //Signaling
  Signaling _signaling = Signaling();

  //Trạng thái sẵn sàng của user
  bool _isReadyUser = false;

  bool _isShow = true;
  //Push Error
  bool _isError = false;
  //1 Đối tượng kết nối socket
  WebSocketChannel? _socketChannel;
  //Trạng thái login
  bool _isLogin = false;
  //Trạng thái Join Zone
  bool _isJoin = false;
  //Trạng thái đã tạo và Join Phòng
  bool _isJoinRoom = false;
  //Trạng thái Join phòng
  bool _isJoinRoomExist = false;
  //Trang thái săn sàng
  bool _isReady = false;
  //Trạng thái lượt chơi của chủ phòng
  bool _isTurnOwn = false;
  //Trạng thái lượt chơi của khách
  bool _isTurnClient = false;

  //Trạng thái mở dialog mời chơi
  bool _isOpenPop = false;

  //Trạng thái đã mở socket
  bool _isOpenSocket = false;

  //Dữ liệu của table
  List<table.Table> _tables = [];

  //List bạn bè online
  List<FriendModel> _listFriend = [];
 //List bạn bè offline
  List<ListUser> _listUserOffline=[];

  // Vị trí hiện Tại
  List<String?> _currentRoute = [];

  //Bàn đang bên trong
  int? _idTableInside;

  //index của tăng dần của sub gửi lên
  int _idxTurn = 0;

  // Lưu giá trị điểm tạm thời để hiện thị khi kết thúc lượt chơi
  List<ListPoint> _listPoints = [];

  //Video id bàn hiện tại
  int? _videoId;

  int _numberPage=0;

  bool _loadMore=false;


  int get totalNoti=>_totalNoti;

  //get page load list bạn bè offline

  int get numberPage=>_numberPage;

  //get xem có trong phòng học hay không
  bool get isInsideLearnRoom => _isInsideLearnRoom;

  bool get isShowTurn => _isShowTurn;
  bool get isOnSub => _isOnSub;

  bool get loadMore=>_loadMore;

  //get logout check
  bool get isLogoutCheck => _isLogoutCheck;

  //Get status code cancel table id
  int get isStatusCancelTable => _isStatusCancelTable;

  //get is show popup login
  bool get isShowLogin => _isShowLogin;

  //Get last room
  int? get lastRoom => _lastRoom;

  //Get signaling
  Signaling get signaling => _signaling;

  //Get RTC video render
  RTCVideoRenderer get localRenderer => _localRenderer;

  //Get trạng thái của socket
  bool get isOpenSocket => _isOpenSocket;

  bool get isShow => _isShow;

  //Get push error
  bool get isError => _isError;

  //Get vị trí hiện Tại
  List<String?> get currentRoute => _currentRoute;

  //Get video id bàn hiện tại
  int? get videoId => _videoId;

  //Get channel socket
  WebSocketChannel? get socketChannel => _socketChannel;

  //Get index tăng dần của sub gửi liên
  int get idxTurn => _idxTurn;

  //Get list user offline
  List<ListUser> get listUserOffline =>_listUserOffline;

  //Get trạng thái search
  bool get isSearchUserOff=>_isSearchUserOff;

  //Get id bàn đang bên trong
  get idTableInside => _idTableInside;

  //Get trạng thái login
  get isLogin => _isLogin;

  //Get trạng thái Zone
  get isJoin => _isJoin;

  //Get trạng thái Room
  get isJoinRoom => _isJoinRoom;

  //Get trạng thái open dialog mời chơi
  get isOpenPop => _isOpenPop;

  //Get trạng thái Room có sẵn
  get isJoinRoomExist => _isJoinRoomExist;
  //Get trạng thái ready
  get isReady => _isReady;

  //Get lượt chơi của chủ phòng
  get isTurnOwn => _isTurnOwn;

  //Get lượt chơi của khách
  get isTurnClient => _isTurnClient;

  // get trang thái của nút trong danh sách mời chơi
  get isOffline=>_isOffline;

  //Get danh sách Bàn
  List<table.Table> get listTable => _tables;

  //Get list bạn bè
  List<FriendModel> get listFriend => _listFriend;

  //Get danh sách poin
  List<ListPoint> get listPoints => _listPoints;

  //Get ready của user
  bool get isReadyUser => _isReadyUser;

  //set check có show thông báo turn
  void setIsShowTurn(bool isShow) {
    _isShowTurn = isShow;
    notifyListeners();
  }

  void setStatusOffline(bool statusOffline){
    _isOffline=statusOffline;
    notifyListeners();
  }

  void setIsOnSub(bool isShow) {
    _isOnSub = isShow;
    notifyListeners();
  }

  //set check xem có đang trong tạo phòng hay không
  void setIsInsideRoom(bool isInsideRoom) {
    _isInsideLearnRoom = isInsideRoom;
    notifyListeners();
  }

  //setIsLogout check
  void setIsLogoutCheck(bool check) {
    _isLogoutCheck = check;
    notifyListeners();
  }

  //Set is cancel table status
  void setCancelTableStatus(int status) {
    _isStatusCancelTable = status;
    notifyListeners();
  }

  //Set is show login
  void setIsShowLogin(bool showLogin) {
    _isShowLogin = showLogin;
    notifyListeners();
  }

  //Set last room
  void setLastRoom(int? lastRoom) {
    _lastRoom = lastRoom;
    notifyListeners();
  }

  //Set signaling
  void setSignaling(Signaling signaling) {
    _signaling = signaling;
    notifyListeners();
  }

  //Set RTC video render
  void setLocalVideo(RTCVideoRenderer rtcVideoRenderer) {
    _localRenderer = rtcVideoRenderer;
    notifyListeners();
  }

  // Set trạng thái ready của user
  void setReadyUser(bool isReady) {
    _isReadyUser = isReady;
    notifyListeners();
  }

  //set trạng thái của socket
  void setOpenSocket(bool stateSocket) {
    _isOpenSocket = stateSocket;
    notifyListeners();
  }

  void setIsShowing(bool isShowing) {
    _isShow = isShowing;
    notifyListeners();
  }

  //Set push Error
  void setPushError(bool isError) {
    _isError = isError;
    notifyListeners();
  }

  //set Vị trí hiện Tại
  void setCurrentRoute(List<String?> currentRoute) {
    _currentRoute = currentRoute;
    notifyListeners();
  }

  //Set id bàn hiện tại khi thoát bàn clear đi
  void setVideoId(int? id) {
    _videoId = id;
    notifyListeners();
  }

  //Set danh sách điểm tạm thời
  void setListPoints(List<ListPoint> _listPoints) {
    _listPoints = _listPoints;
    notifyListeners();
  }

  //Set socket chanel
  void setSocketChanel(WebSocketChannel? webSocketChannel) {
    _socketChannel = webSocketChannel;
    notifyListeners();
  }

  //Set danh sách bàn
  void setTable(List<table.Table> tables) {
    _tables = tables;
    notifyListeners();
  }

  //Set bàn hiện tại của user
  void setIdTableInside(int idTableInside) {
    _idTableInside = idTableInside;
    notifyListeners();
  }

  //Set trạng thái login
  void setStateLogin(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }

  //Set trạng thái zone
  void setStateZone(bool isJoinZone) {
    _isJoin = isJoinZone;
    notifyListeners();
  }

  //Set trạng thái room
  void setStateRoom(bool isJoinRoom) {
    _isJoinRoom = isJoinRoom;
    notifyListeners();
  }

  //Set trạng thái room
  void setStateRoomExist(bool isJoinRoom) {
    _isJoinRoomExist = isJoinRoom;
    notifyListeners();
  }

  //Set trang thai ready
  void setStateReady(bool isReady) {
    _isReady = isReady;
    notifyListeners();
  }

  //Set trang thai lượt chơi của chủ phòng
  void setStateTurnOwn(bool isTurn) {
    printRed("setStateTurnOwn");
    _isTurnOwn = isTurn;
    notifyListeners();
  }

  //Set trang thai lượt chơi của khách
  void setStateTurnClient(bool isTurnClient) {
    _isTurnClient = isTurnClient;
    notifyListeners();
  }

  //Set trang thai lượt chơi của khách
  void setListFriend(List<FriendModel> listFriendNew) {
    _listFriend = listFriendNew;
    notifyListeners();
  }

  //Set trang thai lượt chơi của khách
  void setStateOpenPop(bool isNewOpen) {
    _isOpenPop = isNewOpen;
    notifyListeners();
  }

  //Set index tăng dần của sub gửi
  void setIndexTurn(int index) {
    _idxTurn = index;
    notifyListeners();
  }

  void setPage(int numberPage){
    _numberPage=numberPage;
    notifyListeners();
  }

  void setLoadMore(bool isLoadMore){
    _loadMore=isLoadMore;
    notifyListeners();
  }

  void setListUserOffline(List<ListUser> listUserOffline){
      _listUserOffline =listUserOffline;
      notifyListeners();
  }

  void setStatusSearchUserOff(bool statusSearch){
    _isSearchUserOff=statusSearch;
    notifyListeners();
  }

  void setTotalNoti(int totalNew){
    _totalNoti=totalNew;
    notifyListeners();
  }

  //Reset
  void reset() {
    _idxTurn = 0;
    _isReady = false;
    _tables = [];
    _idTableInside = null;
    _videoId = null;
    _isOpenSocket = false;
    _currentRoute = [];
    notifyListeners();
  }
}
