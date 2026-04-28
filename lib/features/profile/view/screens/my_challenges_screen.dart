import 'package:adcc/features/challenges/models/challenge_model.dart';
import 'package:adcc/features/challenges/repositories/challenges_repository.dart';
import 'package:adcc/features/profile/view/sections/my_challenges/challenge_card.dart';
import 'package:flutter/material.dart';


class MyChallengesScreen extends StatefulWidget {
  const MyChallengesScreen({super.key});

  @override
  State<MyChallengesScreen> createState() => _MyChallengesScreenState();
}

class _MyChallengesScreenState extends State<MyChallengesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ChallengesRepository _challengesRepository = ChallengesRepository();

  bool _isLoading = true;
  String? _errorMessage;
  List<ChallengeModel> _challenges = const [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadChallenges();
  }

  @override
  void dispose() {
    _tabController.dispose(); 
    super.dispose();
  }

  Future<void> _loadChallenges() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final challenges = await _challengesRepository.fetchChallenges();
      if (!mounted) return;
      setState(() {
        _challenges = challenges;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  List<ChallengeModel> _filterByTab(int index) {
    final status = switch (index) {
      0 => 'completed',
      1 => 'upcoming',
      _ => 'cancelled',
    };

    return _challenges
        .where((challenge) => challenge.status == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6EFE6),
    appBar: AppBar(
  backgroundColor: const Color(0xffF6EFE6),
  elevation: 0,
  centerTitle: true,


  leading: Padding(
    padding: const EdgeInsets.only(left: 12),
    child: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color(0xffE8B4B0), 
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Color(0xffC62828), 
          size: 20,
        ),
      ),
    ),
  ),

  title: const Text(
  "My challenges",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: 'Outfit',
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1,
    letterSpacing: 0,
  ),
),

  bottom: PreferredSize(
  preferredSize: const Size.fromHeight(48),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 9.5),
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [

        /// Grey base line
        Container(
          height: 2,
          color: Colors.black.withOpacity(0.5),
        ),

        /// TabBar
        TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFC12D32),
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: const Color(0xFFC12D32),
          unselectedLabelColor: const Color(0xFF8E8E8E),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          tabs: const [
            Tab(text: "Completed"),
            Tab(text: "Upcoming"),
            Tab(text: "Cancelled"),
          ],
        ),
      ],
    ),
  ),
),
),


      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ChallengeList(challenges: _filterByTab(0)),
                      ChallengeList(challenges: _filterByTab(1)),
                      ChallengeList(challenges: _filterByTab(2)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class ChallengeList extends StatelessWidget {
  final List<ChallengeModel> challenges;

  const ChallengeList({super.key, required this.challenges});

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return const Center(child: Text('No challenges found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      itemCount: challenges.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ChallengeCard(
          title: challenge.title,
          description: challenge.description,
          image: challenge.image,
          status: challenge.status.toUpperCase(),
          progressText: '${challenge.progress} / ${challenge.target} ${challenge.unit}',
          progress: challenge.target == 0 ? 0 : challenge.progress / challenge.target,
          daysLeft: '${challenge.daysLeft} days left',
          participants: '${challenge.participants}',
        );
      },
    );
  }
}