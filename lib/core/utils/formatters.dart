import 'package:intl/intl.dart';

final _currency = NumberFormat.simpleCurrency(name: 'USD');
final _timeFormatter = DateFormat('h:mm a');

String formatCurrency(double value) => _currency.format(value);
String formatTimeRange(DateTime start, DateTime end) =>
    '${_timeFormatter.format(start)} – ${_timeFormatter.format(end)}';
String formatDistance(double miles) => '${miles.toStringAsFixed(1)} mi';
String formatStartsIn(Duration duration) {
  if (duration.inMinutes <= 0) {
    return 'Starting now';
  }
  if (duration.inHours >= 1) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (minutes == 0) return 'Starts in $hours h';
    return 'Starts in ${hours}h ${minutes}m';
  }
  return 'Starts in ${duration.inMinutes} min';
}
