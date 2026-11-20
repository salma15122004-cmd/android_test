import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/home_card.dart';
import '../widgets/quick_link_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  // هنبقا نضيف ontap لكل شاشة موجودة في الهوم لما نعملهم
  final List<HomeItem> _items = const [
    HomeItem(
      title: "Child's Profile",
      subtitle: "Track the child's condition and development",
      image: 'assets_img/img.1png',
      color: cardBlue,
      circleImage: true,
    ),
    HomeItem(
      title: 'Doctors',
      subtitle: 'Choose your suitable doctor',
      image: 'assets_img/doctor2.png',
      color: pink,
      circleImage: true,
    ),
    HomeItem(
      title: 'Games',
      subtitle: 'Interactive games to develop communication skills',
      image: 'assets_img/game.png',
      color: cream,
    ),
    HomeItem(
      title: "Child's Assessment",
      subtitle: "Easily assess your child's skills",
      image: 'assets_img/list.png',
      secondimage:'assets_img/boy2.png',
      color: lightGray,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          const _HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const _HomeSearchBar(),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.05,
                    ),
                    itemBuilder: (_, i) => HomeCard(item: _items[i]),
                  ),
                  const SizedBox(height: 16),
                  const _HomeBanner(),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuickLinkItem(icon: Icons.info_outline, label: 'About Us'),
                      QuickLinkItem(icon: Icons.star, label: 'Favorites'),
                      QuickLinkItem(icon: Icons.article, label: 'Useful Articles'),
                      QuickLinkItem(icon: Icons.headset_mic, label: 'Contact Us'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

// ---------------- الهيدر ----------------
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardBlue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset('assets_img/logo.png', width: 50),
                  const SizedBox(height: 4),
                  Image.asset('assets_img/kid1.png', width: 90),
                ],
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '"Together, we give every child a chance to communicate and express themselves."',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: teal,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  const Icon(Icons.notifications_none, color: blue, size: 28),
                  Positioned(
                    top: 2,
                    right: 3,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- شريط البحث ----------------
class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: const TextStyle(color: grayBlue),
        prefixIcon: const Icon(Icons.search, color: blue),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: _border(blue),
        enabledBorder: _border(blue),
        focusedBorder: _border(navy),
      ),
    );
  }
}

// ---------------- البانر ----------------
class _HomeBanner extends StatelessWidget {
  const _HomeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
            child: Image.asset('assets_img/banner.png',
                width: 120, height: 110, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 12),
              child: Text(
                'Every word ....is a big step because communication is the key to their world',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}