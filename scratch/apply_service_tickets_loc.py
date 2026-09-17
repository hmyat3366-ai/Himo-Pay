import re

def add_import_and_replace(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Add import if missing
    if "import '../../../core/localization/app_strings.dart';" not in content and 'app_strings.dart' not in content:
        # insert after first package:flutter import
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

# 1. events_browse_screen.dart
add_import_and_replace(
    'lib/features/services/screens/events_browse_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Events & Passes'),", "appBar: HimoAppBar(title: 'Events & Passes'.tr('ပွဲများနှင့် လက်မှတ်များ')),"),
        ("'Upcoming Concerts & Summits',", "'Upcoming Concerts & Summits'.tr('လာမည့် ပွဲများနှင့် ဖျော်ဖြေပွဲများ'),"),
        ("'Book e-passes instantly with contact-free QR check-in',", "'Book e-passes instantly with contact-free QR check-in'.tr('QR ကုဒ်ဖြင့် အလွယ်တကူ ဝင်ရောက်နိုင်သော e-လက်မှတ်များ ဝယ်ယူပါ'),"),
        ("Text('Book Pass',", "Text('Book Pass'.tr('လက်မှတ်ဝယ်မည်'),"),
    ]
)

# 2. events_detail_screen.dart
add_import_and_replace(
    'lib/features/services/screens/events_detail_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Event Booking'),", "appBar: HimoAppBar(title: 'Event Booking'.tr('ပွဲလက်မှတ် ဝယ်ယူရန်')),"),
        ("'Insufficient balance in wallet'", "'Insufficient balance in wallet'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ')"),
        ("'Just now'", "'Just now'.tr('ယခုလေးတင်')"),
        ("category: 'Event Ticket',", "category: 'Event Ticket'.tr('ပွဲလက်မှတ်'),"),
        ("title: '$title Ticket',", "title: '$title Ticket'.tr('$title လက်မှတ်'),"),
        ("const Text('SELECT PASS TIER',", "Text('SELECT PASS TIER'.tr('လက်မှတ်အမျိုးအစား ရွေးချယ်ပါ'),"),
        ("title: 'Standard Admission Pass',", "title: 'Standard Admission Pass'.tr('သာမန် ဝင်ခွင့်လက်မှတ်'),"),
        ("desc: 'Full conference keynote access & digital materials',", "desc: 'Full conference keynote access & digital materials'.tr('ဆွေးနွေးပွဲ အပြည့်အစုံ ဝင်ရောက်ခွင့်နှင့် ဒစ်ဂျစ်တယ် စာရွက်စာတမ်းများ'),"),
        ("title: 'VIP Priority Pass + Lounge',", "title: 'VIP Priority Pass + Lounge'.tr('VIP အထူးဝင်ခွင့်လက်မှတ် + Lounge'),"),
        ("desc: 'Front row seating, VIP networking lunch & speakers lounge',", "desc: 'Front row seating, VIP networking lunch & speakers lounge'.tr('ရှေ့ဆုံးတန်း ထိုင်ခုံ၊ VIP နေ့လယ်စာနှင့် ဧည့်သည်တော် Lounge'),"),
        ("const Text('Number of Tickets',", "Text('Number of Tickets'.tr('လက်မှတ် အရေအတွက်'),"),
        ("const Text('Total Payable',", "Text('Total Payable'.tr('စုစုပေါင်း ကျသင့်ငွေ'),"),
        ("text: 'Confirm Booking',", "text: 'Confirm Booking'.tr('လက်မှတ်ဝယ်ယူမှု အတည်ပြုမည်'),"),
    ]
)

# 3. events_success_screen.dart
add_import_and_replace(
    'lib/features/services/screens/events_success_screen.dart',
    [
        ("const Text(\n                'E-Ticket Confirmed!',", "Text(\n                'E-Ticket Confirmed!'.tr('E-လက်မှတ် ဝယ်ယူမှု အောင်မြင်ပါသည်!'),"),
        ("'Your pass is ready for check-in',", "'Your pass is ready for check-in'.tr('သင့်လက်မှတ်ကို စကင်ဖတ် ဝင်ရောက်နိုင်ပါပြီ'),"),
        ("_buildRow(context, 'Pass Tier',", "_buildRow(context, 'Pass Tier'.tr('လက်မှတ် အမျိုးအစား'),"),
        ("_buildRow(context, 'Total Amount',", "_buildRow(context, 'Total Amount'.tr('စုစုပေါင်း ကျသင့်ငွေ'),"),
        ("const Text('View in My Tickets'),", "Text('View in My Tickets'.tr('ကျွန်ုပ်၏ လက်မှတ်များတွင် ကြည့်မည်')),"),
        ("text: 'Done',", "text: 'Done'.tr('ပြီးပါပြီ'),"),
    ]
)

