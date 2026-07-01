import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/controllers/game_view_controller.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/screens/qr_code_screen.dart';

const int kMinPlayers = 4;
const int kMaxPlayers = 10;
const int kDefaultPlayers = 6;

const int kMinWerewolves = 1;

const int kMinDiscussion = 10;
const int kMaxDiscussion = 120;
const int kDefaultDiscussion = 30;
const int kDiscussionStep = 10;

class RoleOption {
  final Role? role;
  final String label;
  final bool comingSoon;

  const RoleOption({this.role, required this.label, this.comingSoon = false});
}

const List<RoleOption> kRoleOptions = [
  RoleOption(role: Role.SEER, label: 'Seher'),
  RoleOption(role: Role.WITCH, label: 'Hexe'),
  RoleOption(role: Role.CUPID, label: 'Amor'),
  RoleOption(role: Role.HUNTER, label: 'Jäger'),
  RoleOption(role: Role.FOX, label: 'Fuchs'),
  RoleOption(role: Role.SABOTEUR, label: 'Saboteur'),
];

class CreateGame extends StatefulWidget {
  const CreateGame({super.key});

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  int _players = kDefaultPlayers;
  int _werewolves = _recommendedWerewolves(kDefaultPlayers);
  int _discussionLength = kDefaultDiscussion;

  final Set<int> _activeRoles = {};

  bool _creating = false;

  int get _maxWerewolves => math.max(kMinWerewolves, _players ~/ 3);

  int get _activeSpecialCount => _activeRoles.length;

  int get _villagers => _players - _werewolves - _activeSpecialCount;

  bool get _isValid => _werewolves >= kMinWerewolves && _villagers >= 0;

  static int _recommendedWerewolves(int players) =>
      math.max(kMinWerewolves, (players / 4).round());

  int get _recMin => math.max(kMinWerewolves, (_players / 4).round());

  int get _recMax => math.max(_recMin, _players ~/ 3);

  void _changePlayers(int delta) {
    final next = (_players + delta).clamp(kMinPlayers, kMaxPlayers);
    setState(() {
      _players = next;
      // keep the werewolf count inside its (player-dependent) bounds
      _werewolves = _werewolves.clamp(kMinWerewolves, _maxWerewolves);
    });
  }

  void _changeWerewolves(int delta) {
    setState(() {
      _werewolves = (_werewolves + delta).clamp(kMinWerewolves, _maxWerewolves);
    });
  }

  void _changeDiscussion(int delta) {
    setState(() {
      _discussionLength =
          (_discussionLength + delta).clamp(kMinDiscussion, kMaxDiscussion);
    });
  }

  void _toggleRole(int index, bool value) {
    setState(() {
      if (value) {
        _activeRoles.add(index);
      } else {
        _activeRoles.remove(index);
      }
    });
  }

