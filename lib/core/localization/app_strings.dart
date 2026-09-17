import 'locale_manager.dart';

class AppStrings {
  static String tr(String en, String my) => LocaleManager.isMyanmar ? my : en;

  // Common Actions
  static String get confirm => tr('Confirm', 'အတည်ပြုမည်');
  static String get cancel => tr('Cancel', 'မလုပ်တော့ပါ');
  static String get continueBtn => tr('Continue', 'ဆက်လုပ်မည်');
  static String get done => tr('Done', 'ပြီးပါပြီ');
  static String get save => tr('Save', 'သိမ်းဆည်းမည်');
  static String get close => tr('Close', 'ပိတ်မည်');
  static String get back => tr('Back', 'နောက်သို့');
  static String get search => tr('Search', 'ရှာဖွေရန်');
  static String get copy => tr('Copy', 'ကူးယူမည်');
  static String get copied => tr('Copied to clipboard', 'ကူးယူပြီးပါပြီ');
  static String get seeAll => tr('See All', 'အားလုံးကြည့်ရန်');
  static String get viewAll => tr('View All', 'အားလုံးကြည့်ရန်');
  static String get filterAll => tr('All', 'အားလုံး');
  static String get filterIn => tr('Received', 'ရငွေ');
  static String get filterOut => tr('Spent', 'သုံးငွေ');
  static String get languageChanged => tr('Language changed to English', 'မြန်မာဘာသာသို့ ပြောင်းလဲလိုက်ပါပြီ');

  // Navigation
  static String get navHome => tr('Home', 'ပင်မ');
  static String get navWallet => tr('Wallet', 'ပိုက်ဆံအိတ်');
  static String get navScan => tr('Scan', 'စကင်');
  static String get navRewards => tr('Rewards', 'ဆုလာဘ်');
  static String get navProfile => tr('Profile', 'ပရိုဖိုင်');

  // Home Screen
  static String get greeting => tr('Good day,', 'မင်္ဂလာပါ၊');
  static String get totalBalance => tr('Total Balance', 'စုစုပေါင်း လက်ကျန်ငွေ');
  static String get transfer => tr('Transfer', 'ငွေလွှဲ');
  static String get cashIn => tr('Cash In', 'ငွေသွင်း');
  static String get cashOut => tr('Cash Out', 'ငွေထုတ်');
  static String get scanQr => tr('Scan QR', 'QR စကင်');
  static String get services => tr('Services', 'ဝန်ဆောင်မှုများ');
  static String get topUp => tr('Top Up', 'ဖုန်းငွေဖြည့်');
  static String get bills => tr('Pay Bills', 'ဘေလ်ဆောင်');
  static String get giftCards => tr('Gift Cards', 'ဂိမ်းကတ်');
  static String get groupDeals => tr('Group Deals', 'စုပေါင်းဝယ်');
  static String get events => tr('Events', 'ပွဲလက်မှတ်');
  static String get cinema => tr('Cinema', 'ရုပ်ရှင်');
  static String get insurance => tr('Insurance', 'အာမခံ');
  static String get more => tr('More', 'အားလုံး');
  static String get recentTransactions => tr('Recent Transactions', 'မကြာသေးမီက မှတ်တမ်းများ');
  static String get activePasses => tr('Active Passes', 'လက်ရှိ လက်မှတ်များ');
  static String get specialPromo => tr('Special Promotions', 'အထူး ပရိုမိုးရှင်းများ');

  // Wallet Screen
  static String get myWallet => tr('My Wallet', 'ကျွန်ုပ်၏ ပိုက်ဆံအိတ်');
  static String get availableBalance => tr('Available Balance', 'သုံးစွဲနိုင်သော လက်ကျန်ငွေ');
  static String get linkedBankAccounts => tr('Linked Bank Accounts', 'ချိတ်ဆက်ထားသော ဘဏ်များ');
  static String get addBankAccount => tr('Add Bank Account', 'ဘဏ်အကောင့် အသစ်ချိတ်မည်');
  static String get linkedCards => tr('Linked Cards', 'ချိတ်ဆက်ထားသော ကတ်များ');
  static String get addCard => tr('Add New Card', 'ကတ်အသစ် ထည့်မည်');
  static String get myVouchers => tr('My Vouchers', 'ကျွန်ုပ်၏ ကူပွန်များ');
  static String get activeGroupDeals => tr('Active Group Deals', 'ပါဝင်ထားသော လျှော့ဈေးများ');
  static String get tierBenefits => tr('Tier Benefits', 'အဆင့်အလိုက် အကျိုးခံစားခွင့်များ');

  // Scanner & QR
  static String get scanQrCode => tr('Scan QR Code', 'QR ကုဒ် စကင်ဖတ်ပါ');
  static String get myQrCode => tr('My QR Code', 'ကျွန်ုပ်၏ QR ကုဒ်');
  static String get alignQrCode => tr('Align QR code within the frame to scan', 'QR ကုဒ်ကို ဘောင်အတွင်း တည့်တည့် ထားပေးပါ');
  static String get torch => tr('Torch', 'ဓာတ်မီး');
  static String get gallery => tr('Gallery', 'ဓာတ်ပုံ');
  static String get receive => tr('Receive', 'ငွေလက်ခံ');
  static String get pay => tr('Pay', 'ငွေပေးချေ');
  static String get specifyAmount => tr('Specify Amount', 'ငွေပမာဏ သတ်မှတ်မည်');
  static String get dynamicBarcode => tr('Dynamic barcode refreshes in', 'ဘားကုဒ် အသစ်လဲရန် ကျန်ချိန်');

