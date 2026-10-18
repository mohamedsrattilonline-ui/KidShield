import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('ar'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  bool get isArabic => locale.languageCode == 'ar';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General & Onboarding
      'appName': 'KidShield Safety',
      'selectModeTitle': 'Choose Application Mode',
      'selectModeSubtitle': 'Select how this device will be used',
      'parentMode': 'Parent Dashboard',
      'parentModeDesc': 'Monitor child location, set screen time rules, and receive alerts',
      'childMode': 'Child Device',
      'childModeDesc': 'Enable device protection, real-time location sync, and SOS button',
      'continueBtn': 'Continue',
      'switchLanguage': 'العربية',
      'switchMode': 'Switch Mode',

      // Parent Auth
      'parentLoginTitle': 'Parent Sign In',
      'parentLoginSubtitle': 'Manage your family safety dashboard',
      'email': 'Email Address',
      'password': 'Password',
      'signIn': 'Sign In',
      'signInWithGoogle': 'Sign In with Google',
      'createAccount': 'Create Parent Account',
      'dontHaveAccount': "Don't have an account?",
      'alreadyHaveAccount': 'Already have an account?',
      'or': 'OR',

      // Parent Dashboard
      'dashboard': 'Parent Dashboard',
      'childrenCount': 'Protected Children',
      'addChild': 'Pair Child Device',
      'noChildrenYet': 'No child devices linked yet',
      'noChildrenDesc': 'Tap the button below to generate a pairing code and link your child’s device.',
      'liveLocation': 'Live Location',
      'battery': 'Battery',
      'charging': 'Charging',
      'lastSeen': 'Last seen',
      'online': 'Online',
      'offline': 'Offline',
      'screenTime': 'Screen Time',
      'rulesAndLimits': 'Rules & Limits',
      'activeProtection': 'Active Protection',

      // Device Pairing
      'pairNewDevice': 'Pair Child Device',
      'pairInstruction': 'On your child’s device, enter this 6-digit code or scan the QR code:',
      'pairingCodeExpiresIn': 'Code expires in',
      'generateNewCode': 'Generate New Code',
      'enterChildName': "Child's Name (e.g., Sarah)",
      'waitingForChild': 'Waiting for child device to connect...',

      // Child Pairing Screen
      'childPairingTitle': 'Link to Parent Account',
      'childPairingSubtitle': 'Enter the 6-digit code shown on your parent’s screen:',
      'enterPinCode': 'Enter 6-Digit PIN',
      'scanQrCode': 'Scan Parent QR Code',
      'confirmLink': 'Link Device',
      'linkingDevice': 'Linking device...',
      'pairingSuccess': 'Device successfully linked to parent!',
      'invalidCode': 'Invalid or expired code. Please verify and try again.',

      // Child Dashboard
      'childDashboardTitle': 'Child Safety Active',
      'deviceProtected': 'Device is Protected',
      'protectionActiveDesc': 'Location tracking and safety monitoring are running in the background.',
      'sosButton': 'EMERGENCY SOS',
      'sosSubtitle': 'Press and hold to send immediate emergency alert to your parent',
      'sosTriggeredTitle': 'Emergency SOS Sent!',
      'sosTriggeredDesc': 'Your exact location and an emergency siren have been sent to your parent.',
      'cancelAlert': 'Cancel Alert',
      'batteryLevel': 'Battery Level',
      'gpsStatus': 'GPS Telemetry',
      'active': 'Active',

      // Rules & Bedtime
      'screenTimeSettings': 'Screen Time & Bedtime Controls',
      'dailyLimit': 'Daily Limit (Hours)',
      'hours': 'hours',
      'minutes': 'minutes',
      'bedtimeLock': 'Bedtime Lock',
      'bedtimeLockDesc': 'Prevent device use during night hours',
      'bedtimeSchedule': 'Bedtime Schedule',
      'from': 'From',
      'to': 'To',
      'remoteInstantLock': 'Instant Device Lock',
      'remoteInstantLockDesc': 'Immediately lock child device right now',
      'saveRules': 'Save Rules',
      'rulesSaved': 'Rules updated successfully!',

      // Device Locked Overlay
      'deviceLockedTitle': 'Bedtime / Screen Time Lock',
      'deviceLockedDesc': 'This device is currently restricted by parental controls. Time to sleep or study!',
      'callEmergencyOnly': 'Emergency Call Only',

      // SOS Alert Dialog (Parent)
      'sosAlertReceived': '🚨 EMERGENCY SOS ALERT! 🚨',
      'sosFromChild': 'triggered an emergency alert!',
      'childCoordinates': 'Coordinates',
      'openInGoogleMaps': 'Open in Google Maps',
      'dismissAlert': 'Acknowledge & Silence Siren',
      'time': 'Time',
      // Web Safety & Content Filtering
      'webSafetySettings': 'Web Safety & Content Filtering',
      'enableWebFiltering': 'Web Content Filtering',
      'enableWebFilteringDesc': 'Filter web links and restrict inappropriate content',
      'blockAdultContent': 'Block Adult & Explicit Websites',
      'blockAdultContentDesc': 'Automatically block adult domains on all browsers',
      'logBrowsingHistory': 'Log Visited Websites',
      'logBrowsingHistoryDesc': 'Record domain visits and timestamps in parent dashboard',
      'webActivityLog': 'Web Activity Log',
      'noWebActivityYet': 'No web activity recorded yet',
      'blockedStatus': 'Blocked',
      'allowedStatus': 'Allowed',
      'visitedAt': 'Visited at',
    },
    'ar': {

      // General & Onboarding
      'appName': 'حماية الطفل | KidShield',
      'selectModeTitle': 'اختر وضع استخدام التطبيق',
      'selectModeSubtitle': 'حدد دور هذا الجهاز في منظومة الحماية',
      'parentMode': 'لوحة تحكم الأب',
      'parentModeDesc': 'متابعة موقع الطفل، تعيين قيود وقت الشاشة، واستلام تنبيهات الطوارئ',
      'childMode': 'جهاز الطفل',
      'childModeDesc': 'تفعيل درع الحماية، إرسال الموقع والبطارية لحظياً، وزر الاستغاثة SOS',
      'continueBtn': 'متابعة',
      'switchLanguage': 'English',
      'switchMode': 'تبديل الوضع',

      // Parent Auth
      'parentLoginTitle': 'تسجيل دخول ولي الأمر',
      'parentLoginSubtitle': 'إدارة لوحة حماية وأمان أفراد العائلة',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'signIn': 'تسجيل الدخول',
      'signInWithGoogle': 'الدخول عبر حساب Google',
      'createAccount': 'إنشاء حساب جديد لولي الأمر',
      'dontHaveAccount': 'ليس لديك حساب؟',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟',
      'or': 'أو',

      // Parent Dashboard
      'dashboard': 'لوحة تحكم الأب',
      'childrenCount': 'الأجهزة المحمية',
      'addChild': 'ربط جهاز طفل جديد',
      'noChildrenYet': 'لم يتم ربط أي جهاز طفل حتى الآن',
      'noChildrenDesc': 'اضغط على الزر أدناه لتوليد رمز الاقتران وربط هاتف طفلك فوراً.',
      'liveLocation': 'الموقع المباشر',
      'battery': 'البطارية',
      'charging': 'جاري الشحن',
      'lastSeen': 'آخر ظهور',
      'online': 'متصل الآن',
      'offline': 'غير متصل',
      'screenTime': 'وقت الشاشة',
      'rulesAndLimits': 'القواعد والقيود',
      'activeProtection': 'الحماية مفعلة',

      // Device Pairing
      'pairNewDevice': 'ربط جهاز طفل جديد',
      'pairInstruction': 'في جهاز طفلك، أدخل رمز الـ PIN المكون من 6 أرقام أو امسح الـ QR:',
      'pairingCodeExpiresIn': 'ينتهي الرمز خلال',
      'generateNewCode': 'توليد رمز جديد',
      'enterChildName': 'اسم الطفل (مثال: سارة، أحمد)',
      'waitingForChild': 'في انتظار ربط جهاز الطفل...',

      // Child Pairing Screen
      'childPairingTitle': 'ربط الجهاز بحساب الأب',
      'childPairingSubtitle': 'أدخل رمز الـ PIN المكون من 6 أرقام الظاهر في شاشة الأب:',
      'enterPinCode': 'أدخل رمز الـ PIN (٦ أرقام)',
      'scanQrCode': 'مسح رمز الاستجابة السريعة (QR)',
      'confirmLink': 'تأكيد وربط الجهاز',
      'linkingDevice': 'جاري ربط الجهاز...',
      'pairingSuccess': 'تم ربط جهاز الطفل بنجاح بحساب الأب!',
      'invalidCode': 'رمز غير صحيح أو منتهي الصلاحية. يرجى المحاولة مجدداً.',

      // Child Dashboard
      'childDashboardTitle': 'حماية الطفل قيد التشغيل',
      'deviceProtected': 'الجهاز تحت الحماية التامة',
      'protectionActiveDesc': 'يتم تحديث الموقع الجغرافي وحالة البطارية تلقائياً لحساب الأب.',
      'sosButton': 'استغاثة طارئة (SOS)',
      'sosSubtitle': 'اضغط مع الاستمرار لإرسال إنذار طارئ وفوري مع موقعك الجغرافي للأب',
      'sosTriggeredTitle': 'تم إرسال إنذار الاستغاثة!',
      'sosTriggeredDesc': 'تم إرسال إحداثيات موقعك الدقيقة وصفارة الإنذار إلى لوحة تحكم الأب.',
      'cancelAlert': 'إلغاء الإنذار',
      'batteryLevel': 'مستوى البطارية',
      'gpsStatus': 'تتبع الـ GPS',
      'active': 'نشط',

      // Rules & Bedtime
      'screenTimeSettings': 'إعدادات وقت الشاشة ووقت النوم',
      'dailyLimit': 'الحد اليومي المسموح (ساعات)',
      'hours': 'ساعات',
      'minutes': 'دقيقة',
      'bedtimeLock': 'قفل وقت النوم (Bedtime Lock)',
      'bedtimeLockDesc': 'منع استخدام الجهاز خلال ساعات الليل والنوم',
      'bedtimeSchedule': 'جدول وقت النوم',
      'from': 'من',
      'to': 'إلى',
      'remoteInstantLock': 'القفل الفوري للجهاز',
      'remoteInstantLockDesc': 'إغلاق شاشة جهاز الطفل فوراً ومنعه من الاستخدام',
      'saveRules': 'حفظ الإعدادات',
      'rulesSaved': 'تم تحديث القواعد وحفظها بنجاح!',

      // Device Locked Overlay
      'deviceLockedTitle': 'الجهاز مقفل (وقت النوم / انتهاء المدة)',
      'deviceLockedDesc': 'هذا الجهاز مقفل حالياً بموجب إعدادات الأمان الأبوية. حان وقت النوم أو الدراسة!',
      'callEmergencyOnly': 'مكالمات الطوارئ فقط',

      // SOS Alert Dialog (Parent)
      'sosAlertReceived': '🚨 إنذار استغاثة طارئ (SOS)! 🚨',
      'sosFromChild': 'أرسل نداء استغاثة عاجل!',
      'childCoordinates': 'الإحداثيات',
      'openInGoogleMaps': 'فتح في خرائط Google',
      'dismissAlert': 'تأكيد الاستلام وإيقاف صفارة الإنذار',
      'time': 'الوقت',
      // Web Safety & Content Filtering
      'webSafetySettings': 'أمان الويب وتصفية المحتوى',
      'enableWebFiltering': 'تصفية وحظر مواقع الويب',
      'enableWebFilteringDesc': 'فحص الروابط وتفعيل الحماية من المحتوى غير اللائق',
      'blockAdultContent': 'حظر المواقع الإباحية وغير اللائقة',
      'blockAdultContentDesc': 'حجب تلقائي لكافة المواقع المخلة على جميع المتصفحات',
      'logBrowsingHistory': 'تسجيل سجل المواقع المفتوحة',
      'logBrowsingHistoryDesc': 'تسجيل أسماء النطاقات وتوقيت زيارتها في لوحة الأب',
      'webActivityLog': 'سجل تصفح الويب للطفل',
      'noWebActivityYet': 'لا يوجد نشاط تصفح مسجل حتى الآن',
      'blockedStatus': 'محظور',
      'allowedStatus': 'مسموح',
      'visitedAt': 'تاريخ الزيارة',
    },
  };


  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
