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

# 1. transfer_recipient_screen.dart
add_import_and_replace(
    'lib/features/transfer/screens/transfer_recipient_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Transfer Money'),", "appBar: HimoAppBar(title: 'Transfer Money'.tr('ငွေလွှဲမည်')),"),
        ("hintText: 'Enter name or mobile number (09...)',", "hintText: 'Enter name or mobile number (09...)'.tr('အမည် သို့မဟုတ် ဖုန်းနံပါတ် ရိုက်ထည့်ပါ (09...)'),"),
        ("const Text('Recent Recipients',", "Text('Recent Recipients'.tr('မကြာသေးမီက လွှဲခဲ့သူများ'),"),
        ("text: 'Next',", "text: 'Next'.tr('ရှေ့သို့'),"),
    ]
)

# 2. transfer_amount_screen.dart
add_import_and_replace(
    'lib/features/transfer/screens/transfer_amount_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Transfer Amount'),", "appBar: HimoAppBar(title: 'Transfer Amount'.tr('ငွေလွှဲပမာဏ')),"),
        ("Text('Sending to $name',", "Text('${'Sending to '.tr('လွှဲပို့မည့်သူ: ')}$name',"),
        ("const Text('Enter Amount (MMK)',", "Text('Enter Amount (MMK)'.tr('ငွေပမာဏ ရိုက်ထည့်ပါ (ကျပ်)'),"),
        ("Text(\n                'Available Wallet Balance: ${wallet.formattedBalance}',", "Text(\n                '${'Available Wallet Balance: '.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ: ')}${wallet.formattedBalance}',"),
        ("text: 'Review Transfer',", "text: 'Review Transfer'.tr('ငွေလွှဲအချက်အလက် စစ်ဆေးမည်'),"),
    ]
)

# 3. transfer_review_screen.dart
add_import_and_replace(
    'lib/features/transfer/screens/transfer_review_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Review Transfer'),", "appBar: HimoAppBar(title: 'Review Transfer'.tr('ငွေလွှဲအချက်အလက် စစ်ဆေးပါ')),"),
        ("const Text('Total Amount to Transfer',", "Text('Total Amount to Transfer'.tr('စုစုပေါင်း လွှဲပြောင်းမည့်ငွေ'),"),
        ("_buildReviewRow('Recipient Name', name),", "_buildReviewRow('Recipient Name'.tr('လက်ခံသူ အမည်'), name),"),
        ("_buildReviewRow('Mobile Number', phone),", "_buildReviewRow('Mobile Number'.tr('ဖုန်းနံပါတ်'), phone),"),
        ("_buildReviewRow('Transfer Fee', '0 MMK (Free)', isHighlight: true),", "_buildReviewRow('Transfer Fee'.tr('ငွေလွှဲခ ဝန်ဆောင်ခ'), '0 MMK (Free)'.tr('၀ ကျပ် (အခမဲ့)'), isHighlight: true),"),
        ("_buildReviewRow('Total Payment', CurrencyFormatter.formatMMK(amount)),", "_buildReviewRow('Total Payment'.tr('စုစုပေါင်း ပေးချေငွေ'), CurrencyFormatter.formatMMK(amount)),"),
        ("text: 'Confirm & Enter PIN',", "text: 'Confirm & Enter PIN'.tr('အတည်ပြုပြီး PIN ရိုက်ထည့်မည်'),"),
    ]
)

# 4. transfer_security_screen.dart
add_import_and_replace(
    'lib/features/transfer/screens/transfer_security_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Enter PIN'),", "appBar: HimoAppBar(title: 'Enter PIN'.tr('PIN ရိုက်ထည့်ပါ')),"),
        ("const Text(\n              'Authorize Payment',", "Text(\n              'Authorize Payment'.tr('ငွေပေးချေမှုကို အတည်ပြုပါ'),"),
        ("Text(\n              'Enter 6-digit payment PIN to transfer ${CurrencyFormatter.formatMMK(amount)}',", "Text(\n              '${'Enter 6-digit payment PIN to transfer '.tr('ငွေလွှဲရန် ဂဏန်း ၆ လုံး PIN ကုဒ် ရိုက်ထည့်ပါ: ')}${CurrencyFormatter.formatMMK(amount)}',"),
    ]
)

