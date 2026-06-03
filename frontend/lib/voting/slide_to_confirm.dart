import 'package:flutter/material.dart';

/// A slide-to-confirm button: the user has to drag the thumb from left to right
/// to commit, so a stray tap can't submit by accident. [label] is shown centred
/// on the track. Once [completed] the thumb sits at the end and is locked.
class SlideToConfirm extends StatefulWidget {
  final String label;
  final bool enabled;
  final bool completed;
  final VoidCallback onConfirm;

  const SlideToConfirm({
    super.key,
    required this.label,
    required this.onConfirm,
    this.enabled = true,
    this.completed = false,
  });

  @override
  State<SlideToConfirm> createState() => _SlideToConfirmState();
}

class _SlideToConfirmState extends State<SlideToConfirm> {
  static const double _height = 58;
  static const double _thumb = 50;
  static const double _commitFraction = 0.85;

  double _dragX = 0;

  @override
  Widget build(BuildContext context) {
    final completed = widget.completed;
    final interactive = widget.enabled && !completed;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxX = (constraints.maxWidth - _thumb - 4).clamp(0.0, double.infinity);
        final thumbX = completed ? maxX : _dragX.clamp(0.0, maxX);
        final progress = maxX <= 0 ? 0.0 : thumbX / maxX;

        return Container(
          height: _height,
          width: double.infinity, // fill the track; don't shrink to the label
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(_height / 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _thumb),
                child: Opacity(
                  opacity: (1.0 - progress * 0.85).clamp(0.0, 1.0),
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 2 + thumbX,
                child: GestureDetector(
                  onHorizontalDragUpdate: interactive
                      ? (d) => setState(
                            () => _dragX = (_dragX + d.delta.dx).clamp(0.0, maxX),
                          )
                      : null,
                  onHorizontalDragEnd: interactive
                      ? (_) {
                          if (_dragX >= maxX * _commitFraction) {
                            setState(() => _dragX = maxX);
                            widget.onConfirm();
                          } else {
                            setState(() => _dragX = 0);
                          }
                        }
                      : null,
                  child: Container(
                    width: _thumb,
                    height: _thumb,
                    decoration: BoxDecoration(
                      color: completed ? Colors.green : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      completed ? Icons.check : Icons.chevron_right,
                      color: completed ? Colors.white : Colors.black,
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
}
