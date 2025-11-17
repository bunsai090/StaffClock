class AttendanceModel {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final Duration? totalHours;
  
  AttendanceModel({
    required this.id,
    required this.userId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.totalHours,
  });
  
  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      date: map['date']?.toDate() ?? DateTime.now(),
      checkIn: map['checkIn']?.toDate(),
      checkOut: map['checkOut']?.toDate(),
      totalHours: map['totalHours'] != null 
          ? Duration(seconds: map['totalHours'])
          : null,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'totalHours': totalHours?.inSeconds,
    };
  }
  
  String get formattedDate {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
  
  String get formattedTime {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
  
  String get formattedDuration {
    if (totalHours == null) return '0h 0m';
    final hours = totalHours!.inHours;
    final minutes = totalHours!.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}