# 4. giftcards_catalog_screen.dart
add_import_and_replace(
    'lib/features/services/screens/giftcards_catalog_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Gift Cards'),", "appBar: HimoAppBar(title: 'Gift Cards'.tr('ဂိမ်းနှင့် လက်ဆောင်ကတ်များ')),"),
        ("'Digital Vouchers & Gift Cards',", "'Digital Vouchers & Gift Cards'.tr('ဒစ်ဂျစ်တယ် ကူပွန်များနှင့် လက်ဆောင်ကတ်များ'),"),
        ("'Instant digital redeem codes delivered directly to your wallet',", "'Instant digital redeem codes delivered directly to your wallet'.tr('ဝယ်ယူပြီးသည်နှင့် ဒစ်ဂျစ်တယ် ကုဒ်များကို ပိုက်ဆံအိတ်သို့ ချက်ချင်း ပေးပို့ပါသည်'),"),
        ("'Insufficient balance in wallet'", "'Insufficient balance in wallet'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ')"),
        ("'Just now'", "'Just now'.tr('ယခုလေးတင်')"),
    ]
)

# 5. giftcards_success_screen.dart
add_import_and_replace(
    'lib/features/services/screens/giftcards_success_screen.dart',
    [
        ("const Text(\n                'Digital Code Delivered!',", "Text(\n                'Digital Code Delivered!'.tr('ဒစ်ဂျစ်တယ် ကုဒ် ထုတ်ပေးပြီးပါပြီ!'),"),
        ("const Text('YOUR ACTIVATION CODE',", "Text('YOUR ACTIVATION CODE'.tr('သင့် အသုံးပြုရန် ကုဒ် (Activation Code)'),"),
        ("'Code copied to clipboard!'", "'Code copied to clipboard!'.tr('ကုဒ်ကို ကူးယူပြီးပါပြီ!')"),
        ("'Redeem this key in your account settings or official store.',", "'Redeem this key in your account settings or official store.'.tr('ဤကုဒ်ကို သက်ဆိုင်ရာ အကောင့် သို့မဟုတ် စတိုးတွင် ထည့်သွင်း အသုံးပြုနိုင်ပါသည်။'),"),
        ("const Text('Amount Paid',", "Text('Amount Paid'.tr('ပေးချေခဲ့သည့် ပမာဏ'),"),
        ("const Text('Back to Home'),", "Text('Back to Home'.tr('ပင်မစာမျက်နှာသို့')),"),
    ]
)

# 6. movies_listing_screen.dart
add_import_and_replace(
    'lib/features/services/screens/movies_listing_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Cinema & Movies'),", "appBar: HimoAppBar(title: 'Cinema & Movies'.tr('ရုပ်ရှင်နှင့် ရုပ်ရှင်ရုံများ')),"),
        ("_buildTab('Now Showing', 0, isDark),", "_buildTab('Now Showing'.tr('ရုံတင်ပြသနေဆဲ'), 0, isDark),"),
        ("_buildTab('Coming Soon', 1, isDark),", "_buildTab('Coming Soon'.tr('မကြာမီ လာမည်'), 1, isDark),"),
        ("const Text('Book Seats',", "Text('Book Seats'.tr('ထိုင်ခုံ ရွေးမည်'),"),
    ]
)

# 7. movies_seats_screen.dart
add_import_and_replace(
    'lib/features/services/screens/movies_seats_screen.dart',
    [
        ("'Please select at least one seat'", "'Please select at least one seat'.tr('ကျေးဇူးပြု၍ ထိုင်ခုံ အနည်းဆုံး တစ်ခု ရွေးပါ')"),
        ("'Insufficient balance in wallet'", "'Insufficient balance in wallet'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ')"),
        ("'Just now'", "'Just now'.tr('ယခုလေးတင်')"),
        ("const Center(\n                child: Text('CINEMA SCREEN',", "Center(\n                child: Text('CINEMA SCREEN'.tr('ရုပ်ရှင် ပိတ်ကား'),"),
        ("_buildLegend(AppColors.primaryGold, 'Selected'),", "_buildLegend(AppColors.primaryGold, 'Selected'.tr('ရွေးထားသည်')),"),
        ("_buildLegend(isDark ? AppColors.borderDark : AppColors.gray400, 'Available', isBorder: true),", "_buildLegend(isDark ? AppColors.borderDark : AppColors.gray400, 'Available'.tr('အားသည်'), isBorder: true),"),
        ("_buildLegend(isDark ? Colors.white12 : AppColors.gray300, 'Occupied'),", "_buildLegend(isDark ? Colors.white12 : AppColors.gray300, 'Occupied'.tr('လူပြည့်')),"),
        ("Text('Seats: ${\n                            _selectedSeats.isEmpty ? \"None\" : _selectedSeats.join(\", \")}',", "Text('${'Seats:'.tr('ထိုင်ခုံ:')} ${_selectedSeats.isEmpty ? 'None'.tr('မရွေးရသေးပါ') : _selectedSeats.join(', ')}',"),
        ("text: 'Confirm Booking • ${CurrencyFormatter.formatMMK(total)}',", "text: 'Confirm Booking • '.tr('လက်မှတ်ဝယ်ယူမည် • ') + CurrencyFormatter.formatMMK(total),"),
    ]
)

