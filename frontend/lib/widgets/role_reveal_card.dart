import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/utils/role_display.dart';

class RoleRevealCard extends StatefulWidget {
  final Widget? revealChild;

  final double revealThreshold;

  /// This player's role; selects which card artwork is shown when revealed.
  final Role role;

  const RoleRevealCard({
    super.key,
    this.revealChild,
    this.revealThreshold = 110,
    this.role = Role.ROLE_UNSPECIFIED,
  });

  @override
  State<RoleRevealCard> createState() => _RoleRevealCardState();
}

const double _revealCardWidth = 280;
const double _revealCardHeight = 412;

class _RoleRevealCardState extends State<RoleRevealCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bobController;
  late final Animation<double> _bob;

  OverlayEntry? _overlay;
  double _dragDy = 0;
  bool _dragging = false;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _bob = Tween<double>(begin: 0.0, end: -16.0).animate(
      CurvedAnimation(parent: _bobController, curve: Curves.easeInOut),
    );
    _bobController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _removeOverlay();
    _bobController.dispose();
    super.dispose();
  }

  void _insertOverlay() {
    if (_overlay != null) return;
    _overlay = OverlayEntry(
      builder: (context) => IgnorePointer(
        child: Stack(
          children: [
            // darken everything behind the card once it is actually revealed
            if (_revealed)
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.75)),
              ),
            Center(
              child: _revealed ? _buildRevealCard() : _buildHintTarget(),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _onPanStart(DragStartDetails _) {
    _dragDy = 0;
    setState(() {
      _dragging = true;
      _revealed = false;
    });
    // show hint as soon as the drag begins
    _insertOverlay();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _dragDy += details.delta.dy;
    final shouldReveal = -_dragDy >= widget.revealThreshold;
    if (shouldReveal != _revealed) {
      setState(() => _revealed = shouldReveal); // toggles corner visibility
      _overlay?.markNeedsBuild(); // switch hint <=> revealed card
    }
  }

  void _reset() {
    _dragDy = 0;
    setState(() {
      _dragging = false;
      _revealed = false;
    });
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: (_) => _reset(),
      onPanCancel: _reset,
      // the corner card hides while the role is shown in the centre and returns
      // once the finger is lifted
      child: Opacity(
        opacity: _revealed ? 0.0 : 1.0,
        child: AnimatedBuilder(
          animation: _bob,
          builder: (context, child) => Transform.translate(
            // stop bobbing while dragging so the handle sits still
            offset: Offset(-80, 100 + (_dragging ? 0 : _bob.value)),
            child: child,
          ),
          child: Transform.rotate(
            angle: 0.1,
            child: _buildCardCorner(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardCorner() {
    const double cardWidth = 340;
    const double cardHeight = 500;
    const double scale = 1 / 2.2;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: cardWidth * scale,
        height: cardHeight * scale,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 6),
              blurRadius: 20,
            ),
          ],
        ),
        // the face-down card shows the shared card back
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('assets/PNGs/Backside.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  // Centre hint shown while dragging, before the reveal threshold is reached.
  Widget _buildHintTarget() {
    return Container(
      width: 160,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white70, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_upward, color: Colors.white, size: 28),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildRevealCard() {
    final child = widget.revealChild;
    if (child != null) return child;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: _revealCardWidth,
        height: _revealCardHeight,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              roleCardAsset(widget.role),
              fit: BoxFit.cover,
              width: 240,
            ),
          ),
        ),
      ),
    );
  }
}
