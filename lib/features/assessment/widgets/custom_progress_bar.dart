import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AirplaneProgressIndicator extends StatefulWidget {
  final double progress;
  final int completed;
  final int total;
  final Color primaryColor;
  final Color backgroundColor;

  const AirplaneProgressIndicator({
    super.key,
    required this.progress,
    required this.completed,
    required this.total,
    required this.primaryColor,
    this.backgroundColor = const Color(0xFFF2F2F7),
  });

  @override
  State<AirplaneProgressIndicator> createState() => _AirplaneProgressIndicatorState();
}

class _AirplaneProgressIndicatorState extends State<AirplaneProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _iconScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(AirplaneProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = widget.progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            // Background progress track
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            // Animated progress fill
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (BuildContext context, Widget? child) {
                return Positioned(

                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8 * _progressAnimation.value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          widget.primaryColor,
                          widget.primaryColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: widget.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Moving airplane icon
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (BuildContext context, Widget? child) {
                final double iconPosition =
                    (MediaQuery.of(context).size.width * 0.8 * _progressAnimation.value) - 15;

                return Positioned(
                  left: iconPosition.clamp(10.0, MediaQuery.of(context).size.width * 0.8 - 40),
                  top: 5,
                  child: AnimatedBuilder(
                    animation: _iconScaleAnimation,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.scale(
                        scale: isCompleted ? _iconScaleAnimation.value : 1.0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isCompleted
                                ? CupertinoIcons.check_mark_circled_solid
                                : CupertinoIcons.airplane,
                            color: isCompleted ? Colors.green : widget.primaryColor,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