# 8. movies_success_screen.dart
add_import_and_replace(
    'lib/features/services/screens/movies_success_screen.dart',
    [
        ("const Text(\n                'Cinema Tickets Confirmed!',", "Text(\n                'Cinema Tickets Confirmed!'.tr('ရုပ်ရှင်လက်မှတ် ဝယ်ယူမှု အောင်မြင်ပါသည်!'),"),
        ("'Present this e-ticket at the cinema entrance',", "'Present this e-ticket at the cinema entrance'.tr('ရုပ်ရှင်ရုံ အဝင်ဝတွင် ဤ e-လက်မှတ်ကို ပြသပေးပါ'),"),
        ("Text('BOOKING CODE: $code',", "Text('${'BOOKING CODE:'.tr('ဘွတ်ကင်ကုဒ်:')} $code',"),
        ("_buildRow(context, 'Showtime', 'Today • $time'),", "_buildRow(context, 'Showtime'.tr('ရုပ်ရှင်ပြသမည့် အချိန်'), '${'Today • '.tr('ယနေ့ • ')}$time'),"),
        ("_buildRow(context, 'Seats Allocated', seats, isBold: true),", "_buildRow(context, 'Seats Allocated'.tr('ရရှိသော ထိုင်ခုံများ'), seats, isBold: true),"),
        ("_buildRow(context, 'Total Paid', CurrencyFormatter.formatMMK(total)),", "_buildRow(context, 'Total Paid'.tr('စုစုပေါင်း ကျသင့်ငွေ'), CurrencyFormatter.formatMMK(total)),"),
        ("const Text('View in My Tickets'),", "Text('View in My Tickets'.tr('ကျွန်ုပ်၏ လက်မှတ်များတွင် ကြည့်မည်')),"),
        ("text: 'Done',", "text: 'Done'.tr('ပြီးပါပြီ'),"),
    ]
)

# 9. insurance_plans_screen.dart
add_import_and_replace(
    'lib/features/services/screens/insurance_plans_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Micro-Insurance'),", "appBar: HimoAppBar(title: 'Micro-Insurance'.tr('အသေးစား အာမခံ')),"),
        ("'Affordable Protection Plans',", "'Affordable Protection Plans'.tr('သင့်တင့်မျှတသော အကာအကွယ် အစီအစဉ်များ'),"),
        ("'Peace of mind protection with paperless instant policy activation',", "'Peace of mind protection with paperless instant policy activation'.tr('စာရွက်စာတမ်း မလိုဘဲ ချက်ချင်း အကာအကွယ် ရယူနိုင်သော အာမခံများ'),"),
    ]
)

# 10. insurance_detail_screen.dart
add_import_and_replace(
    'lib/features/services/screens/insurance_detail_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Policy Details'),", "appBar: HimoAppBar(title: 'Policy Details'.tr('အာမခံ အသေးစိတ်')),"),
        ("'Insufficient balance in wallet'", "'Insufficient balance in wallet'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ')"),
        ("'Just now'", "'Just now'.tr('ယခုလေးတင်')"),
        ("Text('Underwritten by $underwriter',", "Text('${'Underwritten by '.tr('အာမခံပေးသူ: ')}$underwriter',"),
        ("const Text('COVERAGE SUMMARY',", "Text('COVERAGE SUMMARY'.tr('အာမခံ အကာအကွယ် အကျဉ်းချုပ်'),"),
        ("const Text('INSURED PERSON',", "Text('INSURED PERSON'.tr('အာမခံထားရှိသူ'),"),
        ("text: 'Activate Policy • ${CurrencyFormatter.formatMMK(premium)}',", "text: 'Activate Policy • '.tr('အာမခံ စတင်ရယူမည် • ') + CurrencyFormatter.formatMMK(premium),"),
    ]
)