# 5. transfer_success_screen.dart
add_import_and_replace(
    'lib/features/transfer/screens/transfer_success_screen.dart',
    [
        ("const Text(\n                'Transfer Successful!',", "Text(\n                'Transfer Successful!'.tr('ငွေလွှဲခြင်း အောင်မြင်ပါသည်!'),"),
        ("text: 'View E-Receipt',", "text: 'View E-Receipt'.tr('ပြေစာ ကြည့်မည်'),"),
        ("text: 'Back to Home',", "text: 'Back to Home'.tr('ပင်မစာမျက်နှာသို့'),"),
    ]
)

# 6. transfer_receipt_screen.dart
add_import_and_replace(
    'lib/features/transfer/screens/transfer_receipt_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Transaction E-Receipt'),", "appBar: HimoAppBar(title: 'Transaction E-Receipt'.tr('ငွေလွှဲပြေစာ (E-Receipt)')),"),
        ("const Text('Official Payment Receipt',", "Text('Official Payment Receipt'.tr('တရားဝင် ငွေပေးချေမှု ပြေစာ'),"),
        ("const Text('Payment Successful ✓',", "Text('Payment Successful ✓'.tr('ငွေပေးချေမှု အောင်မြင်သည် ✓'),"),
        ("_buildReceiptItem('Recipient', name),", "_buildReceiptItem('Recipient'.tr('ငွေလက်ခံသူ'), name),"),
        ("_buildReceiptItem('Mobile', phone),", "_buildReceiptItem('Mobile'.tr('ဖုန်းနံပါတ်'), phone),"),
        ("_buildReceiptItem('Transfer Fee', '0 MMK (Free)'),", "_buildReceiptItem('Transfer Fee'.tr('ငွေလွှဲခ'), '0 MMK (Free)'.tr('၀ ကျပ် (အခမဲ့)')),"),
        ("_buildReceiptItem('Date & Time', '15 Sep 2026, 11:00 AM'),", "_buildReceiptItem('Date & Time'.tr('ရက်စွဲနှင့် အချိန်'), '15 Sep 2026, 11:00 AM'),"),
        ("_buildReceiptItem('Transaction ID', 'HM-TX-9941829'),", "_buildReceiptItem('Transaction ID'.tr('ငွေလွှဲ ID'), 'HM-TX-9941829'),"),
        ("text: 'Save E-Receipt to Gallery',", "text: 'Save E-Receipt to Gallery'.tr('ပြေစာကို ဓာတ်ပုံထဲ သိမ်းမည်'),"),
        ("'Receipt saved to Photo Gallery'", "'Receipt saved to Photo Gallery'.tr('ပြေစာကို ဓာတ်ပုံထဲ သိမ်းဆည်းပြီးပါပြီ')"),
        ("text: 'Back to Home',", "text: 'Back to Home'.tr('ပင်မစာမျက်နှာသို့'),"),
    ]
)

# 7. cashin_methods_screen.dart
add_import_and_replace(
    'lib/features/cash_in/screens/cashin_methods_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Cash In (Top Up)'),", "appBar: HimoAppBar(title: 'Cash In (Top Up)'.tr('ငွေသွင်းမည်')),"),
    ]
)

# 8. cashin_amount_screen.dart
add_import_and_replace(
    'lib/features/cash_in/screens/cashin_amount_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Deposit Amount'),", "appBar: HimoAppBar(title: 'Deposit Amount'.tr('ငွေသွင်းပမာဏ')),"),
        ("Text('Method: $method',", "Text('${'Method: '.tr('နည်းလမ်း: ')}$method',"),
        ("const Text('Enter Deposit Amount (MMK)',", "Text('Enter Deposit Amount (MMK)'.tr('သွင်းမည့် ငွေပမာဏ ရိုက်ထည့်ပါ (ကျပ်)'),"),
        ("const Text('Minimum: 1,000 MMK • Fee: 0 MMK (Free)',", "Text('Minimum: 1,000 MMK • Fee: 0 MMK (Free)'.tr('အနည်းဆုံး: ၁,၀၀၀ ကျပ် • ဝန်ဆောင်ခ: အခမဲ့'),"),
        ("text: 'Confirm Cash In',", "text: 'Confirm Cash In'.tr('ငွေသွင်းမှုကို အတည်ပြုမည်'),"),
    ]
)

