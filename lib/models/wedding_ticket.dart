/// Model for a digital wedding ticket (guest entry).
class WeddingTicket {
  const WeddingTicket({
    required this.ticketId,
    required this.guestName,
    required this.eventName,
    required this.eventDate,
    required this.location,
    this.guestsCount = 1,
    this.tableNumber,
    this.qrPayload,
  });

  /// Unique ticket identifier (e.g. for QR / check-in).
  final String ticketId;

  /// Guest or invitee name.
  final String guestName;

  /// Event title (e.g. "សិរីមង្គលអាពាហ៍ពិពាហ៍").
  final String eventName;

  /// Event date string (e.g. "ថ្ងៃពុធ ទី២៨ ខែមករា ឆ្នាំ២០២៦").
  final String eventDate;

  /// Venue / location text.
  final String location;

  /// Number of guests this ticket admits.
  final int guestsCount;

  /// Optional table or seat.
  final String? tableNumber;

  /// Optional payload for QR code (e.g. ticketId or JSON).
  final String? qrPayload;

  String get qrContent => qrPayload ?? ticketId;
}