# 11. insurance_success_screen.dart
add_import_and_replace(
    'lib/features/services/screens/insurance_success_screen.dart',
    [
        ("const Text(\n                'Policy Activated!',", "Text(\n                'Policy Activated!'.tr('အာမခံ အောင်မြင်စွာ ရယူပြီးပါပြီ!'),"),
        ("'Your insurance coverage is now active',", "'Your insurance coverage is now active'.tr('သင့်အာမခံ အကာအကွယ် စတင် အသက်ဝင်ပါပြီ'),"),
        ("_buildRow(context, 'Policy Number', policyNo),", "_buildRow(context, 'Policy Number'.tr('အာမခံ ပေါ်လစီ အမှတ်'), policyNo),"),
        ("_buildRow(context, 'Insured Member', user),", "_buildRow(context, 'Insured Member'.tr('အာမခံထားရှိသူ'), user),"),
        ("_buildRow(context, 'Coverage Period', '1 Year (Active immediately)'),", "_buildRow(context, 'Coverage Period'.tr('အကာအကွယ် သက်တမ်း'), '1 Year (Active immediately)'.tr('၁ နှစ် (ချက်ချင်း အသက်ဝင်သည်)')),"),
        ("_buildRow(context, 'Premium Paid', CurrencyFormatter.formatMMK(premium)),", "_buildRow(context, 'Premium Paid'.tr('ပေးသွင်းပြီး ပရီမီယံကြေး'), CurrencyFormatter.formatMMK(premium)),"),
        ("_buildRow(context, 'Policy Status', 'Active & Insured', valueColor: AppColors.success),", "_buildRow(context, 'Policy Status'.tr('အခြေအနေ'), 'Active & Insured'.tr('အာမခံ အကျုံးဝင်နေဆဲ'), valueColor: AppColors.success),"),
        ("text: 'Done',", "text: 'Done'.tr('ပြီးပါပြီ'),"),
    ]
)

# 12. my_tickets_screen.dart
add_import_and_replace(
    'lib/features/tickets/screens/my_tickets_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'My Tickets & Passes'),", "appBar: HimoAppBar(title: 'My Tickets & Passes'.tr('ကျွန်ုပ်၏ လက်မှတ်များ')),"),
        ("_buildTab('Active (${activeTickets.length})', 0, isDark),", "_buildTab('${'Active'.tr('လက်ရှိ')} (${activeTickets.length})', 0, isDark),"),
        ("_buildTab('Past / Used (${pastTickets.length})', 1, isDark),", "_buildTab('${'Past / Used'.tr('အသုံးပြုပြီး')} (${pastTickets.length})', 1, isDark),"),
        ("const Text('No tickets found',", "Text('No tickets found'.tr('လက်မှတ် မရှိသေးပါ'),"),
        ("Text(\n                                      isPast ? 'Used' : 'Valid',", "Text(\n                                      isPast ? 'Used'.tr('သုံးပြီး') : 'Valid'.tr('အသုံးပြုနိုင်'),"),
        ("const Text('View Pass',", "Text('View Pass'.tr('လက်မှတ် ကြည့်မည်'),"),
    ]
)

# 13. ticket_detail_screen.dart
add_import_and_replace(
    'lib/features/tickets/screens/ticket_detail_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Digital Pass'),", "appBar: HimoAppBar(title: 'Digital Pass'.tr('ဒစ်ဂျစ်တယ် လက်မှတ်')),"),
        ("ticket.type == TicketType.event ? 'OFFICIAL EVENT PASS' : 'CINEMA ENTRY PASS',", "ticket.type == TicketType.event ? 'OFFICIAL EVENT PASS'.tr('ပွဲ ဝင်ခွင့်လက်မှတ်') : 'CINEMA ENTRY PASS'.tr('ရုပ်ရှင်ရုံ ဝင်ခွင့်လက်မှတ်'),"),
        ("isPast ? 'USED' : 'VALID',", "isPast ? 'USED'.tr('အသုံးပြုပြီး') : 'VALID'.tr('အသုံးပြုနိုင်'),"),
        ("Text('Seat: ${ticket.seat}',", "Text('${'Seat:'.tr('ထိုင်ခုံ:')} ${ticket.seat}',"),
        ("const Text('Scan at turnstile or usher reader',", "Text('Scan at turnstile or usher reader'.tr('ဂိတ်ပေါက် သို့မဟုတ် တာဝန်ကျဝန်ထမ်းထံတွင် စကင်ဖတ်ပါ'),"),
        ("label: const Text('Add to Wallet'),", "label: Text('Add to Wallet'.tr('ပိုက်ဆံအိတ်သို့ ထည့်မည်')),"),
        ("'Pass added to Google Wallet'", "'Pass added to Google Wallet'.tr('လက်မှတ်ကို Google Wallet သို့ ထည့်ပြီးပါပြီ')"),
        ("text: 'Share Pass',", "text: 'Share Pass'.tr('လက်မှတ် မျှဝေမည်'),"),
        ("'Pass link ready to share'", "'Pass link ready to share'.tr('လက်မှတ်လင့်ခ်ကို မျှဝေရန် အဆင်သင့်ဖြစ်ပါပြီ')"),
    ]
)
