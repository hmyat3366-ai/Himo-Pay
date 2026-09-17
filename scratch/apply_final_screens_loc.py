import re

# 1. rewards_screen.dart
with open('lib/features/rewards/screens/rewards_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Add import if missing
if 'app_strings.dart' not in content:
    content = content.replace(
        "import '../../../data/repositories/himo_repository.dart';",
        "import '../../../data/repositories/himo_repository.dart';\nimport '../../../core/localization/app_strings.dart';"
    )

rewards_replacements = [
    ("title: Text(\n          'My Himo Points',", "title: Text(\n          'My Himo Points'.tr('ကျွန်ုပ်၏ Himo ရမှတ်များ'),"),
    ("label: Text(\n              'History',", "label: Text(\n              'History'.tr('မှတ်တမ်း'),"),
    ("title: 'Promo Vouchers',", "title: 'Promo Vouchers'.tr('ပရိုမိုးရှင်း ဘောက်ချာများ'),"),
    ("tag: 'POINTS DISCOUNT',", "tag: 'POINTS DISCOUNT'.tr('ရမှတ် လျှော့စျေး'),"),
    ("desc: 'Redeem your points for dining, shopping & brand discount vouchers up to 50% OFF.',", "desc: 'Redeem your points for dining, shopping & brand discount vouchers up to 50% OFF.'.tr('ရမှတ်များဖြင့် စားသောက်ဆိုင်၊ ဈေးဝယ်နှင့် အမှတ်တံဆိပ် ၅၀% အထိ လျှော့စျေး ဘောက်ချာများ လဲလှယ်ပါ'),"),
    ("title: 'Secret Shop',", "title: 'Secret Shop'.tr('လျှို့ဝှက် အရောင်းဆိုင်'),"),
    ("tag: 'VIP EXCLUSIVE',", "tag: 'VIP EXCLUSIVE'.tr('VIP သီးသန့်'),"),
    ("desc: 'Exclusive high-tier member perks, limited gifts & rare physical rewards.',", "desc: 'Exclusive high-tier member perks, limited gifts & rare physical rewards.'.tr('အဆင့်မြင့် အသင်းဝင်များအတွက် သီးသန့်ခံစားခွင့်၊ ကန့်သတ်လက်ဆောင်များနှင့် လက်ဆောင်ပစ္စည်းများ'),"),
    ("const Text(\n                    'Latest Rewards',", "Text(\n                    'Latest Rewards'.tr('နောက်ဆုံးရ ရမှတ်ဆုများ'),"),
    ("child: Text(\n                      'See all',", "child: Text(\n                      'See all'.tr('အားလုံးကြည့်ရန်'),"),
    ("!isLocked ? 'CURRENT TIER' : 'LOCKED',", "!isLocked ? 'CURRENT TIER'.tr('လက်ရှိအဆင့်') : 'LOCKED'.tr('မဖွင့်သေးပါ'),"),
    ("!isLocked\n                                ? 'Tier Progress'\n                                : 'Next Tier Requirement: ${t['nextPts']} Pts',", "!isLocked\n                                ? 'Tier Progress'.tr('အဆင့်တက်ရန် တိုးတက်မှု')\n                                : '${'Next Tier Requirement: '.tr('နောက်အဆင့် လိုအပ်ချက် - ')}${t['nextPts']} Pts',"),
    ("label: 'Details',", "label: 'Details'.tr('အသေးစိတ်'),"),
    ("label: 'Benefits',", "label: 'Benefits'.tr('ခံစားခွင့်များ'),"),
    ("Text(\n                '${t['name']} VIP Tier Privileges',", "Text(\n                '${t['name']} ${'VIP Tier Privileges'.tr('VIP အဆင့် အထူးအခွင့်အရေးများ')}',"),
    ("_modalInfoRow('Status', !isLocked ? 'Active Tier' : 'Locked', isDark, accent: accent),", "_modalInfoRow('Status'.tr('အခြေအနေ'), !isLocked ? 'Active Tier'.tr('လက်ရှိအဆင့်') : 'Locked'.tr('မဖွင့်သေးပါ'), isDark, accent: accent),"),
    ("_modalInfoRow('Unlock Requirement', '${t['nextPts']} Himo Points', isDark),", "_modalInfoRow('Unlock Requirement'.tr('ဖွင့်ရန် လိုအပ်ချက်'), '${t['nextPts']} ${'Himo Points'.tr('Himo ရမှတ်')}', isDark),"),
    ("_modalInfoRow('Transfer Fee Discount', (t['progress'] as double) > 0.5 ? '100% Free' : '50% Off', isDark),", "_modalInfoRow('Transfer Fee Discount'.tr('ငွေလွှဲခ လျှော့စျေး'), (t['progress'] as double) > 0.5 ? '100% Free'.tr('၁၀၀% အခမဲ့') : '50% Off'.tr('၅၀% လျှော့'), isDark),"),
    ("_modalInfoRow('Voucher Redemptions', 'Unlimited Access', isDark),", "_modalInfoRow('Voucher Redemptions'.tr('ဘောက်ချာ လဲလှယ်မှု'), 'Unlimited Access'.tr('အကန့်အသတ်မရှိ'), isDark),"),
    ("child: Text(\n                        'All Benefits',", "child: Text(\n                        'All Benefits'.tr('ခံစားခွင့် အားလုံး'),"),
    ("child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w700)),", "child: Text('Close'.tr('ပိတ်မည်'), style: const TextStyle(fontWeight: FontWeight.w700)),"),
    ("'Valid until ${r['validUntil']}'", "'${'Valid until'.tr('သက်တမ်းကုန်ဆုံးရက်')} ${r['validUntil']}'"),
    ("const Text(\n                    'Points',", "Text(\n                    'Points'.tr('ရမှတ်'),"),
]

for old, new in rewards_replacements:
    if old in content:
        content = content.replace(old, new)
    else:
        print(f"rewards_screen.dart: '{old[:30]}' not found")

with open('lib/features/rewards/screens/rewards_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated rewards_screen.dart")

# 2. promo_vouchers_screen.dart
with open('lib/features/rewards/screens/promo_vouchers_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

if 'app_strings.dart' not in content:
    content = content.replace(
        "import '../../../core/widgets/himo_app_bar.dart';",
        "import '../../../core/widgets/himo_app_bar.dart';\nimport '../../../core/localization/app_strings.dart';"
    )

promo_replacements = [
    ("title: 'Promo Vouchers',", "title: 'Promo Vouchers'.tr('ပရိုမိုးရှင်း ဘောက်ချာများ'),"),
    ("label: Text(\n              'My Vouchers',", "label: Text(\n              'My Vouchers'.tr('ကျွန်ုပ်၏ ဘောက်ချာများ'),"),
    ("hintText: 'Search',", "hintText: 'Search'.tr('ရှာဖွေမည်'),"),
    ("Text(\n                          'No vouchers found',", "Text(\n                          'No vouchers found'.tr('ဘောက်ချာ မရှိသေးပါ'),"),
    ("child: Text(\n                                'See all',", "child: Text(\n                                'See all'.tr('အားလုံးကြည့်ရန်'),"),
    ("'Valid until ${v['validUntil']}'", "'${'Valid until'.tr('သက်တမ်းကုန်ဆုံးရက်')} ${v['validUntil']}'"),
    ("const Text(\n                    'Points',", "Text(\n                    'Points'.tr('ရမှတ်'),"),
]

for old, new in promo_replacements:
    if old in content:
        content = content.replace(old, new)
    else:
        print(f"promo_vouchers_screen.dart: '{old[:30]}' not found")

with open('lib/features/rewards/screens/promo_vouchers_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated promo_vouchers_screen.dart")

# 3. home_screen.dart
with open('lib/features/home/screens/home_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

home_replacements = [
    ("Text(\n                '10% Instant Cashback',", "Text(\n                '10% Instant Cashback'.tr('၁၀% ချက်ချင်း ငွေပြန်အမ်း'),"),
    ("Text(\n                'Pay with Himo QR at over 500 partner cafés.',", "Text(\n                'Pay with Himo QR at over 500 partner cafés.'.tr('မိတ်ဖက်ကော်ဖီဆိုင် ၅၀၀ ကျော်တွင် Himo QR ဖြင့် ပေးချေပါ'),"),
    ("title: 'History',", "title: 'History'.tr('မှတ်တမ်း'),"),
    ("title: \"What's Up\",", "title: \"What's Up\".tr('သတင်းနှင့် ပရိုမိုးရှင်း'),"),
    ("Text(\n                  'Recent History',", "Text(\n                  'Recent History'.tr('မကြာသေးမီက မှတ်တမ်း'),"),
    ("child: Text(\n                      'See all',", "child: Text(\n                      'See all'.tr('အားလုံးကြည့်ရန်'),"),
    ("Text(\n                  \"What's Up & Promotions\",", "Text(\n                  \"What's Up & Promotions\".tr('သတင်းနှင့် ပရိုမိုးရှင်းများ'),"),
    ("child: const Text(\n                    '3 Updates',", "child: Text(\n                    '3 Updates'.tr('သတင်း ၃ ခု'),"),
    ("_buildReceiptDetailRow('Transaction ID', tx.id, isDark);", "_buildReceiptDetailRow('Transaction ID'.tr('လုပ်ငန်းစဉ် အမှတ်'), tx.id, isDark);"),
    ("_buildReceiptDetailRow('Status', 'Completed', isDark, isStatus: true);", "_buildReceiptDetailRow('Status'.tr('အခြေအနေ'), 'Completed'.tr('အောင်မြင်သည်'), isDark, isStatus: true);"),
    ("_buildReceiptDetailRow('Date & Time', tx.date, isDark);", "_buildReceiptDetailRow('Date & Time'.tr('ရက်စွဲနှင့် အချိန်'), tx.date, isDark);"),
    ("_buildReceiptDetailRow('Fee', '0 MMK', isDark);", "_buildReceiptDetailRow('Fee'.tr('ဝန်ဆောင်ခ'), '0 MMK', isDark);"),
    ("child: Text(\n                        'Share Receipt',", "child: Text(\n                        'Share Receipt'.tr('ပြေစာ မျှဝေမည်'),"),
    ("child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700)),", "child: Text('Done'.tr('ပြီးပါပြီ'), style: const TextStyle(fontWeight: FontWeight.w700)),"),
    ("HimoToast.show(context, 'Receipt downloaded successfully');", "HimoToast.show(context, 'Receipt downloaded successfully'.tr('ပြေစာ သိမ်းဆည်းပြီးပါပြီ'));"),
]

for old, new in home_replacements:
    if old in content:
        content = content.replace(old, new)
    else:
        print(f"home_screen.dart: '{old[:30]}' not found")

with open('lib/features/home/screens/home_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated home_screen.dart")

# 4. profile_screen.dart
with open('lib/features/profile/screens/profile_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

profile_replacements = [
    ("badge: 'Online',", "badge: 'Online'.tr('အွန်လိုင်း'),"),
]

for old, new in profile_replacements:
    if old in content:
        content = content.replace(old, new)
    else:
        print(f"profile_screen.dart: '{old[:30]}' not found")

with open('lib/features/profile/screens/profile_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated profile_screen.dart")