  // Rewards Screen
  static String get rewardsHub => tr('Rewards Hub', 'ဆုလာဘ်စင်တာ');
  static String get points => tr('Points', 'ပွိုင့်');
  static String get dailyCheckin => tr('Daily Check-in', 'နေ့စဉ် Check-in');
  static String get checkInNow => tr('Check In Now', 'Check-in လုပ်မည်');
  static String get claimed => tr('Claimed', 'ရယူပြီး');
  static String get streak => tr('Streak', 'ရက်ဆက်တိုက်');
  static String get secretShop => tr('VIP Secret Shop', 'VIP လျှို့ဝှက် အရောင်းဆိုင်');
  static String get promoVouchers => tr('Promo Vouchers', 'ပရိုမိုးရှင်း ကူပွန်များ');
  static String get pointsHistory => tr('Points History', 'ပွိုင့်မှတ်တမ်း');

  // Profile Screen
  static String get profileSettings => tr('Profile & Settings', 'ပရိုဖိုင်နှင့် ဆက်တင်များ');
  static String get userLevel => tr('User Level & Tier', 'အသုံးပြုသူအဆင့်နှင့် တန်း');
  static String get limitsFees => tr('Limits & Fees', 'ငွေလွှဲကန့်သတ်ချက်နှင့် ဝန်ဆောင်ခ');
  static String get referralCode => tr('Referral Code', 'မိတ်ဆက်ကုဒ်ဖြင့် ဖိတ်ခေါ်မည်');
  static String get securityPrivacy => tr('Security & Privacy', 'လုံခြုံရေးနှင့် ကိုယ်ရေးအချက်အလက်');
  static String get otpSettings => tr('OTP Settings', 'OTP ဆက်တင်များ');
  static String get appLanguage => tr('App Language', 'အသုံးပြုမည့် ဘာသာစကား');
  static String get darkMode => tr('Dark Mode', 'ညဘက်မုဒ် (Dark Mode)');
  static String get soundEffects => tr('Sound Effects & Haptics', 'အသံနှင့် တုန်ခါမှု');
  static String get autoReceipt => tr('Auto-Generate Digital Receipt', 'ပြေစာ အလိုအလျောက် ထုတ်ယူမည်');
  static String get liveSupport => tr('Live Support', 'တိုက်ရိုက် အကူအညီ (Live Chat)');
  static String get helpCenter => tr('Help Center & FAQs', 'အမေးများသော မေးခွန်းများ');
  static String get feedback => tr('Feedback & Rating', 'အကြံပြုချက်နှင့် အဆင့်သတ်မှတ်ချက်');
  static String get aboutHimoPay => tr('About Himo Pay', 'Himo Pay အကြောင်း');
  static String get logOut => tr('Log Out', 'အကောင့်မှ ထွက်မည်');

  // Transfer Suite
  static String get sendMoney => tr('Send Money', 'ငွေလွှဲမည်');
  static String get recipient => tr('Recipient', 'ငွေလက်ခံသူ');
  static String get enterPhone => tr('Enter phone number or account', 'ဖုန်းနံပါတ် သို့မဟုတ် အကောင့် ရိုက်ထည့်ပါ');
  static String get recentContacts => tr('Recent Contacts', 'မကြာသေးမီက အဆက်အသွယ်များ');
  static String get enterAmount => tr('Enter Amount', 'ငွေပမာဏ ရိုက်ထည့်ပါ');
  static String get reviewTransfer => tr('Review Transfer', 'ငွေလွှဲအချက်အလက် စစ်ဆေးပါ');
  static String get confirmTransfer => tr('Confirm Transfer', 'ငွေလွှဲအတည်ပြုမည်');
  static String get transferSuccess => tr('Transfer Successful', 'ငွေလွှဲခြင်း အောင်မြင်ပါသည်');
  static String get viewReceipt => tr('View Receipt', 'ပြေစာ ကြည့်မည်');
  static String get backToHome => tr('Back to Home', 'ပင်မစာမျက်နှာသို့');
  static String get noteOptional => tr('Note (Optional)', 'မှတ်ချက် (စိတ်ကြိုက်)');
  static String get transferFee => tr('Transfer Fee', 'လွှဲခ ဝန်ဆောင်ခ');
  static String get free => tr('Free', 'အခမဲ့');

  // Cash In / Cash Out
  static String get cashInMethods => tr('Cash In Methods', 'ငွေသွင်းမည့် နည်းလမ်းများ');
  static String get cashOutMethods => tr('Cash Out Methods', 'ငွေထုတ်မည့် နည်းလမ်းများ');
  static String get agentCash => tr('Himo Agent Points', 'Himo ကိုယ်စားလှယ်ဆိုင်များ');
  static String get linkedBank => tr('Linked Bank Account', 'ချိတ်ဆက်ထားသော ဘဏ်အကောင့်');
  static String get visaMaster => tr('Visa / Mastercard', 'Visa / Mastercard ကတ်များ');

  // Notifications
  static String get notifications => tr('Notifications', 'အသိပေးချက်များ');
  static String get markAllRead => tr('Mark all as read', 'အားလုံး ဖတ်ပြီးအဖြစ် သတ်မှတ်မည်');
  static String get noNotifications => tr('No notifications yet', 'အသိပေးချက် မရှိသေးပါ');
}

extension StringTransExtension on String {
  String tr(String burmese) => LocaleManager.isMyanmar ? burmese : this;
}
