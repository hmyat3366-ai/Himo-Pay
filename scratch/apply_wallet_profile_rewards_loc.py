import re

def add_import_and_replace(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Add import if missing
    if "import '../../../core/localization/app_strings.dart';" not in content and 'app_strings.dart' not in content:
        content = re.sub(
            r"(import 'package:flutter/material\.dart';)",
            r"\1\nimport '../../../core/localization/app_strings.dart';",
            content,
            count=1
        )

    for old, new in replacements:
        if old in content:
            content = content.replace(old, new)
        else:
            print(f"Warning: '{old}' not found in {filepath}")

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Updated {filepath}")

# 1. bank_accounts_screen.dart
add_import_and_replace(
    'lib/features/wallet/screens/bank_accounts_screen.dart',
    [
        ("title: 'Bank Accounts',", "title: 'Bank Accounts'.tr('ချိတ်ဆက်ထားသော ဘဏ်များ'),"),
        ("const Text('Add Bank Account',", "Text('Add Bank Account'.tr('ဘဏ်အကောင့် ထည့်မည်'),"),
        ("labelText: 'Bank Name (KBZ, AYA, CB, Yoma)'", "labelText: 'Bank Name (KBZ, AYA, CB, Yoma)'.tr('ဘဏ်အမည် (KBZ, AYA, CB, Yoma)')"),
        ("child: const Text('Cancel')", "child: Text('Cancel'.tr('မလုပ်တော့ပါ'))"),
        ("child: const Text('Add')", "child: Text('Add'.tr('ထည့်မည်'))"),
        ("'Bank account linked successfully'", "'Bank account linked successfully'.tr('ဘဏ်အကောင့် ချိတ်ဆက်မှု အောင်မြင်ပါသည်')"),
    ]
)

# 2. linked_cards_screen.dart
add_import_and_replace(
    'lib/features/wallet/screens/linked_cards_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Linked Cards'),", "appBar: HimoAppBar(title: 'Linked Cards'.tr('ချိတ်ဆက်ထားသော ကတ်များ')),"),
        ("'New Card added successfully'", "'New Card added successfully'.tr('ကတ်အသစ် ထည့်သွင်းပြီးပါပြီ')"),
        ("text: 'Link New Card',", "text: 'Link New Card'.tr('ကတ်အသစ် ချိတ်ဆက်မည်'),"),
    ]
)

# 3. tier_benefits_screen.dart
add_import_and_replace(
    'lib/features/wallet/screens/tier_benefits_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Tier Benefits'),", "appBar: HimoAppBar(title: 'Tier Benefits'.tr('အဆင့်အလိုက် အကျိုးခံစားခွင့်များ')),"),
        ("const Text(\n                          'Current Tier Status',", "Text(\n                          'Current Tier Status'.tr('လက်ရှိ အသုံးပြုသူအဆင့်'),"),
        ("const Text(\n                            'APPROVED ✓',", "Text(\n                            'APPROVED ✓'.tr('အတည်ပြုပြီး ✓'),"),
        ("const Text(\n                      'Subscriber Level 2',", "Text(\n                      'Subscriber Level 2'.tr('အဆင့် ၂ အသုံးပြုသူ'),"),
    ]
)

# 4. wallet_deals_screen.dart
add_import_and_replace(
    'lib/features/wallet/screens/wallet_deals_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'My Deals'),", "appBar: HimoAppBar(title: 'My Deals'.tr('ကျွန်ုပ်၏ လျှော့ဈေးများ')),"),
        ("_buildTab('deals', 'My Deals', isDark),", "_buildTab('deals', 'My Deals'.tr('ကျွန်ုပ်၏ လျှော့ဈေးများ'), isDark),"),
        ("_buildTab('refunded', 'Refunded Deals', isDark),", "_buildTab('refunded', 'Refunded Deals'.tr('ပြန်အမ်းငွေ လျှော့ဈေးများ'), isDark),"),
        ("_activeTab == 'deals' ? 'There is no deals.' : 'No Refunded Deals found.',", "_activeTab == 'deals' ? 'There is no deals.'.tr('လျှော့ဈေး မရှိသေးပါ') : 'No Refunded Deals found.'.tr('ပြန်အမ်းငွေ လျှော့ဈေး မရှိပါ'),"),
        ("text: 'Browse Deals',", "text: 'Browse Deals'.tr('လျှော့ဈေးများ ကြည့်မည်'),"),
    ]
)

# 5. wallet_vouchers_screen.dart
add_import_and_replace(
    'lib/features/wallet/screens/wallet_vouchers_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'My Vouchers'),", "appBar: HimoAppBar(title: 'My Vouchers'.tr('ကျွန်ုပ်၏ ကူပွန်များ')),"),
        ("_buildSubTab('active', 'Active (2)', isDark),", "_buildSubTab('active', '${'Active'.tr('လက်ရှိ')} (2)', isDark),"),
        ("_buildSubTab('used', 'Used (0)', isDark),", "_buildSubTab('used', '${'Used'.tr('သုံးပြီး')} (0)', isDark),"),
        ("_buildSubTab('expired', 'Expired (0)', isDark),", "_buildSubTab('expired', '${'Expired'.tr('သက်တမ်းကုန်')} (0)', isDark),"),
        ("const Text(\n                          'No vouchers found',", "Text(\n                          'No vouchers found'.tr('ကူပွန် မရှိသေးပါ'),"),
    ]
)