# 9. cashin_success_screen.dart
add_import_and_replace(
    'lib/features/cash_in/screens/cashin_success_screen.dart',
    [
        ("const Text(\n                'Deposit Successful!',", "Text(\n                'Deposit Successful!'.tr('ငွေသွင်းခြင်း အောင်မြင်ပါသည်!'),"),
        ("'Funds have been added to your wallet balance',", "'Funds have been added to your wallet balance'.tr('သင့်ပိုက်ဆံအိတ်ထဲသို့ ငွေဖြည့်သွင်းပြီးပါပြီ'),"),
        ("_buildRow(context, 'Payment Method', method),", "_buildRow(context, 'Payment Method'.tr('ငွေပေးချေသည့် နည်းလမ်း'), method),"),
        ("_buildRow(context, 'Transaction Ref', txId),", "_buildRow(context, 'Transaction Ref'.tr('လွှဲပြောင်းမှု အမှတ်'), txId),"),
        ("_buildRow(context, 'Fee', 'Free (0 MMK)'),", "_buildRow(context, 'Fee'.tr('ဝန်ဆောင်ခ'), 'Free (0 MMK)'.tr('အခမဲ့ (၀ ကျပ်)')),"),
        ("_buildRow(context, 'Status', 'Completed', valueColor: AppColors.success),", "_buildRow(context, 'Status'.tr('အခြေအနေ'), 'Completed'.tr('အောင်မြင်သည်'), valueColor: AppColors.success),"),
        ("text: 'Done',", "text: 'Done'.tr('ပြီးပါပြီ'),"),
    ]
)

# 10. cashout_methods_screen.dart
add_import_and_replace(
    'lib/features/cash_out/screens/cashout_methods_screen.dart',
    [
        ("appBar: const HimoAppBar(title: 'Cash Out Options'),", "appBar: HimoAppBar(title: 'Cash Out Options'.tr('ငွေထုတ်မည့် နည်းလမ်းများ')),"),
        ("'Select Withdrawal Method',", "'Select Withdrawal Method'.tr('ငွေထုတ်မည့် နည်းလမ်း ရွေးချယ်ပါ'),"),
        ("'Withdraw money securely from your Himo wallet',", "'Withdraw money securely from your Himo wallet'.tr('သင့် Himo ပိုက်ဆံအိတ်မှ ငွေကို စိတ်ချလုံခြုံစွာ ထုတ်ယူပါ'),"),
    ]
)

# 11. cashout_amount_screen.dart
add_import_and_replace(
    'lib/features/cash_out/screens/cashout_amount_screen.dart',
    [
        ("appBar: HimoAppBar(title: 'Cash Out - $method'),", "appBar: HimoAppBar(title: '${'Cash Out'.tr('ငွေထုတ်မည်')} - $method'),"),
        ("'Withdrawal Amount (MMK)',", "'Withdrawal Amount (MMK)'.tr('ထုတ်ယူမည့် ငွေပမာဏ (ကျပ်)'),"),
        ("const Text('Cash Out Fee (0.2%)',", "Text('Cash Out Fee (0.2%)'.tr('ငွေထုတ် ဝန်ဆောင်ခ (၀.၂%)'),"),
        ("const Text('Total Deduction',", "Text('Total Deduction'.tr('စုစုပေါင်း နုတ်ယူငွေ'),"),
        ("text: 'Confirm Cash Out',", "text: 'Confirm Cash Out'.tr('ငွေထုတ်ယူမှု အတည်ပြုမည်'),"),
    ]
)

