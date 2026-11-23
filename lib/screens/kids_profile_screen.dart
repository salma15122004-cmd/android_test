import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/child_profile.dart';
import '../services/service_locator.dart';
import '../utils/guarded_action.dart';
import '../widgets/app_snack_bar.dart';

class KidsProfileScreen extends StatefulWidget {
  const KidsProfileScreen({super.key});

  @override
  State<KidsProfileScreen> createState() => _KidsProfileScreenState();
}

class _KidsProfileScreenState extends State<KidsProfileScreen>
    with GuardedActionMixin {
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  String? _gender;
  int _selectedAvatar = 2; // الولد هو المختار في البداية

  final List<String> _avatars = [
    'assets_img/img.1.png',
    'assets_img/img.2.png',
    'assets_img/img.3.png',
    'assets_img/img.4.png',
    'assets_img/img.5.png',
    'assets_img/img.6.png',
  ];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 5),
      firstDate: DateTime(now.year - 18),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _continue() async {
    if (_nameController.text.trim().isEmpty ||
        _birthDate == null ||
        _gender == null) {
      showAppSnackBar(context, 'Please fill all fields');
      return;
    }

    final profile = ChildProfile(
      name: _nameController.text.trim(),
      birthDate: _birthDate!,
      gender: _gender!,
      avatarAsset: _avatars[_selectedAvatar],
    );

    // نقطة الاتصال مع قاعدة البيانات/الـ API: غيّر التنفيذ في service_locator.dart.
    final saved = await runGuarded(
      () => childProfileService.saveProfile(profile),
    );
    if (!saved || !mounted) return;
    showAppSnackBar(context, 'Child profile saved successfully.');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // العنوان وسهم الرجوع
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'Kids Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // الصورة الكبيرة مع زرار الكاميرا
              Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFDCEBFA),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _avatars[_selectedAvatar],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // نقطة ربط اختيار صورة من المعرض: أضف image_picker ثم خزّن
                        // رابط الصورة في ChildProfile بدل asset المحلي.
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // الحقول
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _FieldRow(
                      icon: Icons.person,
                      iconColor: Colors.purple,
                      label: 'Full Name',
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    _FieldRow(
                      icon: Icons.calendar_month,
                      iconColor: Colors.redAccent,
                      label: 'Age',
                      child: GestureDetector(
                        onTap: _pickDate,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _birthDate == null
                                    ? ''
                                    : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                              ),
                            ),
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _FieldRow(
                      icon: Icons.transgender,
                      iconColor: AppColors.blue,
                      label: 'Gender',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _gender,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                          ],
                          onChanged: (v) => setState(() => _gender = v),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // الجزء الأزرق السفلي
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3EFFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.navy)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: 190,
                            child: Text(
                              'Choose Your account picture',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.navy)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: List.generate(_avatars.length, (i) {
                        final selected = i == _selectedAvatar;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedAvatar = i),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.blue
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    _avatars[i],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.check,
                                    color: AppColors.navy,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 260,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: isBusy ? null : _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                        ),
                        child: isBusy
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// صف واحد: كارت الاسم على الشمال + خانة الإدخال على اليمين
class _FieldRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget child;

  const _FieldRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.child,
  });

  BoxDecoration _box(Color color) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: _box(Colors.white),
              child: Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: _box(const Color(0xFFF3F7FD)),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