# 6. user_level_screen.dart
add_import_and_replace(
    'lib/features/profile/screens/user_level_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'User Tier Level'),", "appBar: HimoAppBar(title: 'User Tier Level'.tr('အသုံးပြုသူ အဆင့်')),"),
        ("const Text('CURRENT ACCOUNT LEVEL',", "Text('CURRENT ACCOUNT LEVEL'.tr('လက်ရှိ အကောင့်အဆင့်'),"),
        ("const Text('APPROVED',", "Text('APPROVED'.tr('အတည်ပြုပြီး'),"),
        ("const Text('Subscriber Level 2',", "Text('Subscriber Level 2'.tr('အဆင့် ၂ အသုံးပြုသူ'),"),
        ("const Text('Full KYC Identity Verified with Myanmar National ID',", "Text('Full KYC Identity Verified with Myanmar National ID'.tr('နိုင်ငံသားစိစစ်ရေးကတ်ပြားဖြင့် အပြည့်အဝ အတည်ပြုပြီး'),"),
        ("const Text('TIER LEVEL COMPARISON',", "Text('TIER LEVEL COMPARISON'.tr('အဆင့်အလိုက် ကန့်သတ်ချက်များ'),"),
    ]
)

# 7. limits_fees_screen.dart
add_import_and_replace(
    'lib/features/profile/screens/limits_fees_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Limits & Fees'),", "appBar: HimoAppBar(title: 'Limits & Fees'.tr('ကန့်သတ်ချက်နှင့် ဝန်ဆောင်ခ')),"),
        ("const Text('DAILY TRANSACTION LIMITS',", "Text('DAILY TRANSACTION LIMITS'.tr('နေ့စဉ် ငွေလွှဲ ကန့်သတ်ချက်များ'),"),
        ("const Text('FEE STRUCTURE HIGHLIGHTS',", "Text('FEE STRUCTURE HIGHLIGHTS'.tr('ဝန်ဆောင်ခ သတ်မှတ်ချက်များ'),"),
        ("_buildLimitRow('P2P Wallet Transfer',", "_buildLimitRow('P2P Wallet Transfer'.tr('ပိုက်ဆံအိတ်အချင်းချင်း ငွေလွှဲ'),"),
        ("_buildLimitRow('Bank Cash In / Deposit',", "_buildLimitRow('Bank Cash In / Deposit'.tr('ဘဏ်မှ ငွေသွင်း'),"),
        ("_buildLimitRow('Bank Cash Out',", "_buildLimitRow('Bank Cash Out'.tr('ဘဏ်သို့ ငွေထုတ်'),"),
        ("_buildLimitRow('ATM Cardless Withdrawal',", "_buildLimitRow('ATM Cardless Withdrawal'.tr('ATM ကတ်မဲ့ ငွေထုတ်'),"),
        ("_buildLimitRow('Merchant QR Payment',", "_buildLimitRow('Merchant QR Payment'.tr('ဆိုင်များတွင် QR ပေးချေ'),"),
        ("_buildLimitRow('Bill Payment & Top Up',", "_buildLimitRow('Bill Payment & Top Up'.tr('ဘေလ်ဆောင်နှင့် ဖုန်းငွေဖြည့်'),"),
    ]
)

# 8. referral_code_screen.dart
add_import_and_replace(
    'lib/features/profile/screens/referral_code_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Invite & Earn'),", "appBar: HimoAppBar(title: 'Invite & Earn'.tr('မိတ်ဆက်ပြီး ဆုယူမည်')),"),
        ("const Text(\n                    'Invite Friends, Earn Cash',", "Text(\n                    'Invite Friends, Earn Cash'.tr('သူငယ်ချင်းများကို ဖိတ်ခေါ်ပြီး ငွေသားဆု ရယူပါ'),"),
        ("'Referral code copied to clipboard!'", "'Referral code copied to clipboard!'.tr('မိတ်ဆက်ကုဒ်ကို ကူးယူပြီးပါပြီ!')"),
        ("text: 'Share Referral Link',", "text: 'Share Referral Link'.tr('ဖိတ်ခေါ်လင့်ခ် မျှဝေမည်'),"),
    ]
)

# 9. security_privacy_screen.dart
add_import_and_replace(
    'lib/features/profile/screens/security_privacy_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Security & Privacy'),", "appBar: HimoAppBar(title: 'Security & Privacy'.tr('လုံခြုံရေးနှင့် ကိုယ်ရေးအချက်အလက်')),"),
        ("const Text('AUTHENTICATION & PASSCODE',", "Text('AUTHENTICATION & PASSCODE'.tr('လုံခြုံရေးနှင့် လျှို့ဝှက်ကုဒ်'),"),
        ("const Text('Change 6-Digit Passcode',", "Text('Change 6-Digit Passcode'.tr('ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ် ပြောင်းမည်'),"),
        ("const Text('FaceID / Fingerprint Login',", "Text('FaceID / Fingerprint Login'.tr('FaceID / လက်ဗွေဖြင့် ဝင်ရောက်မည်'),"),
    ]
)