# 12. cashout_success_screen.dart
add_import_and_replace(
    'lib/features/cash_out/screens/cashout_success_screen.dart',
    [
        ("const Text(\n                'Withdrawal Request Sent!',", "Text(\n                'Withdrawal Request Sent!'.tr('ငွေထုတ်ယူခွင့် တောင်းဆိုပြီးပါပြီ!'),"),
        ("'Funds are being processed to $method',", "'Funds are being processed to $method'.tr('$method သို့ ငွေလွှဲပြောင်း ဆောင်ရွက်နေပါသည်'),"),
        ("_buildRow(context, 'Destination', method),", "_buildRow(context, 'Destination'.tr('လွှဲပြောင်းမည့် နေရာ'), method),"),
        ("_buildRow(context, 'Transaction Ref', txId),", "_buildRow(context, 'Transaction Ref'.tr('လွှဲပြောင်းမှု အမှတ်'), txId),"),
        ("_buildRow(context, 'Processing Fee', CurrencyFormatter.formatMMK(fee)),", "_buildRow(context, 'Processing Fee'.tr('ဝန်ဆောင်ခ'), CurrencyFormatter.formatMMK(fee)),"),
        ("_buildRow(context, 'Total Deducted', CurrencyFormatter.formatMMK(total)),", "_buildRow(context, 'Total Deducted'.tr('စုစုပေါင်း နုတ်ယူငွေ'), CurrencyFormatter.formatMMK(total)),"),
        ("_buildRow(context, 'Status', 'Processing', valueColor: AppColors.primaryGold),", "_buildRow(context, 'Status'.tr('အခြေအနေ'), 'Processing'.tr('ဆောင်ရွက်နေဆဲ'), valueColor: AppColors.primaryGold),"),
        ("text: 'Done',", "text: 'Done'.tr('ပြီးပါပြီ'),"),
    ]
)

# 13. scan_payment_success_screen.dart
add_import_and_replace(
    'lib/features/qr/screens/scan_payment_success_screen.dart',
    [
        ("const Text(\n                'Payment Successful!',", "Text(\n                'Payment Successful!'.tr('ငွေပေးချေမှု အောင်မြင်ပါသည်!'),"),
        ("'+$points Points Added',", "'+$points ${'Points Added'.tr('ပွိုင့် ရရှိသည်')}',"),
        ("_buildRow(context, 'Merchant', merchant),", "_buildRow(context, 'Merchant'.tr('ဆိုင်အမည်'), merchant),"),
        ("_buildRow(context, 'Branch / Table', branch),", "_buildRow(context, 'Branch / Table'.tr('ဆိုင်ခွဲ / စားပွဲ'), branch),"),
        ("_buildRow(context, 'Transaction Ref', txId),", "_buildRow(context, 'Transaction Ref'.tr('လွှဲပြောင်းမှု အမှတ်'), txId),"),
        ("_buildRow(context, 'Payment Method', 'Himo Debit Wallet'),", "_buildRow(context, 'Payment Method'.tr('ပေးချေသည့် နည်းလမ်း'), 'Himo Debit Wallet'.tr('Himo ပိုက်ဆံအိတ်')),"),
        ("_buildRow(context, 'Status', 'Completed', valueColor: AppColors.success),", "_buildRow(context, 'Status'.tr('အခြေအနေ'), 'Completed'.tr('အောင်မြင်သည်'), valueColor: AppColors.success),"),
        ("text: 'Done',", "text: 'Done'.tr('ပြီးပါပြီ'),"),
    ]
)

# 14. scan_qr_screen.dart
add_import_and_replace(
    'lib/features/qr/screens/scan_qr_screen.dart',
    [
        ("const Text(\n          'Scan QR Code',", "Text(\n          'Scan QR Code'.tr('QR ကုဒ် စကင်ဖတ်ပါ'),"),
        ("const Text(\n              'Align merchant or personal QR code inside frame',", "Text(\n              'Align merchant or personal QR code inside frame'.tr('ဆိုင် သို့မဟုတ် မိတ်ဆွေ၏ QR ကုဒ်ကို ဘောင်အတွင်း ထားပါ'),"),
        ("const Text('Enter Merchant ID',", "Text('Enter Merchant ID'.tr('ဆိုင် ID ရိုက်ထည့်ပါ'),"),
        ("const Text('Cancel',", "Text('Cancel'.tr('မလုပ်တော့ပါ'),"),
        ("const Text('Proceed',", "Text('Proceed'.tr('ဆက်လုပ်မည်'),"),
        ("const Text(\n                      'Enter QR / Merchant ID Manually',", "Text(\n                      'Enter QR / Merchant ID Manually'.tr('QR / ဆိုင် ID ကိုယ်တိုင် ရိုက်ထည့်မည်'),"),
    ]
)
