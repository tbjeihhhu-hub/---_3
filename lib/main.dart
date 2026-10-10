import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const QudatAlRubApp());

const ownerName = 'علاوي ال حمادي';

class QudatAlRubApp extends StatelessWidget {
  const QudatAlRubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'قعدة الربع',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8C4D2F),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF171A19),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF202D29), Color(0xFF171A19), Color(0xFF352319)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.casino_rounded, size: 70, color: Color(0xFFFFC56D)),
                  const SizedBox(height: 12),
                  const Text('قعدة الربع', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Color(0xFFFFD18A))),
                  const SizedBox(height: 8),
                  const Text('دومنة وضحك ومشاكل على الطاولة!', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, color: Colors.white70)),
                  const SizedBox(height: 28),
                  const _CharacterStrip(),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        backgroundColor: const Color(0xFFB86D3C),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('ابدأ أول مرحلة', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen())),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('النسخة التجريبية الأولى • اللعب ضد الكمبيوتر',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 22),
                  const Divider(color: Colors.white24),
                  const Text('© جميع الحقوق محفوظة', style: TextStyle(color: Colors.white70)),
                  const Text(ownerName, style: TextStyle(color: Color(0xFFFFD18A), fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CharacterStrip extends StatelessWidget {
  const _CharacterStrip();

  @override
  Widget build(BuildContext context) {
    final characters = [
      ('🐂', 'الثور', 'عصبي'),
      ('🐒', 'القرد', 'مشاغب'),
      ('🫏', 'الحمار', 'يتفلسف'),
      ('🐄', 'البقرة', 'هادئة'),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: characters.map((c) => Container(
        width: 132,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.07),
          border: Border.all(color: const Color(0xFFB86D3C).withOpacity(.6)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(children: [
          Text(c.$1, style: const TextStyle(fontSize: 35)),
          const SizedBox(height: 5),
          Text(c.$2, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(c.$3, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        ]),
      )).toList(),
    );
  }
}

class Domino {
  final int a;
  final int b;
  bool used;
  Domino(this.a, this.b, {this.used = false});
  int get points => a + b;
  @override
  String toString() => '$a|$b';
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random random = Random();
  late List<Domino> playerHand;
  late List<Domino> botHand;
  final List<Domino> board = [];
  int level = 1;
  int playerScore = 0;
  int botScore = 0;
  String message = 'يلا نشوف شطارتك! اختار حجر من إيدك.';
  String character = '🐂 الثور';
  bool gameOver = false;
  bool playerTurn = true;

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  List<Domino> _makeSet() {
    final all = <Domino>[];
    for (int a = 0; a <= 6; a++) {
      for (int b = a; b <= 6; b++) {
        all.add(Domino(a, b));
      }
    }
    all.shuffle(random);
    return all;
  }

  void _newRound() {
    final all = _makeSet();
    playerHand = all.take(7).toList();
    botHand = all.skip(7).take(7).toList();
    board.clear();
    gameOver = false;
    playerTurn = true;
    character = level == 1 ? '🐂 الثور' : level == 2 ? '🐒 القرد' : '🫏 الحمار';
    message = level == 1
        ? 'الثور: «ها يمعود، ورّيني لعبك بس لا تغش!»'
        : level == 2
            ? 'القرد: «هالمرة أفوز عليكم وأضحك للصبح!»'
            : 'الحمار: «تره آني مخطط لكل حركة!»';
    setState(() {});
  }

  bool _canPlay(Domino d) {
    if (board.isEmpty) return true;
    return d.a == board.first.a || d.b == board.first.a ||
        d.a == board.last.b || d.b == board.last.b;
  }

  void _playPlayer(Domino d) {
    if (gameOver || !playerTurn) return;
    if (!_canPlay(d)) {
      setState(() => message = 'ما يركب هذا الحجر هسه! جرّب حجر ثاني.');
      return;
    }
    setState(() {
      if (board.isEmpty) {
        board.add(d);
      } else if (d.b == board.last.b) {
        board.add(Domino(d.b, d.a));
      } else if (d.a == board.last.b) {
        board.add(d);
      } else if (d.a == board.first.a) {
        board.insert(0, Domino(d.b, d.a));
      } else {
        board.insert(0, d);
      }
      playerHand.remove(d);
      playerTurn = false;
      message = 'زين! هسه نشوف شيرد الكمبيوتر.';
    });
    if (playerHand.isEmpty) {
      _finishRound(true);
      return;
    }
    Future.delayed(const Duration(milliseconds: 650), _botMove);
  }

  void _botMove() {
    if (!mounted || gameOver) return;
    final playable = botHand.where(_canPlay).toList()
      ..sort((x, y) => y.points.compareTo(x.points));
    setState(() {
      if (playable.isNotEmpty) {
        final d = playable.first;
        if (board.isEmpty) {
          board.add(d);
        } else if (d.a == board.last.b) {
          board.add(d);
        } else if (d.b == board.last.b) {
          board.add(Domino(d.b, d.a));
        } else if (d.b == board.first.a) {
          board.insert(0, d);
        } else {
          board.insert(0, Domino(d.b, d.a));
        }
        botHand.remove(d);
        message = level == 1
            ? 'الثور: «هااا! شفتوا الحجر شلون؟»'
            : level == 2
                ? 'القرد: «هاها، هاي حركة ذكية!»'
                : 'الحمار: «مثل ما متوقع بالضبط!»';
      } else {
        message = '$character ما عنده حجر يركب، الدور إلك.';
      }
      playerTurn = true;
    });
    if (botHand.isEmpty) {
      _finishRound(false);
    } else if (!_hasAnyMove(playerHand) && !_hasAnyMove(botHand)) {
      _finishBlocked();
    }
  }

  bool _hasAnyMove(List<Domino> hand) => hand.any(_canPlay);

  void _finishRound(bool playerWon) {
    setState(() {
      gameOver = true;
      if (playerWon) {
        playerScore += 1;
        message = 'فزت بالجولة! $character: «لااا، مو معقولة!»';
      } else {
        botScore += 1;
        message = '$character فاز هالمرة! «بعدك تتعلم يمعود!»';
      }
    });
  }

  void _finishBlocked() {
    final p = playerHand.fold<int>(0, (sum, d) => sum + d.points);
    final b = botHand.fold<int>(0, (sum, d) => sum + d.points);
    setState(() {
      gameOver = true;
      if (p <= b) {
        playerScore++;
        message = 'انسد اللعب، بس نقاطك أقل! الجولة إلك.';
      } else {
        botScore++;
        message = 'انسد اللعب ونقاط $character أقل. فاز هالمرة!';
      }
    });
  }

  void _nextLevel() {
    setState(() {
      level++;
      if (level > 3) level = 1;
    });
    _newRound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قعدة الربع'),
        backgroundColor: const Color(0xFF202D29),
        actions: [
          IconButton(tooltip: 'إعادة الجولة', onPressed: _newRound, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF2A3C34), borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                const Text('🎭', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('المرحلة $level • الخصم: $character', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(message, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ])),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('إنت: $playerScore', style: const TextStyle(color: Color(0xFFFFD18A), fontWeight: FontWeight.bold)),
                Text('الخصم: $botScore', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              ]),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: const Color(0xFF31523F),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF9C6B43), width: 5),
                boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 5))],
              ),
              child: board.isEmpty
                  ? const Center(child: Text('طاولة الدومنة\nنزّل أول حجر!', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.white70, fontWeight: FontWeight.bold)))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: board.map((d) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: _DominoTile(domino: d, compact: true),
                        )).toList(),
                      )),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                const Text('إيدك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${playerHand.length} أحجار', style: const TextStyle(color: Colors.white60)),
              ]),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: playerHand.map((d) => InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _playPlayer(d),
                    child: Opacity(
                      opacity: gameOver || !playerTurn ? .55 : 1,
                      child: _DominoTile(domino: d),
                    ),
                  )).toList(),
                ),
              ),
            ),
            if (gameOver)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(children: [
                  Expanded(child: OutlinedButton.icon(
                    onPressed: _newRound,
                    icon: const Icon(Icons.replay),
                    label: const Text('إعادة الجولة'),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: FilledButton.icon(
                    onPressed: _nextLevel,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('المرحلة التالية'),
                  )),
                ]),
              ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('© علاوي ال حمادي', style: TextStyle(color: Colors.white38, fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DominoTile extends StatelessWidget {
  final Domino domino;
  final bool compact;
  const _DominoTile({required this.domino, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final width = compact ? 38.0 : 54.0;
    final height = compact ? 70.0 : 94.0;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD5B98A), width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 2))],
      ),
      child: Column(children: [
        Expanded(child: Center(child: Text('${domino.a}', style: TextStyle(
          color: const Color(0xFF25231F), fontWeight: FontWeight.w900, fontSize: compact ? 20 : 26)))),
        Container(height: 1.5, color: const Color(0xFFBDA77F)),
        Expanded(child: Center(child: Text('${domino.b}', style: TextStyle(
          color: const Color(0xFF25231F), fontWeight: FontWeight.w900, fontSize: compact ? 20 : 26)))),
      ]),
    );
  }
}