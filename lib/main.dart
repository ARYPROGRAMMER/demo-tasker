import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calls App',
      theme: ThemeData(
        fontFamily: "MuMedium",
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 1;
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];
  final List<Animation<double>> _scaleAnimations = [];

  final List<Widget> _screens = [
    const Center(child: Text('Messages')),
    const CallsScreen(),
    const ContactsScreen(),
    const Center(child: Text('Video')),
  ];

  final List<String> _labels = ['Messages', 'Calls', 'Contacts', 'Setting'];
  final List<String> _iconPaths = [
    "assets/svgs/message.svg",
    "assets/svgs/phone.svg",
    "assets/svgs/contact.svg",
    "assets/svgs/setting.svg",
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));

      final scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 1.15,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));

      _controllers.add(controller);
      _animations.add(animation);
      _scaleAnimations.add(scaleAnimation);
    }
    _controllers[_selectedIndex].forward();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      _controllers[_selectedIndex].reverse();
      _controllers[index].forward();
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 95,
        decoration: const BoxDecoration(
          color: Color(0xFF282A3E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 75,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: AnimatedBuilder(
                      animation: _animations[index],
                      builder: (context, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(0, _animations[index].value * -10),
                              child: Transform.scale(
                                scale: _scaleAnimations[index].value,
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: SvgPicture.asset(
                                    _iconPaths[index],
                                    color: _selectedIndex == index
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: _animations[index].value * 2),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _animations[index].value,
                              child: Text(
                                _labels[index],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController _searchController = TextEditingController();
    String _searchQuery = "";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xfa9F2ffa),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      'assets/svgs/bgthread.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 20,
                      bottom: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Calls',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(8),
                            child:
                                CircleAvatar(
                                    backgroundColor: Colors.white.withOpacity(0.2),
                                    child: SvgPicture.asset("assets/svgs/call-add.svg"))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(14),
                      child: SvgPicture.asset(
                        "assets/svgs/search.svg",
                        width: 20,
                        height: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/svgs/phone.svg",
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Recent Calls',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: _buildRecentCalls(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecentCalls() {
    final calls = [
      {
        'name': 'Mike',
        'time': 'Today, 09:30 AM',
        'missed': false,
        'path': 'assets/images/mike.png'
      },
      {
        'name': 'Jassica',
        'time': 'Today, 09:30 AM',
        'missed': false,
        'path': 'assets/images/jessica.png'
      },
      {
        'name': 'Harvey',
        'time': 'Today, 09:30 AM',
        'missed': true,
        'path': 'assets/images/harvey.png'
      },
      {
        'name': 'Ross',
        'time': 'Today, 09:30 AM',
        'missed': true,
        'path': 'assets/images/ross.png'
      },
      {
        'name': 'Alex',
        'time': 'Today, 09:30 AM',
        'missed': false,
        'path': 'assets/images/alex.png'
      },
    ];

    return calls
        .map(
          (call) => CallTile(
            name: call['name'] as String,
            time: call['time'] as String,
            missed: call['missed'] as bool,
            path: call['path'] as String,
          ),
        )
        .toList();
  }
}

class CallTile extends StatelessWidget {
  final String name;
  final String time;
  final bool missed;
  final String path;

  const CallTile(
      {super.key,
      required this.name,
      required this.time,
      required this.missed,
      required this.path});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Image.asset(path,),
          title: Text(
            name,
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Row(
            children: [
              missed
                  ? SvgPicture.asset(
                      "assets/svgs/call-incoming.svg",
                      width: 16,
                      height: 16,
                    )
                  : SvgPicture.asset(
                      "assets/svgs/call-outgoing.svg",
                      width: 16,
                      height: 16,
                    ),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'MuLight', fontWeight: FontWeight.w600),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                  child: SvgPicture.asset(
                "assets/svgs/phone.svg",
                width: 24,
                height: 24,
              )),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                  child: SvgPicture.asset(
                "assets/svgs/video.svg",
                width: 24,
                height: 24,
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Map<String, GlobalKey> _letterKeys = {};
  String _searchQuery = '';
  bool _isScrolling = false;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').forEach((letter) {
      _letterKeys[letter] = GlobalKey();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        setState(() => _isScrolling = true);
        _scrollTimer?.cancel();
        _scrollTimer = Timer(const Duration(seconds: 2), () {
          setState(() => _isScrolling = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _scrollToLetter(String letter) {
    final key = _letterKeys[letter];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _highlightText(String text, String query) {
    if (query.isEmpty) return Text(text);

    final matches = query
        .toLowerCase()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();

    List<TextSpan> spans = [];
    String remaining = text;

    for (var match in matches) {
      int index = remaining.toLowerCase().indexOf(match);
      while (index != -1) {
        if (index > 0) {
          spans.add(TextSpan(text: remaining.substring(0, index)));
        }
        spans.add(TextSpan(
          text: remaining.substring(index, index + match.length),
          style: const TextStyle(
            backgroundColor: Color(0xff9F2fff),
            fontWeight: FontWeight.bold,
          ),
        ));
        remaining = remaining.substring(index + match.length);
        index = remaining.toLowerCase().indexOf(match);
      }
    }

    if (remaining.isNotEmpty) {
      spans.add(TextSpan(text: remaining));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        children: spans,
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _getAllContacts() {
    final contacts = [
      {
        'name': 'Alex',
        'status': "Unless I'm myself, I'm nobody",
        'isOnline': true,
        'avatarColor': const Color(0xFFFFE0B2),
        'avatarAsset': 'assets/images/alex.png',
      },
      {
        'name': 'Harvey',
        'status': 'Living the dream',
        'isOnline': true,
        'avatarColor': const Color(0xFFBBDEFB),
        'avatarAsset': 'assets/images/harvey.png',
      },
      {
        'name': 'Jassica',
        'status': 'Busy working',
        'isOnline': false,
        'avatarColor': const Color(0xFFE1BEE7),
        'avatarAsset': 'assets/images/jessica.png',
      },
      {
        'name': 'Mike',
        'status': 'Available for chat',
        'isOnline': true,
        'avatarColor': const Color(0xFFC8E6C9),
        'avatarAsset': 'assets/images/mike.png',
      },
      {
        'name': 'Ross',
        'status': 'In a meeting',
        'isOnline': false,
        'avatarColor': const Color(0xFFFFE0B2),
        'avatarAsset': 'assets/images/ross.png',
      },
    ];

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      contacts.removeWhere((contact) =>
          !contact['name'].toString().toLowerCase().contains(query));
    }

    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final contact in contacts) {
      final letter = (contact['name'] as String)[0].toUpperCase();
      grouped.putIfAbsent(letter, () => []).add(contact);
    }

    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contacts = _getAllContacts();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xfa9F2ffa),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        'assets/svgs/bgthread.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 20,
                        bottom: 24,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Contacts',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(8),
                              child: CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: SvgPicture.asset(
                                    "assets/svgs/person-add.svg"),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(14),
                                child: SvgPicture.asset(
                                  "assets/svgs/search.svg",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svgs/contact.svg",
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'All Contacts',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "MuBold",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final letter = contacts.keys.elementAt(index);
                          final letterContacts = contacts[letter]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                key: _letterKeys[letter],
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  top: 12,
                                  bottom: 8,
                                ),
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 18,
                                    fontFamily: "MuBold",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ...letterContacts.map((contact) => ContactTile(
                                    contact: contact,
                                    searchQuery: _searchQuery,
                                    highlightText: _highlightText,
                                  )),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isScrolling)
            Positioned(
              right: 4,
              top: 200,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: contacts.keys
                      .map((letter) => GestureDetector(
                            onTap: () => _scrollToLetter(letter),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Center(
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
        ],
      )),
    );
  }
}

class ContactTile extends StatelessWidget {
  final Map<String, dynamic> contact;
  final String searchQuery;
  final Widget Function(String, String) highlightText;

  const ContactTile({
    super.key,
    required this.contact,
    required this.searchQuery,
    required this.highlightText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: contact['avatarColor'] as Color,
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(contact['avatarAsset'] as String),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (contact['isOnline'] as bool)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                highlightText(contact['name'] as String, searchQuery),
                if (contact['status'].toString().isNotEmpty)
                  Text(
                    contact['status'] as String,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                  child: SvgPicture.asset(
                "assets/svgs/phone.svg",
                width: 22,
                height: 22,
              )),
              const SizedBox(
                width: 18,
              ),
              InkWell(
                  child: SvgPicture.asset(
                "assets/svgs/message.svg",
                width: 22,
                height: 22,
                    color: Colors.black,
              ))
            ],
          ),
        ],
      ),
    );
  }
}