  Future<void> _createLobby() async {
    setState(() => _creating = true);

    final settings = LobbySettings()
      ..maxPlayers = _players
      ..discussionTimeSeconds = _discussionLength
      ..roles.add(RoleCount()
        ..role = Role.WEREWOLF
        ..count = _werewolves);

    for (final index in _activeRoles) {
      final role = kRoleOptions[index].role;
      if (role != null) {
        settings.roles.add(RoleCount()
          ..role = role
          ..count = 1);
      }
    }

    if (_villagers > 0) {
      settings.roles.add(RoleCount()
        ..role = Role.VILLAGER
        ..count = _villagers);
    }

    final lobbyCode = await GameViewController.createLobby(settings);

    if (!mounted) return;
    setState(() => _creating = false);

    if (lobbyCode != null) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              QRCodeScreen(lobbyCode: lobbyCode, requiredPlayers: _players),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lobby konnte nicht erstellt werden. Bitte erneut versuchen.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.onPrimaryContainer;
    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Spiel erstellen",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 80,
        leading: Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white60,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/back.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                  // extra bottom padding so the last card can scroll clear of
                  // the fade and isn't permanently hidden behind it
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Spieleranzahl
                      _buildStepperCard(
                        label: "Spieleranzahl",
                        valueText: "$_players",
                        onMinus: _players > kMinPlayers
                            ? () => _changePlayers(-1)
                            : null,
                        onPlus: _players < kMaxPlayers
                            ? () => _changePlayers(1)
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // 3. Werwölfe
                      _buildStepperCard(
                        label: "Werwölfe",
                        valueText: "$_werewolves",
                        onMinus: _werewolves > kMinWerewolves
                            ? () => _changeWerewolves(-1)
                            : null,
                        onPlus: _werewolves < _maxWerewolves
                            ? () => _changeWerewolves(1)
                            : null,
                        subtitle:
                            "empfohlen: $_recMin–$_recMax bei $_players Spielern",
                      ),
                      const SizedBox(height: 16),

                      // 4. Sonderrollen
                      _buildRolesSection(),
                      const SizedBox(height: 16),

                      // 6. Diskussionslänge
                      _buildStepperCard(
                        label: "Diskussionslänge",
                        valueText: "$_discussionLength s",
                        onMinus: _discussionLength > kMinDiscussion
                            ? () => _changeDiscussion(-kDiscussionStep)
                            : null,
                        onPlus: _discussionLength < kMaxDiscussion
                            ? () => _changeDiscussion(kDiscussionStep)
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // 7. Aufstellungs-Vorschau
                      _buildLineupPreview(),
                    ],
                  ),
                ),
                    // soft fade so the scrollable settings dissolve into the
                    // background just above the button instead of cutting off
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                bgColor.withOpacity(0.0),
                                bgColor,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // invalid hint
              if (!_isValid)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _invalidHint(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 13,
                    ),
                  ),
                ),

              // 8. Lobby erstellen
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isValid && !_creating) ? _createLobby : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    // lift the button above the scrolling content
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _creating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          "Lobby erstellen",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _invalidHint() {
    if (_werewolves < kMinWerewolves) return "Mindestens 1 Werwolf nötig";
    return "Zu viele Rollen für $_players Spieler";
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _buildStepperCard({
    required String label,
    required String valueText,
    required VoidCallback? onMinus,
    required VoidCallback? onPlus,
    String? subtitle,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              _stepperPill(value: valueText, onMinus: onMinus, onPlus: onPlus),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _stepperPill({
    required String value,
    required VoidCallback? onMinus,
    required VoidCallback? onPlus,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pillButton(Icons.remove, onMinus),
          Container(width: 1, height: 20, color: Colors.grey),
          SizedBox(
            width: 48,
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Container(width: 1, height: 20, color: Colors.grey),
          _pillButton(Icons.add, onPlus),
        ],
      ),
    );
  }

  Widget _pillButton(IconData icon, VoidCallback? onTap) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: enabled ? Colors.black : Colors.black26,
        ),
      ),
    );
  }

  // 4. Sonderrollen header + fixed-height scrollable toggle list
  Widget _buildRolesSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sonderrollen",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                "$_activeSpecialCount aktiv",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: ListView.separated(
              itemCount: kRoleOptions.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.black.withOpacity(0.08)),
              itemBuilder: (context, index) {
                final option = kRoleOptions[index];
                return _buildRoleRow(index, option);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleRow(int index, RoleOption option) {
    final disabled = option.comingSoon;
    final color = disabled ? Colors.black38 : Colors.black87;
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  option.label,
                  style: TextStyle(
                    fontSize: 15,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (option.comingSoon) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "bald",
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ),
              ],
            ],
          ),
        ),
        Switch(
          value: _activeRoles.contains(index),
          onChanged: disabled ? null : (v) => _toggleRole(index, v),
          activeColor: Colors.black87,
        ),
      ],
    );
  }

  // 7. Aufstellungs-Box
  Widget _buildLineupPreview() {
    final assigned =
        _werewolves + _activeSpecialCount + math.max(0, _villagers);

    final chips = <Widget>[
      _lineupChip("Werwölfe ×$_werewolves"),
      for (final index in _activeRoles) _lineupChip(kRoleOptions[index].label),
      if (_villagers > 0) _lineupChip("Dorfbewohner ×$_villagers"),
    ];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Aufstellung",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                "$assigned von $_players verteilt",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips,
          ),
        ],
      ),
    );
  }

  Widget _lineupChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
