import 'dart:async';
import 'package:flutter/material.dart';
import 'package:coolapp/constants/colors.dart';
import 'package:coolapp/constants/text_styles.dart';
import 'package:coolapp/utils/date_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isCheckedIn = false;
  DateTime? _checkInTime;
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    
    // Pulse animation for check-in button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Glow animation when checked in
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  void _handleCheckInOut() {
    setState(() {
      if (_isCheckedIn) {
        _isCheckedIn = false;
        _checkInTime = null;
        _pulseController.stop();
        _glowController.stop();
      } else {
        _isCheckedIn = true;
        _checkInTime = DateTime.now();
        _pulseController.forward();
        _glowController.forward();
      }
    });
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCheckedIn
              ? 'Checked in successfully!'
              : 'Checked out successfully!',
        ),
        backgroundColor: _isCheckedIn
            ? AppColors.successGreen
            : AppColors.primaryBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  String _getCurrentTimeString() {
    return DateFormatter.formatTime(_currentTime);
  }

  String _getStatusText() {
    if (_isCheckedIn && _checkInTime != null) {
      return 'You checked in at ${DateFormatter.formatTime(_checkInTime!)}';
    }
    return 'You are currently not checked in';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Text(
                'Welcome, Alex',
                style: AppTextStyles.welcomeText,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormatter.formatWeekdayDate(_currentTime),
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: 40),
              // Current Time Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.lightBlueCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Time',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getCurrentTimeString(),
                      style: AppTextStyles.timeDisplay,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Check In/Out Button
              Center(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: _isCheckedIn
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryBlue
                                          .withOpacity(_glowAnimation.value),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Transform.scale(
                            scale: _isCheckedIn ? _pulseAnimation.value : 1.0,
                            child: Material(
                              color: AppColors.primaryBlue,
                              shape: const CircleBorder(),
                              child: InkWell(
                                onTap: _handleCheckInOut,
                                customBorder: const CircleBorder(),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isCheckedIn
                                            ? Icons.check_circle_outline
                                            : Icons.login,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _isCheckedIn ? 'Check Out' : 'Check In',
                                        style: AppTextStyles.buttonMedium
                                            .copyWith(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Status Text
              Center(
                child: Text(
                  _getStatusText(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // This Week Stats Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.lightBlueCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Week',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hours',
                                  style: AppTextStyles.statLabel,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '32.5',
                                  style: AppTextStyles.statValue,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Days',
                                  style: AppTextStyles.statLabel,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '4/5',
                                  style: AppTextStyles.statValue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Motivational Message
              if (!_isCheckedIn)
                Center(
                  child: Text(
                    'Have a productive day, Alex!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

