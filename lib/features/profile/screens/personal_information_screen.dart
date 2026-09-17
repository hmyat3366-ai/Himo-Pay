import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/localization/app_strings.dart';
import '../../../data/repositories/himo_repository.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  // User Profile Data
  late String _name;
  late String _phone;
  late String _userLevel;
  final String _userRank = 'Member';
  final String _gender = 'Male';
  final String _dob = '02/11/2002';
  final String _nrc = '12/MA GA DA(N)209006';

  // Employment Information
  String _occupation = '-';

  // Address
  String _province = 'Yangon';
  String _district = 'Yangon(East)';
  String _township = 'NorthOkkalapa';
  String _addressDetail = 'No30 Anawyahtar Str A Nan Pin';

  @override
  void initState() {
    super.initState();
    final user = HimoRepository().currentUser;
    _name = user.name;
    _phone = user.phone.isNotEmpty ? user.phone : '09950786548';
    _userLevel = user.tier;
  }

  void _editOccupationModal() {
    final controller = TextEditingController(text: _occupation == '-' ? '' : _occupation);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final presetOccupations = [
      'Software Engineer',
      'Student',
      'Private Company Staff',
      'Business Owner / Entrepreneur',
      'Freelancer',
      'Government Officer',
      'Teacher / Educator',
      'Healthcare Worker',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceElevatedDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Occupation'.tr('အလုပ်အကိုင် ပြင်ဆင်ရန်'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.gray900,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Occupation / Job Title'.tr('အလုပ်အကိုင် အမည်'),
                  hintText: 'e.g. Software Engineer'.tr('ဥပမာ - ဆော့ဖ်ဝဲလ်အင်ဂျင်နီယာ'),
                  border: OutlineInputBorder(borderRadius: AppRadius.cardBorder),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Suggestions:'.tr('အကြံပြုချက်များ:'),
                style: TextStyle(fontSize: 12, color: AppColors.gray500, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: presetOccupations.map((job) {
                  return ActionChip(
                    label: Text(job, style: const TextStyle(fontSize: 12)),
                    backgroundColor: isDark ? AppColors.surfaceCardDark : AppColors.gray100,
                    onPressed: () {
                      controller.text = job;
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorder),
                  ),
                  onPressed: () {
                    final val = controller.text.trim();
                    setState(() {
                      _occupation = val.isEmpty ? '-' : val;
                    });
                    Navigator.pop(ctx);
                    HimoToast.show(
                      context,
                      'Occupation updated successfully!'.tr('အလုပ်အကိုင် အချက်အလက် သိမ်းဆည်းပြီးပါပြီ'),
                    );
                  },
                  child: Text(
                    'Save'.tr('သိမ်းဆည်းမည်'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editAddressModal() {
    final provinceCtrl = TextEditingController(text: _province);
    final districtCtrl = TextEditingController(text: _district);
    final townshipCtrl = TextEditingController(text: _township);
    final detailCtrl = TextEditingController(text: _addressDetail);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceElevatedDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Address'.tr('နေရပ်လိပ်စာ ပြင်ဆင်ရန်'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.gray900,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: provinceCtrl,
                decoration: InputDecoration(
                  labelText: 'Province / State'.tr('တိုင်းဒေသကြီး / ပြည်နယ်'),
                  border: OutlineInputBorder(borderRadius: AppRadius.cardBorder),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: districtCtrl,
                decoration: InputDecoration(
                  labelText: 'District'.tr('ခရိုင်'),
                  border: OutlineInputBorder(borderRadius: AppRadius.cardBorder),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: townshipCtrl,
                decoration: InputDecoration(
                  labelText: 'Township'.tr('မြို့နယ်'),
                  border: OutlineInputBorder(borderRadius: AppRadius.cardBorder),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: detailCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Street Address'.tr('လမ်းအမည်နှင့် အိမ်အမှတ်'),
                  border: OutlineInputBorder(borderRadius: AppRadius.cardBorder),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorder),
                  ),
                  onPressed: () {
                    setState(() {
                      _province = provinceCtrl.text.trim();
                      _district = districtCtrl.text.trim();
                      _township = townshipCtrl.text.trim();
                      _addressDetail = detailCtrl.text.trim();
                    });
                    Navigator.pop(ctx);
                    HimoToast.show(
                      context,
                      'Address updated successfully!'.tr('နေရပ်လိပ်စာ အချက်အလက် သိမ်းဆည်းပြီးပါပြီ'),
                    );
                  },
                  child: Text(
                    'Save'.tr('သိမ်းဆည်းမည်'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeAvatarModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceElevatedDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                title: Text('Take New Photo'.tr('ကင်မရာဖြင့် ဓာတ်ပုံရိုက်မည်')),
                onTap: () {
                  Navigator.pop(ctx);
                  HimoToast.show(context, 'Profile picture updated successfully!'.tr('ပရိုဖိုင်ပုံ ပြောင်းလဲပြီးပါပြီ'));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                title: Text('Choose from Gallery'.tr('ဖုန်းထဲမှ ပုံရွေးချယ်မည်')),
                onTap: () {
                  Navigator.pop(ctx);
                  HimoToast.show(context, 'Profile picture updated successfully!'.tr('ပရိုဖိုင်ပုံ ပြောင်းလဲပြီးပါပြီ'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const accentEditColor = Color(0xFFC02644); // Signature crimson/wine edit color matching Image 2

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF4F6F9),
      appBar: HimoAppBar(
        title: 'Profile'.tr('ပရိုဖိုင်'),
        showBack: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // ── TOP USER CARD ──
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceCardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar with Camera Icon Overlay
                  GestureDetector(
                    onTap: _changeAvatarModal,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.white24 : AppColors.gray200,
                              width: 1.5,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/avatar_profile.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => const Icon(Icons.person, size: 36),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 13,
                              color: isDark ? Colors.white70 : AppColors.gray800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and Unmasked Phone
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            color: isDark ? Colors.white : AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _phone,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.gray400 : AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ── SECTION 1: PERSONAL INFORMATION ──
            _buildSectionHeader(
              title: 'Personal Information'.tr('ကိုယ်ရေးကိုယ်တာ အချက်အလက်'),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceCardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _buildInfoRow('User Level'.tr('အသုံးပြုသူ အဆင့်'), _userLevel, isDark),
                  _buildDivider(isDark),
                  _buildInfoRow('User Rank'.tr('အဆင့်အတန်း'), _userRank, isDark),
                  _buildDivider(isDark),
                  _buildInfoRow('Name'.tr('အမည်'), _name, isDark),
                  _buildDivider(isDark),
                  _buildInfoRow('Gender'.tr('ကျား/မ'), _gender, isDark),
                  _buildDivider(isDark),
                  _buildInfoRow('Date of birth'.tr('မွေးသက္ကရာဇ်'), _dob, isDark),
                  _buildDivider(isDark),
                  _buildInfoRow('NRC Number'.tr('မှတ်ပုံတင် အမှတ်'), _nrc, isDark),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ── SECTION 2: EMPLOYMENT INFORMATION ──
            _buildSectionHeader(
              title: 'Employment Information'.tr('လုပ်ငန်းဆိုင်ရာ အချက်အလက်'),
              actionText: 'Edit'.tr('ပြင်ဆင်မည်'),
              onAction: _editOccupationModal,
              actionColor: accentEditColor,
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceCardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _buildInfoRow('Occupation'.tr('အလုပ်အကိုင်'), _occupation, isDark),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ── SECTION 3: ADDRESS ──
            _buildSectionHeader(
              title: 'Address'.tr('နေရပ်လိပ်စာ'),
              actionText: 'Edit'.tr('ပြင်ဆင်မည်'),
              onAction: _editAddressModal,
              actionColor: accentEditColor,
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceCardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _buildInfoRow('Province'.tr('တိုင်းဒေသကြီး / ပြည်နယ်'), _province, isDark),
                  _buildDivider(isDark),
                  _buildInfoRow('District'.tr('ခရိုင်'), _district, isDark),
                  _buildDivider(isDark),
                  _buildInfoRow('Township'.tr('မြို့နယ်'), _township, isDark),
                  _buildDivider(isDark),
                  _buildInfoRow('Address'.tr('နေရပ်လိပ်စာ အပြည့်အစုံ'), _addressDetail, isDark),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? actionText,
    VoidCallback? onAction,
    Color? actionColor,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.gray400 : AppColors.gray600,
          ),
        ),
        if (actionText != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                actionText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: actionColor ?? const Color(0xFFC02644),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.gray400 : AppColors.gray800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 0.8,
      color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFEFF2F6),
    );
  }
}
