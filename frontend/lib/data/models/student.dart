class Student {
  const Student({
    required this.nim,
    required this.name,
    required this.sksSemester,
    required this.sksTotal,
    required this.ipSemester,
    required this.ipCumulative,
    this.lastFetched,
  });

  final String nim;
  final String name;
  final int sksSemester;
  final int sksTotal;
  final double ipSemester;
  final double ipCumulative;

  /// When this row was last pulled from the server (UTC). Null for objects
  /// that were just parsed from JSON and not stored yet.
  final DateTime? lastFetched;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        nim: json['nim'] as String,
        name: json['name'] as String,
        sksSemester: (json['sksSemester'] as num).toInt(),
        sksTotal: (json['sksTotal'] as num).toInt(),
        ipSemester: (json['ipSemester'] as num).toDouble(),
        ipCumulative: (json['ipCumulative'] as num).toDouble(),
      );
}
