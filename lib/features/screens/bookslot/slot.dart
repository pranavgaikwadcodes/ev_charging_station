class Slot {
  final String time;
  final String status;
  final String? bookedBy;

  Slot({
    required this.time,
    required this.status,
    this.bookedBy,
  });
}