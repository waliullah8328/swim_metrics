class AppUrls {
  AppUrls._();


  //static const String _baseUrl = 'http://10.0.20.64:7008/api/v1';


  // VPS Server
  static const String _baseUrl = 'https://api.mrphrenfix.com/api/v1';
   //static const String _baseUrl = 'http://203.161.60.101:6008/api/v1';
   // static const String _baseUrl = 'http://10.0.10.64:7008/api/v1';
  // static const String _baseUrl = 'http://10.0.10.64:7008/api/v1';





   // Authentication Part
   static const String login = '$_baseUrl/auth/login';
   static const String forgetEmail = '$_baseUrl/auth/forget-password';
   static const String forgotVerifyOtp = '$_baseUrl/auth/forget-otp-verify';
   static const String resetPassword = '$_baseUrl/auth/reset-password';
   static const String getMyProfile = '$_baseUrl/user/me';



  /// ai chat bot portion
  static const String createAiChat = "$_baseUrl/chat/chatWithAI";

  /// socket chat Url
   static const String socketUrl = "ws://10.0.20.64:7008";

  // Add review
  static const String addReview = '$_baseUrl/review/create';


  // Payment
  static const String confirmPayment= '$_baseUrl/payment/create';

  static completeService(String serviceId)=> '$_baseUrl/service/complete-service/$serviceId';
  static cancelService(String serviceId)=> '$_baseUrl/service/cancel-service/$serviceId';
  static const String getNotification= '$_baseUrl/notification';


  // Notification
  static const String extraPayment = '$_baseUrl/payment/create?type=extra';
  static  extraPaymentDelete(String notificationId) => '$_baseUrl/service/decline-for-extra-payment/$notificationId';

   // Chat
  static const String webSocketUrl = "ws://api.mrphrenfix.com/api/v1";
  //static const String webSocketUrl = "ws://10.0.20.64:7008/api/v1";
  static const String getChatList= '$_baseUrl/chat/getMyChat';








}