# 10. otp_settings_screen.dart
add_import_and_replace(
    'lib/features/profile/screens/otp_settings_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'OTP Settings'),", "appBar: HimoAppBar(title: 'OTP Settings'.tr('OTP ဆက်တင်များ')),"),
        ("const Text('PRIMARY OTP CHANNEL',", "Text('PRIMARY OTP CHANNEL'.tr('အဓိက OTP လက်ခံမည့် နည်းလမ်း'),"),
        ("const Text('AUTOFILL & CODES',", "Text('AUTOFILL & CODES'.tr('အလိုအလျောက် ဖြည့်စွက်ခြင်း'),"),
        ("const Text('Auto-Fill SMS Verification Codes',", "Text('Auto-Fill SMS Verification Codes'.tr('SMS စိစစ်ရေးကုဒ် အလိုအလျောက် ဖြည့်မည်'),"),
        ("text: 'Send Test Verification Code',", "text: 'Send Test Verification Code'.tr('စမ်းသပ် OTP ကုဒ် ပို့မည်'),"),
    ]
)

# 11. help_center_screen.dart
add_import_and_replace(
    'lib/features/profile/screens/help_center_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Help Center & FAQs'),", "appBar: HimoAppBar(title: 'Help Center & FAQs'.tr('အကူအညီနှင့် မေးလေ့ရှိသော မေးခွန်းများ')),"),
    ]
)

# 12. feedback_screen.dart
add_import_and_replace(
    'lib/features/profile/screens/feedback_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Feedback & Suggestions'),", "appBar: HimoAppBar(title: 'Feedback & Suggestions'.tr('အကြံပြုချက်နှင့် သုံးသပ်ချက်')),"),
        ("const Text('Rate Your Experience',", "Text('Rate Your Experience'.tr('အသုံးပြုမှု အတွေ့အကြုံကို အဆင့်သတ်မှတ်ပါ'),"),
        ("const Text('How satisfied are you with Himo Pay?',", "Text('How satisfied are you with Himo Pay?'.tr('Himo Pay အပေါ် မည်မျှ စိတ်ကျေနပ်မှု ရှိပါသလဲ?'),"),
        ("text: 'Submit Feedback',", "text: 'Submit Feedback'.tr('အကြံပြုချက် ပေးပို့မည်'),"),
    ]
)

# 13. about_himopay_screen.dart
add_import_and_replace(
    'lib/features/profile/screens/about_himopay_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'About Himo Pay'),", "appBar: HimoAppBar(title: 'About Himo Pay'.tr('Himo Pay အကြောင်း')),"),
        ("const Text('OFFICIAL LICENSING & REGULATION',", "Text('OFFICIAL LICENSING & REGULATION'.tr('တရားဝင် လိုင်စင်နှင့် ကြီးကြပ်ခွင့်ပြုချက်'),"),
        ("const Text('SECURITY & COMPLIANCE',", "Text('SECURITY & COMPLIANCE'.tr('လုံခြုံရေးနှင့် စံချိန်စံညွှန်းများ'),"),
    ]
)

# 14. points_history_screen.dart
add_import_and_replace(
    'lib/features/rewards/screens/points_history_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Points History'),", "appBar: HimoAppBar(title: 'Points History'.tr('ပွိုင့်မှတ်တမ်း')),"),
        ("const Text('TOTAL AVAILABLE POINTS',", "Text('TOTAL AVAILABLE POINTS'.tr('စုစုပေါင်း ရရှိထားသော ပွိုင့်'),"),
        ("const Text('POINTS ACTIVITY',", "Text('POINTS ACTIVITY'.tr('ပွိုင့် လှုပ်ရှားမှုမှတ်တမ်း'),"),
    ]
)

# 15. secret_shop_screen.dart
add_import_and_replace(
    'lib/features/rewards/screens/secret_shop_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Himo Secret Shop'),", "appBar: HimoAppBar(title: 'Himo Secret Shop'.tr('Himo လျှို့ဝှက် အရောင်းဆိုင်')),"),
    ]
)

# 16. voucher_detail_screen.dart
add_import_and_replace(
    'lib/features/rewards/screens/voucher_detail_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Voucher Details'),", "appBar: HimoAppBar(title: 'Voucher Details'.tr('ကူပွန် အသေးစိတ်')),"),
        ("const Text('TERMS OF USE',", "Text('TERMS OF USE'.tr('အသုံးပြုမှု စည်းကမ်းများ'),"),
        ("text: 'Redeem Voucher',", "text: 'Redeem Voucher'.tr('ကူပွန် ရယူမည်'),"),
    ]
)
