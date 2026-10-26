// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StudentsTable extends Students
    with TableInfo<$StudentsTable, StudentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nimMeta = const VerificationMeta('nim');
  @override
  late final GeneratedColumn<String> nim = GeneratedColumn<String>(
    'nim',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sksSemesterMeta = const VerificationMeta(
    'sksSemester',
  );
  @override
  late final GeneratedColumn<int> sksSemester = GeneratedColumn<int>(
    'sks_semester',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sksTotalMeta = const VerificationMeta(
    'sksTotal',
  );
  @override
  late final GeneratedColumn<int> sksTotal = GeneratedColumn<int>(
    'sks_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ipSemesterMeta = const VerificationMeta(
    'ipSemester',
  );
  @override
  late final GeneratedColumn<double> ipSemester = GeneratedColumn<double>(
    'ip_semester',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ipCumulativeMeta = const VerificationMeta(
    'ipCumulative',
  );
  @override
  late final GeneratedColumn<double> ipCumulative = GeneratedColumn<double>(
    'ip_cumulative',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastFetchedMeta = const VerificationMeta(
    'lastFetched',
  );
  @override
  late final GeneratedColumn<int> lastFetched = GeneratedColumn<int>(
    'last_fetched',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    nim,
    name,
    sksSemester,
    sksTotal,
    ipSemester,
    ipCumulative,
    lastFetched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('nim')) {
      context.handle(
        _nimMeta,
        nim.isAcceptableOrUnknown(data['nim']!, _nimMeta),
      );
    } else if (isInserting) {
      context.missing(_nimMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sks_semester')) {
      context.handle(
        _sksSemesterMeta,
        sksSemester.isAcceptableOrUnknown(
          data['sks_semester']!,
          _sksSemesterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sksSemesterMeta);
    }
    if (data.containsKey('sks_total')) {
      context.handle(
        _sksTotalMeta,
        sksTotal.isAcceptableOrUnknown(data['sks_total']!, _sksTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_sksTotalMeta);
    }
    if (data.containsKey('ip_semester')) {
      context.handle(
        _ipSemesterMeta,
        ipSemester.isAcceptableOrUnknown(data['ip_semester']!, _ipSemesterMeta),
      );
    } else if (isInserting) {
      context.missing(_ipSemesterMeta);
    }
    if (data.containsKey('ip_cumulative')) {
      context.handle(
        _ipCumulativeMeta,
        ipCumulative.isAcceptableOrUnknown(
          data['ip_cumulative']!,
          _ipCumulativeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ipCumulativeMeta);
    }
    if (data.containsKey('last_fetched')) {
      context.handle(
        _lastFetchedMeta,
        lastFetched.isAcceptableOrUnknown(
          data['last_fetched']!,
          _lastFetchedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastFetchedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {nim};
  @override
  StudentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentRow(
      nim: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nim'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sksSemester: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sks_semester'],
      )!,
      sksTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sks_total'],
      )!,
      ipSemester: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ip_semester'],
      )!,
      ipCumulative: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ip_cumulative'],
      )!,
      lastFetched: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_fetched'],
      )!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class StudentRow extends DataClass implements Insertable<StudentRow> {
  final String nim;
  final String name;
  final int sksSemester;
  final int sksTotal;
  final double ipSemester;
  final double ipCumulative;
  final int lastFetched;
  const StudentRow({
    required this.nim,
    required this.name,
    required this.sksSemester,
    required this.sksTotal,
    required this.ipSemester,
    required this.ipCumulative,
    required this.lastFetched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['nim'] = Variable<String>(nim);
    map['name'] = Variable<String>(name);
    map['sks_semester'] = Variable<int>(sksSemester);
    map['sks_total'] = Variable<int>(sksTotal);
    map['ip_semester'] = Variable<double>(ipSemester);
    map['ip_cumulative'] = Variable<double>(ipCumulative);
    map['last_fetched'] = Variable<int>(lastFetched);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      nim: Value(nim),
      name: Value(name),
      sksSemester: Value(sksSemester),
      sksTotal: Value(sksTotal),
      ipSemester: Value(ipSemester),
      ipCumulative: Value(ipCumulative),
      lastFetched: Value(lastFetched),
    );
  }

  factory StudentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentRow(
      nim: serializer.fromJson<String>(json['nim']),
      name: serializer.fromJson<String>(json['name']),
      sksSemester: serializer.fromJson<int>(json['sksSemester']),
      sksTotal: serializer.fromJson<int>(json['sksTotal']),
      ipSemester: serializer.fromJson<double>(json['ipSemester']),
      ipCumulative: serializer.fromJson<double>(json['ipCumulative']),
      lastFetched: serializer.fromJson<int>(json['lastFetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'nim': serializer.toJson<String>(nim),
      'name': serializer.toJson<String>(name),
      'sksSemester': serializer.toJson<int>(sksSemester),
      'sksTotal': serializer.toJson<int>(sksTotal),
      'ipSemester': serializer.toJson<double>(ipSemester),
      'ipCumulative': serializer.toJson<double>(ipCumulative),
      'lastFetched': serializer.toJson<int>(lastFetched),
    };
  }

  StudentRow copyWith({
    String? nim,
    String? name,
    int? sksSemester,
    int? sksTotal,
    double? ipSemester,
    double? ipCumulative,
    int? lastFetched,
  }) => StudentRow(
    nim: nim ?? this.nim,
    name: name ?? this.name,
    sksSemester: sksSemester ?? this.sksSemester,
    sksTotal: sksTotal ?? this.sksTotal,
    ipSemester: ipSemester ?? this.ipSemester,
    ipCumulative: ipCumulative ?? this.ipCumulative,
    lastFetched: lastFetched ?? this.lastFetched,
  );
  StudentRow copyWithCompanion(StudentsCompanion data) {
    return StudentRow(
      nim: data.nim.present ? data.nim.value : this.nim,
      name: data.name.present ? data.name.value : this.name,
      sksSemester: data.sksSemester.present
          ? data.sksSemester.value
          : this.sksSemester,
      sksTotal: data.sksTotal.present ? data.sksTotal.value : this.sksTotal,
      ipSemester: data.ipSemester.present
          ? data.ipSemester.value
          : this.ipSemester,
      ipCumulative: data.ipCumulative.present
          ? data.ipCumulative.value
          : this.ipCumulative,
      lastFetched: data.lastFetched.present
          ? data.lastFetched.value
          : this.lastFetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentRow(')
          ..write('nim: $nim, ')
          ..write('name: $name, ')
          ..write('sksSemester: $sksSemester, ')
          ..write('sksTotal: $sksTotal, ')
          ..write('ipSemester: $ipSemester, ')
          ..write('ipCumulative: $ipCumulative, ')
          ..write('lastFetched: $lastFetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    nim,
    name,
    sksSemester,
    sksTotal,
    ipSemester,
    ipCumulative,
    lastFetched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentRow &&
          other.nim == this.nim &&
          other.name == this.name &&
          other.sksSemester == this.sksSemester &&
          other.sksTotal == this.sksTotal &&
          other.ipSemester == this.ipSemester &&
          other.ipCumulative == this.ipCumulative &&
          other.lastFetched == this.lastFetched);
}

class StudentsCompanion extends UpdateCompanion<StudentRow> {
  final Value<String> nim;
  final Value<String> name;
  final Value<int> sksSemester;
  final Value<int> sksTotal;
  final Value<double> ipSemester;
  final Value<double> ipCumulative;
  final Value<int> lastFetched;
  final Value<int> rowid;
  const StudentsCompanion({
    this.nim = const Value.absent(),
    this.name = const Value.absent(),
    this.sksSemester = const Value.absent(),
    this.sksTotal = const Value.absent(),
    this.ipSemester = const Value.absent(),
    this.ipCumulative = const Value.absent(),
    this.lastFetched = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String nim,
    required String name,
    required int sksSemester,
    required int sksTotal,
    required double ipSemester,
    required double ipCumulative,
    required int lastFetched,
    this.rowid = const Value.absent(),
  }) : nim = Value(nim),
       name = Value(name),
       sksSemester = Value(sksSemester),
       sksTotal = Value(sksTotal),
       ipSemester = Value(ipSemester),
       ipCumulative = Value(ipCumulative),
       lastFetched = Value(lastFetched);
  static Insertable<StudentRow> custom({
    Expression<String>? nim,
    Expression<String>? name,
    Expression<int>? sksSemester,
    Expression<int>? sksTotal,
    Expression<double>? ipSemester,
    Expression<double>? ipCumulative,
    Expression<int>? lastFetched,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (nim != null) 'nim': nim,
      if (name != null) 'name': name,
      if (sksSemester != null) 'sks_semester': sksSemester,
      if (sksTotal != null) 'sks_total': sksTotal,
      if (ipSemester != null) 'ip_semester': ipSemester,
      if (ipCumulative != null) 'ip_cumulative': ipCumulative,
      if (lastFetched != null) 'last_fetched': lastFetched,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith({
    Value<String>? nim,
    Value<String>? name,
    Value<int>? sksSemester,
    Value<int>? sksTotal,
    Value<double>? ipSemester,
    Value<double>? ipCumulative,
    Value<int>? lastFetched,
    Value<int>? rowid,
  }) {
    return StudentsCompanion(
      nim: nim ?? this.nim,
      name: name ?? this.name,
      sksSemester: sksSemester ?? this.sksSemester,
      sksTotal: sksTotal ?? this.sksTotal,
      ipSemester: ipSemester ?? this.ipSemester,
      ipCumulative: ipCumulative ?? this.ipCumulative,
      lastFetched: lastFetched ?? this.lastFetched,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (nim.present) {
      map['nim'] = Variable<String>(nim.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sksSemester.present) {
      map['sks_semester'] = Variable<int>(sksSemester.value);
    }
    if (sksTotal.present) {
      map['sks_total'] = Variable<int>(sksTotal.value);
    }
    if (ipSemester.present) {
      map['ip_semester'] = Variable<double>(ipSemester.value);
    }
    if (ipCumulative.present) {
      map['ip_cumulative'] = Variable<double>(ipCumulative.value);
    }
    if (lastFetched.present) {
      map['last_fetched'] = Variable<int>(lastFetched.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('nim: $nim, ')
          ..write('name: $name, ')
          ..write('sksSemester: $sksSemester, ')
          ..write('sksTotal: $sksTotal, ')
          ..write('ipSemester: $ipSemester, ')
          ..write('ipCumulative: $ipCumulative, ')
          ..write('lastFetched: $lastFetched, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CoursesTable extends Courses with TableInfo<$CoursesTable, CourseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoursesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorIndexMeta = const VerificationMeta(
    'colorIndex',
  );
  @override
  late final GeneratedColumn<int> colorIndex = GeneratedColumn<int>(
    'color_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<int> grade = GeneratedColumn<int>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _letterMeta = const VerificationMeta('letter');
  @override
  late final GeneratedColumn<String> letter = GeneratedColumn<String>(
    'letter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskScoreMeta = const VerificationMeta(
    'taskScore',
  );
  @override
  late final GeneratedColumn<int> taskScore = GeneratedColumn<int>(
    'task_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attendScoreMeta = const VerificationMeta(
    'attendScore',
  );
  @override
  late final GeneratedColumn<int> attendScore = GeneratedColumn<int>(
    'attend_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _utsScoreMeta = const VerificationMeta(
    'utsScore',
  );
  @override
  late final GeneratedColumn<int> utsScore = GeneratedColumn<int>(
    'uts_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uasScoreMeta = const VerificationMeta(
    'uasScore',
  );
  @override
  late final GeneratedColumn<int> uasScore = GeneratedColumn<int>(
    'uas_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attendPercentMeta = const VerificationMeta(
    'attendPercent',
  );
  @override
  late final GeneratedColumn<int> attendPercent = GeneratedColumn<int>(
    'attend_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attendCountMeta = const VerificationMeta(
    'attendCount',
  );
  @override
  late final GeneratedColumn<int> attendCount = GeneratedColumn<int>(
    'attend_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _permitCountMeta = const VerificationMeta(
    'permitCount',
  );
  @override
  late final GeneratedColumn<int> permitCount = GeneratedColumn<int>(
    'permit_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sickCountMeta = const VerificationMeta(
    'sickCount',
  );
  @override
  late final GeneratedColumn<int> sickCount = GeneratedColumn<int>(
    'sick_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alphaCountMeta = const VerificationMeta(
    'alphaCount',
  );
  @override
  late final GeneratedColumn<int> alphaCount = GeneratedColumn<int>(
    'alpha_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastFetchedMeta = const VerificationMeta(
    'lastFetched',
  );
  @override
  late final GeneratedColumn<int> lastFetched = GeneratedColumn<int>(
    'last_fetched',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    code,
    colorIndex,
    grade,
    letter,
    taskScore,
    attendScore,
    utsScore,
    uasScore,
    attendPercent,
    attendCount,
    permitCount,
    sickCount,
    alphaCount,
    lastFetched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses';
  @override
  VerificationContext validateIntegrity(
    Insertable<CourseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('color_index')) {
      context.handle(
        _colorIndexMeta,
        colorIndex.isAcceptableOrUnknown(data['color_index']!, _colorIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorIndexMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('letter')) {
      context.handle(
        _letterMeta,
        letter.isAcceptableOrUnknown(data['letter']!, _letterMeta),
      );
    } else if (isInserting) {
      context.missing(_letterMeta);
    }
    if (data.containsKey('task_score')) {
      context.handle(
        _taskScoreMeta,
        taskScore.isAcceptableOrUnknown(data['task_score']!, _taskScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_taskScoreMeta);
    }
    if (data.containsKey('attend_score')) {
      context.handle(
        _attendScoreMeta,
        attendScore.isAcceptableOrUnknown(
          data['attend_score']!,
          _attendScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attendScoreMeta);
    }
    if (data.containsKey('uts_score')) {
      context.handle(
        _utsScoreMeta,
        utsScore.isAcceptableOrUnknown(data['uts_score']!, _utsScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_utsScoreMeta);
    }
    if (data.containsKey('uas_score')) {
      context.handle(
        _uasScoreMeta,
        uasScore.isAcceptableOrUnknown(data['uas_score']!, _uasScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_uasScoreMeta);
    }
    if (data.containsKey('attend_percent')) {
      context.handle(
        _attendPercentMeta,
        attendPercent.isAcceptableOrUnknown(
          data['attend_percent']!,
          _attendPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attendPercentMeta);
    }
    if (data.containsKey('attend_count')) {
      context.handle(
        _attendCountMeta,
        attendCount.isAcceptableOrUnknown(
          data['attend_count']!,
          _attendCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attendCountMeta);
    }
    if (data.containsKey('permit_count')) {
      context.handle(
        _permitCountMeta,
        permitCount.isAcceptableOrUnknown(
          data['permit_count']!,
          _permitCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_permitCountMeta);
    }
    if (data.containsKey('sick_count')) {
      context.handle(
        _sickCountMeta,
        sickCount.isAcceptableOrUnknown(data['sick_count']!, _sickCountMeta),
      );
    } else if (isInserting) {
      context.missing(_sickCountMeta);
    }
    if (data.containsKey('alpha_count')) {
      context.handle(
        _alphaCountMeta,
        alphaCount.isAcceptableOrUnknown(data['alpha_count']!, _alphaCountMeta),
      );
    } else if (isInserting) {
      context.missing(_alphaCountMeta);
    }
    if (data.containsKey('last_fetched')) {
      context.handle(
        _lastFetchedMeta,
        lastFetched.isAcceptableOrUnknown(
          data['last_fetched']!,
          _lastFetchedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastFetchedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CourseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CourseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      colorIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_index'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grade'],
      )!,
      letter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}letter'],
      )!,
      taskScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_score'],
      )!,
      attendScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attend_score'],
      )!,
      utsScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uts_score'],
      )!,
      uasScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uas_score'],
      )!,
      attendPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attend_percent'],
      )!,
      attendCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attend_count'],
      )!,
      permitCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}permit_count'],
      )!,
      sickCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sick_count'],
      )!,
      alphaCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alpha_count'],
      )!,
      lastFetched: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_fetched'],
      )!,
    );
  }

  @override
  $CoursesTable createAlias(String alias) {
    return $CoursesTable(attachedDatabase, alias);
  }
}

class CourseRow extends DataClass implements Insertable<CourseRow> {
  /// Server id (not auto-generated).
  final int id;
  final String name;
  final String code;
  final int colorIndex;
  final int grade;
  final String letter;
  final int taskScore;
  final int attendScore;
  final int utsScore;
  final int uasScore;
  final int attendPercent;
  final int attendCount;
  final int permitCount;
  final int sickCount;
  final int alphaCount;
  final int lastFetched;
  const CourseRow({
    required this.id,
    required this.name,
    required this.code,
    required this.colorIndex,
    required this.grade,
    required this.letter,
    required this.taskScore,
    required this.attendScore,
    required this.utsScore,
    required this.uasScore,
    required this.attendPercent,
    required this.attendCount,
    required this.permitCount,
    required this.sickCount,
    required this.alphaCount,
    required this.lastFetched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    map['color_index'] = Variable<int>(colorIndex);
    map['grade'] = Variable<int>(grade);
    map['letter'] = Variable<String>(letter);
    map['task_score'] = Variable<int>(taskScore);
    map['attend_score'] = Variable<int>(attendScore);
    map['uts_score'] = Variable<int>(utsScore);
    map['uas_score'] = Variable<int>(uasScore);
    map['attend_percent'] = Variable<int>(attendPercent);
    map['attend_count'] = Variable<int>(attendCount);
    map['permit_count'] = Variable<int>(permitCount);
    map['sick_count'] = Variable<int>(sickCount);
    map['alpha_count'] = Variable<int>(alphaCount);
    map['last_fetched'] = Variable<int>(lastFetched);
    return map;
  }

  CoursesCompanion toCompanion(bool nullToAbsent) {
    return CoursesCompanion(
      id: Value(id),
      name: Value(name),
      code: Value(code),
      colorIndex: Value(colorIndex),
      grade: Value(grade),
      letter: Value(letter),
      taskScore: Value(taskScore),
      attendScore: Value(attendScore),
      utsScore: Value(utsScore),
      uasScore: Value(uasScore),
      attendPercent: Value(attendPercent),
      attendCount: Value(attendCount),
      permitCount: Value(permitCount),
      sickCount: Value(sickCount),
      alphaCount: Value(alphaCount),
      lastFetched: Value(lastFetched),
    );
  }

  factory CourseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CourseRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      colorIndex: serializer.fromJson<int>(json['colorIndex']),
      grade: serializer.fromJson<int>(json['grade']),
      letter: serializer.fromJson<String>(json['letter']),
      taskScore: serializer.fromJson<int>(json['taskScore']),
      attendScore: serializer.fromJson<int>(json['attendScore']),
      utsScore: serializer.fromJson<int>(json['utsScore']),
      uasScore: serializer.fromJson<int>(json['uasScore']),
      attendPercent: serializer.fromJson<int>(json['attendPercent']),
      attendCount: serializer.fromJson<int>(json['attendCount']),
      permitCount: serializer.fromJson<int>(json['permitCount']),
      sickCount: serializer.fromJson<int>(json['sickCount']),
      alphaCount: serializer.fromJson<int>(json['alphaCount']),
      lastFetched: serializer.fromJson<int>(json['lastFetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'colorIndex': serializer.toJson<int>(colorIndex),
      'grade': serializer.toJson<int>(grade),
      'letter': serializer.toJson<String>(letter),
      'taskScore': serializer.toJson<int>(taskScore),
      'attendScore': serializer.toJson<int>(attendScore),
      'utsScore': serializer.toJson<int>(utsScore),
      'uasScore': serializer.toJson<int>(uasScore),
      'attendPercent': serializer.toJson<int>(attendPercent),
      'attendCount': serializer.toJson<int>(attendCount),
      'permitCount': serializer.toJson<int>(permitCount),
      'sickCount': serializer.toJson<int>(sickCount),
      'alphaCount': serializer.toJson<int>(alphaCount),
      'lastFetched': serializer.toJson<int>(lastFetched),
    };
  }

  CourseRow copyWith({
    int? id,
    String? name,
    String? code,
    int? colorIndex,
    int? grade,
    String? letter,
    int? taskScore,
    int? attendScore,
    int? utsScore,
    int? uasScore,
    int? attendPercent,
    int? attendCount,
    int? permitCount,
    int? sickCount,
    int? alphaCount,
    int? lastFetched,
  }) => CourseRow(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code ?? this.code,
    colorIndex: colorIndex ?? this.colorIndex,
    grade: grade ?? this.grade,
    letter: letter ?? this.letter,
    taskScore: taskScore ?? this.taskScore,
    attendScore: attendScore ?? this.attendScore,
    utsScore: utsScore ?? this.utsScore,
    uasScore: uasScore ?? this.uasScore,
    attendPercent: attendPercent ?? this.attendPercent,
    attendCount: attendCount ?? this.attendCount,
    permitCount: permitCount ?? this.permitCount,
    sickCount: sickCount ?? this.sickCount,
    alphaCount: alphaCount ?? this.alphaCount,
    lastFetched: lastFetched ?? this.lastFetched,
  );
  CourseRow copyWithCompanion(CoursesCompanion data) {
    return CourseRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      colorIndex: data.colorIndex.present
          ? data.colorIndex.value
          : this.colorIndex,
      grade: data.grade.present ? data.grade.value : this.grade,
      letter: data.letter.present ? data.letter.value : this.letter,
      taskScore: data.taskScore.present ? data.taskScore.value : this.taskScore,
      attendScore: data.attendScore.present
          ? data.attendScore.value
          : this.attendScore,
      utsScore: data.utsScore.present ? data.utsScore.value : this.utsScore,
      uasScore: data.uasScore.present ? data.uasScore.value : this.uasScore,
      attendPercent: data.attendPercent.present
          ? data.attendPercent.value
          : this.attendPercent,
      attendCount: data.attendCount.present
          ? data.attendCount.value
          : this.attendCount,
      permitCount: data.permitCount.present
          ? data.permitCount.value
          : this.permitCount,
      sickCount: data.sickCount.present ? data.sickCount.value : this.sickCount,
      alphaCount: data.alphaCount.present
          ? data.alphaCount.value
          : this.alphaCount,
      lastFetched: data.lastFetched.present
          ? data.lastFetched.value
          : this.lastFetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CourseRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('grade: $grade, ')
          ..write('letter: $letter, ')
          ..write('taskScore: $taskScore, ')
          ..write('attendScore: $attendScore, ')
          ..write('utsScore: $utsScore, ')
          ..write('uasScore: $uasScore, ')
          ..write('attendPercent: $attendPercent, ')
          ..write('attendCount: $attendCount, ')
          ..write('permitCount: $permitCount, ')
          ..write('sickCount: $sickCount, ')
          ..write('alphaCount: $alphaCount, ')
          ..write('lastFetched: $lastFetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    code,
    colorIndex,
    grade,
    letter,
    taskScore,
    attendScore,
    utsScore,
    uasScore,
    attendPercent,
    attendCount,
    permitCount,
    sickCount,
    alphaCount,
    lastFetched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CourseRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.colorIndex == this.colorIndex &&
          other.grade == this.grade &&
          other.letter == this.letter &&
          other.taskScore == this.taskScore &&
          other.attendScore == this.attendScore &&
          other.utsScore == this.utsScore &&
          other.uasScore == this.uasScore &&
          other.attendPercent == this.attendPercent &&
          other.attendCount == this.attendCount &&
          other.permitCount == this.permitCount &&
          other.sickCount == this.sickCount &&
          other.alphaCount == this.alphaCount &&
          other.lastFetched == this.lastFetched);
}

class CoursesCompanion extends UpdateCompanion<CourseRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> code;
  final Value<int> colorIndex;
  final Value<int> grade;
  final Value<String> letter;
  final Value<int> taskScore;
  final Value<int> attendScore;
  final Value<int> utsScore;
  final Value<int> uasScore;
  final Value<int> attendPercent;
  final Value<int> attendCount;
  final Value<int> permitCount;
  final Value<int> sickCount;
  final Value<int> alphaCount;
  final Value<int> lastFetched;
  const CoursesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.colorIndex = const Value.absent(),
    this.grade = const Value.absent(),
    this.letter = const Value.absent(),
    this.taskScore = const Value.absent(),
    this.attendScore = const Value.absent(),
    this.utsScore = const Value.absent(),
    this.uasScore = const Value.absent(),
    this.attendPercent = const Value.absent(),
    this.attendCount = const Value.absent(),
    this.permitCount = const Value.absent(),
    this.sickCount = const Value.absent(),
    this.alphaCount = const Value.absent(),
    this.lastFetched = const Value.absent(),
  });
  CoursesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String code,
    required int colorIndex,
    required int grade,
    required String letter,
    required int taskScore,
    required int attendScore,
    required int utsScore,
    required int uasScore,
    required int attendPercent,
    required int attendCount,
    required int permitCount,
    required int sickCount,
    required int alphaCount,
    required int lastFetched,
  }) : name = Value(name),
       code = Value(code),
       colorIndex = Value(colorIndex),
       grade = Value(grade),
       letter = Value(letter),
       taskScore = Value(taskScore),
       attendScore = Value(attendScore),
       utsScore = Value(utsScore),
       uasScore = Value(uasScore),
       attendPercent = Value(attendPercent),
       attendCount = Value(attendCount),
       permitCount = Value(permitCount),
       sickCount = Value(sickCount),
       alphaCount = Value(alphaCount),
       lastFetched = Value(lastFetched);
  static Insertable<CourseRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<int>? colorIndex,
    Expression<int>? grade,
    Expression<String>? letter,
    Expression<int>? taskScore,
    Expression<int>? attendScore,
    Expression<int>? utsScore,
    Expression<int>? uasScore,
    Expression<int>? attendPercent,
    Expression<int>? attendCount,
    Expression<int>? permitCount,
    Expression<int>? sickCount,
    Expression<int>? alphaCount,
    Expression<int>? lastFetched,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (colorIndex != null) 'color_index': colorIndex,
      if (grade != null) 'grade': grade,
      if (letter != null) 'letter': letter,
      if (taskScore != null) 'task_score': taskScore,
      if (attendScore != null) 'attend_score': attendScore,
      if (utsScore != null) 'uts_score': utsScore,
      if (uasScore != null) 'uas_score': uasScore,
      if (attendPercent != null) 'attend_percent': attendPercent,
      if (attendCount != null) 'attend_count': attendCount,
      if (permitCount != null) 'permit_count': permitCount,
      if (sickCount != null) 'sick_count': sickCount,
      if (alphaCount != null) 'alpha_count': alphaCount,
      if (lastFetched != null) 'last_fetched': lastFetched,
    });
  }

  CoursesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? code,
    Value<int>? colorIndex,
    Value<int>? grade,
    Value<String>? letter,
    Value<int>? taskScore,
    Value<int>? attendScore,
    Value<int>? utsScore,
    Value<int>? uasScore,
    Value<int>? attendPercent,
    Value<int>? attendCount,
    Value<int>? permitCount,
    Value<int>? sickCount,
    Value<int>? alphaCount,
    Value<int>? lastFetched,
  }) {
    return CoursesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      colorIndex: colorIndex ?? this.colorIndex,
      grade: grade ?? this.grade,
      letter: letter ?? this.letter,
      taskScore: taskScore ?? this.taskScore,
      attendScore: attendScore ?? this.attendScore,
      utsScore: utsScore ?? this.utsScore,
      uasScore: uasScore ?? this.uasScore,
      attendPercent: attendPercent ?? this.attendPercent,
      attendCount: attendCount ?? this.attendCount,
      permitCount: permitCount ?? this.permitCount,
      sickCount: sickCount ?? this.sickCount,
      alphaCount: alphaCount ?? this.alphaCount,
      lastFetched: lastFetched ?? this.lastFetched,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (colorIndex.present) {
      map['color_index'] = Variable<int>(colorIndex.value);
    }
    if (grade.present) {
      map['grade'] = Variable<int>(grade.value);
    }
    if (letter.present) {
      map['letter'] = Variable<String>(letter.value);
    }
    if (taskScore.present) {
      map['task_score'] = Variable<int>(taskScore.value);
    }
    if (attendScore.present) {
      map['attend_score'] = Variable<int>(attendScore.value);
    }
    if (utsScore.present) {
      map['uts_score'] = Variable<int>(utsScore.value);
    }
    if (uasScore.present) {
      map['uas_score'] = Variable<int>(uasScore.value);
    }
    if (attendPercent.present) {
      map['attend_percent'] = Variable<int>(attendPercent.value);
    }
    if (attendCount.present) {
      map['attend_count'] = Variable<int>(attendCount.value);
    }
    if (permitCount.present) {
      map['permit_count'] = Variable<int>(permitCount.value);
    }
    if (sickCount.present) {
      map['sick_count'] = Variable<int>(sickCount.value);
    }
    if (alphaCount.present) {
      map['alpha_count'] = Variable<int>(alphaCount.value);
    }
    if (lastFetched.present) {
      map['last_fetched'] = Variable<int>(lastFetched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('grade: $grade, ')
          ..write('letter: $letter, ')
          ..write('taskScore: $taskScore, ')
          ..write('attendScore: $attendScore, ')
          ..write('utsScore: $utsScore, ')
          ..write('uasScore: $uasScore, ')
          ..write('attendPercent: $attendPercent, ')
          ..write('attendCount: $attendCount, ')
          ..write('permitCount: $permitCount, ')
          ..write('sickCount: $sickCount, ')
          ..write('alphaCount: $alphaCount, ')
          ..write('lastFetched: $lastFetched')
          ..write(')'))
        .toString();
  }
}

class $AssessmentsTable extends Assessments
    with TableInfo<$AssessmentsTable, AssessmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssessmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<int> courseId = GeneratedColumn<int>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES courses (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    title,
    status,
    score,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assessments';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssessmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssessmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssessmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}course_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $AssessmentsTable createAlias(String alias) {
    return $AssessmentsTable(attachedDatabase, alias);
  }
}

class AssessmentRow extends DataClass implements Insertable<AssessmentRow> {
  final int id;
  final int courseId;
  final String title;

  /// AssessmentStatus.name
  final String status;
  final int? score;

  /// Keeps the server's order.
  final int position;
  const AssessmentRow({
    required this.id,
    required this.courseId,
    required this.title,
    required this.status,
    this.score,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['course_id'] = Variable<int>(courseId);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  AssessmentsCompanion toCompanion(bool nullToAbsent) {
    return AssessmentsCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      status: Value(status),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      position: Value(position),
    );
  }

  factory AssessmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssessmentRow(
      id: serializer.fromJson<int>(json['id']),
      courseId: serializer.fromJson<int>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      score: serializer.fromJson<int?>(json['score']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'courseId': serializer.toJson<int>(courseId),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'score': serializer.toJson<int?>(score),
      'position': serializer.toJson<int>(position),
    };
  }

  AssessmentRow copyWith({
    int? id,
    int? courseId,
    String? title,
    String? status,
    Value<int?> score = const Value.absent(),
    int? position,
  }) => AssessmentRow(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    status: status ?? this.status,
    score: score.present ? score.value : this.score,
    position: position ?? this.position,
  );
  AssessmentRow copyWithCompanion(AssessmentsCompanion data) {
    return AssessmentRow(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      score: data.score.present ? data.score.value : this.score,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentRow(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, courseId, title, status, score, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssessmentRow &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.status == this.status &&
          other.score == this.score &&
          other.position == this.position);
}

class AssessmentsCompanion extends UpdateCompanion<AssessmentRow> {
  final Value<int> id;
  final Value<int> courseId;
  final Value<String> title;
  final Value<String> status;
  final Value<int?> score;
  final Value<int> position;
  const AssessmentsCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.score = const Value.absent(),
    this.position = const Value.absent(),
  });
  AssessmentsCompanion.insert({
    this.id = const Value.absent(),
    required int courseId,
    required String title,
    required String status,
    this.score = const Value.absent(),
    required int position,
  }) : courseId = Value(courseId),
       title = Value(title),
       status = Value(status),
       position = Value(position);
  static Insertable<AssessmentRow> custom({
    Expression<int>? id,
    Expression<int>? courseId,
    Expression<String>? title,
    Expression<String>? status,
    Expression<int>? score,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (score != null) 'score': score,
      if (position != null) 'position': position,
    });
  }

  AssessmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? courseId,
    Value<String>? title,
    Value<String>? status,
    Value<int?>? score,
    Value<int>? position,
  }) {
    return AssessmentsCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      status: status ?? this.status,
      score: score ?? this.score,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<int>(courseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $AttendanceLogsTable extends AttendanceLogs
    with TableInfo<$AttendanceLogsTable, AttendanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<int> courseId = GeneratedColumn<int>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES courses (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, courseId, title, status, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}course_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $AttendanceLogsTable createAlias(String alias) {
    return $AttendanceLogsTable(attachedDatabase, alias);
  }
}

class AttendanceRow extends DataClass implements Insertable<AttendanceRow> {
  final int id;
  final int courseId;
  final String title;

  /// AttendanceStatus.name
  final String status;
  final int position;
  const AttendanceRow({
    required this.id,
    required this.courseId,
    required this.title,
    required this.status,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['course_id'] = Variable<int>(courseId);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    map['position'] = Variable<int>(position);
    return map;
  }

  AttendanceLogsCompanion toCompanion(bool nullToAbsent) {
    return AttendanceLogsCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      status: Value(status),
      position: Value(position),
    );
  }

  factory AttendanceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceRow(
      id: serializer.fromJson<int>(json['id']),
      courseId: serializer.fromJson<int>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'courseId': serializer.toJson<int>(courseId),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'position': serializer.toJson<int>(position),
    };
  }

  AttendanceRow copyWith({
    int? id,
    int? courseId,
    String? title,
    String? status,
    int? position,
  }) => AttendanceRow(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    status: status ?? this.status,
    position: position ?? this.position,
  );
  AttendanceRow copyWithCompanion(AttendanceLogsCompanion data) {
    return AttendanceRow(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRow(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, courseId, title, status, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceRow &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.status == this.status &&
          other.position == this.position);
}

class AttendanceLogsCompanion extends UpdateCompanion<AttendanceRow> {
  final Value<int> id;
  final Value<int> courseId;
  final Value<String> title;
  final Value<String> status;
  final Value<int> position;
  const AttendanceLogsCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.position = const Value.absent(),
  });
  AttendanceLogsCompanion.insert({
    this.id = const Value.absent(),
    required int courseId,
    required String title,
    required String status,
    required int position,
  }) : courseId = Value(courseId),
       title = Value(title),
       status = Value(status),
       position = Value(position);
  static Insertable<AttendanceRow> custom({
    Expression<int>? id,
    Expression<int>? courseId,
    Expression<String>? title,
    Expression<String>? status,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (position != null) 'position': position,
    });
  }

  AttendanceLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? courseId,
    Value<String>? title,
    Value<String>? status,
    Value<int>? position,
  }) {
    return AttendanceLogsCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      status: status ?? this.status,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<int>(courseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceLogsCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $FeedbackNotesTable extends FeedbackNotes
    with TableInfo<$FeedbackNotesTable, FeedbackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedbackNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<int> courseId = GeneratedColumn<int>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES courses (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, courseId, title, body, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feedback_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedbackRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedbackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedbackRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}course_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $FeedbackNotesTable createAlias(String alias) {
    return $FeedbackNotesTable(attachedDatabase, alias);
  }
}

class FeedbackRow extends DataClass implements Insertable<FeedbackRow> {
  final int id;
  final int courseId;
  final String title;
  final String body;
  final int position;
  const FeedbackRow({
    required this.id,
    required this.courseId,
    required this.title,
    required this.body,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['course_id'] = Variable<int>(courseId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['position'] = Variable<int>(position);
    return map;
  }

  FeedbackNotesCompanion toCompanion(bool nullToAbsent) {
    return FeedbackNotesCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      body: Value(body),
      position: Value(position),
    );
  }

  factory FeedbackRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedbackRow(
      id: serializer.fromJson<int>(json['id']),
      courseId: serializer.fromJson<int>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'courseId': serializer.toJson<int>(courseId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'position': serializer.toJson<int>(position),
    };
  }

  FeedbackRow copyWith({
    int? id,
    int? courseId,
    String? title,
    String? body,
    int? position,
  }) => FeedbackRow(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    body: body ?? this.body,
    position: position ?? this.position,
  );
  FeedbackRow copyWithCompanion(FeedbackNotesCompanion data) {
    return FeedbackRow(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackRow(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, courseId, title, body, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedbackRow &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.body == this.body &&
          other.position == this.position);
}

class FeedbackNotesCompanion extends UpdateCompanion<FeedbackRow> {
  final Value<int> id;
  final Value<int> courseId;
  final Value<String> title;
  final Value<String> body;
  final Value<int> position;
  const FeedbackNotesCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.position = const Value.absent(),
  });
  FeedbackNotesCompanion.insert({
    this.id = const Value.absent(),
    required int courseId,
    required String title,
    required String body,
    required int position,
  }) : courseId = Value(courseId),
       title = Value(title),
       body = Value(body),
       position = Value(position);
  static Insertable<FeedbackRow> custom({
    Expression<int>? id,
    Expression<int>? courseId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (position != null) 'position': position,
    });
  }

  FeedbackNotesCompanion copyWith({
    Value<int>? id,
    Value<int>? courseId,
    Value<String>? title,
    Value<String>? body,
    Value<int>? position,
  }) {
    return FeedbackNotesCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      body: body ?? this.body,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<int>(courseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedbackNotesCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $CoursesTable courses = $CoursesTable(this);
  late final $AssessmentsTable assessments = $AssessmentsTable(this);
  late final $AttendanceLogsTable attendanceLogs = $AttendanceLogsTable(this);
  late final $FeedbackNotesTable feedbackNotes = $FeedbackNotesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    students,
    courses,
    assessments,
    attendanceLogs,
    feedbackNotes,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'courses',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('assessments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'courses',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('attendance_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'courses',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('feedback_notes', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  required String nim,
  required String name,
  required int sksSemester,
  required int sksTotal,
  required double ipSemester,
  required double ipCumulative,
  required int lastFetched,
  Value<int> rowid,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<String> nim,
  Value<String> name,
  Value<int> sksSemester,
  Value<int> sksTotal,
  Value<double> ipSemester,
  Value<double> ipCumulative,
  Value<int> lastFetched,
  Value<int> rowid,
});

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get nim => $composableBuilder(
    column: $table.nim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sksSemester => $composableBuilder(
    column: $table.sksSemester,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sksTotal => $composableBuilder(
    column: $table.sksTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ipSemester => $composableBuilder(
    column: $table.ipSemester,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ipCumulative => $composableBuilder(
    column: $table.ipCumulative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get nim => $composableBuilder(
    column: $table.nim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sksSemester => $composableBuilder(
    column: $table.sksSemester,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sksTotal => $composableBuilder(
    column: $table.sksTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ipSemester => $composableBuilder(
    column: $table.ipSemester,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ipCumulative => $composableBuilder(
    column: $table.ipCumulative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get nim =>
      $composableBuilder(column: $table.nim, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sksSemester => $composableBuilder(
    column: $table.sksSemester,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sksTotal =>
      $composableBuilder(column: $table.sksTotal, builder: (column) => column);

  GeneratedColumn<double> get ipSemester => $composableBuilder(
    column: $table.ipSemester,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ipCumulative => $composableBuilder(
    column: $table.ipCumulative,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => column,
  );
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          StudentRow,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (
            StudentRow,
            BaseReferences<_$AppDatabase, $StudentsTable, StudentRow>,
          ),
          StudentRow,
          PrefetchHooks Function()
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> nim = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sksSemester = const Value.absent(),
                Value<int> sksTotal = const Value.absent(),
                Value<double> ipSemester = const Value.absent(),
                Value<double> ipCumulative = const Value.absent(),
                Value<int> lastFetched = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion(
                nim: nim,
                name: name,
                sksSemester: sksSemester,
                sksTotal: sksTotal,
                ipSemester: ipSemester,
                ipCumulative: ipCumulative,
                lastFetched: lastFetched,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String nim,
                required String name,
                required int sksSemester,
                required int sksTotal,
                required double ipSemester,
                required double ipCumulative,
                required int lastFetched,
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion.insert(
                nim: nim,
                name: name,
                sksSemester: sksSemester,
                sksTotal: sksTotal,
                ipSemester: ipSemester,
                ipCumulative: ipCumulative,
                lastFetched: lastFetched,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudentsTable, StudentRow>(table),
                  BaseReferences<_$AppDatabase, $StudentsTable, StudentRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      StudentRow,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (StudentRow, BaseReferences<_$AppDatabase, $StudentsTable, StudentRow>),
      StudentRow,
      PrefetchHooks Function()
    >;
typedef $$CoursesTableCreateCompanionBuilder = CoursesCompanion Function({
  Value<int> id,
  required String name,
  required String code,
  required int colorIndex,
  required int grade,
  required String letter,
  required int taskScore,
  required int attendScore,
  required int utsScore,
  required int uasScore,
  required int attendPercent,
  required int attendCount,
  required int permitCount,
  required int sickCount,
  required int alphaCount,
  required int lastFetched,
});
typedef $$CoursesTableUpdateCompanionBuilder = CoursesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> code,
  Value<int> colorIndex,
  Value<int> grade,
  Value<String> letter,
  Value<int> taskScore,
  Value<int> attendScore,
  Value<int> utsScore,
  Value<int> uasScore,
  Value<int> attendPercent,
  Value<int> attendCount,
  Value<int> permitCount,
  Value<int> sickCount,
  Value<int> alphaCount,
  Value<int> lastFetched,
});

final class $$CoursesTableReferences
    extends BaseReferences<_$AppDatabase, $CoursesTable, CourseRow> {
  $$CoursesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AssessmentsTable, List<AssessmentRow>>
  _assessmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.assessments,
    aliasName: 'courses__id__assessments__course_id',
  );

  $$AssessmentsTableProcessedTableManager get assessmentsRefs {
    final manager = $$AssessmentsTableTableManager(
      $_db,
      $_db.assessments,
    ).filter((f) => f.courseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_assessmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttendanceLogsTable, List<AttendanceRow>>
  _attendanceLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attendanceLogs,
    aliasName: 'courses__id__attendance_logs__course_id',
  );

  $$AttendanceLogsTableProcessedTableManager get attendanceLogsRefs {
    final manager = $$AttendanceLogsTableTableManager(
      $_db,
      $_db.attendanceLogs,
    ).filter((f) => f.courseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FeedbackNotesTable, List<FeedbackRow>>
  _feedbackNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.feedbackNotes,
    aliasName: 'courses__id__feedback_notes__course_id',
  );

  $$FeedbackNotesTableProcessedTableManager get feedbackNotesRefs {
    final manager = $$FeedbackNotesTableTableManager(
      $_db,
      $_db.feedbackNotes,
    ).filter((f) => f.courseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_feedbackNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CoursesTableFilterComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get letter => $composableBuilder(
    column: $table.letter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskScore => $composableBuilder(
    column: $table.taskScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attendScore => $composableBuilder(
    column: $table.attendScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get utsScore => $composableBuilder(
    column: $table.utsScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uasScore => $composableBuilder(
    column: $table.uasScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attendPercent => $composableBuilder(
    column: $table.attendPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attendCount => $composableBuilder(
    column: $table.attendCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get permitCount => $composableBuilder(
    column: $table.permitCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sickCount => $composableBuilder(
    column: $table.sickCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alphaCount => $composableBuilder(
    column: $table.alphaCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> assessmentsRefs(
    Expression<bool> Function($$AssessmentsTableFilterComposer f) f,
  ) {
    final $$AssessmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssessmentsTableFilterComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attendanceLogsRefs(
    Expression<bool> Function($$AttendanceLogsTableFilterComposer f) f,
  ) {
    final $$AttendanceLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendanceLogs,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceLogsTableFilterComposer(
            $db: $db,
            $table: $db.attendanceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> feedbackNotesRefs(
    Expression<bool> Function($$FeedbackNotesTableFilterComposer f) f,
  ) {
    final $$FeedbackNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feedbackNotes,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedbackNotesTableFilterComposer(
            $db: $db,
            $table: $db.feedbackNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get letter => $composableBuilder(
    column: $table.letter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskScore => $composableBuilder(
    column: $table.taskScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attendScore => $composableBuilder(
    column: $table.attendScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get utsScore => $composableBuilder(
    column: $table.utsScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uasScore => $composableBuilder(
    column: $table.uasScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attendPercent => $composableBuilder(
    column: $table.attendPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attendCount => $composableBuilder(
    column: $table.attendCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get permitCount => $composableBuilder(
    column: $table.permitCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sickCount => $composableBuilder(
    column: $table.sickCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alphaCount => $composableBuilder(
    column: $table.alphaCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<String> get letter =>
      $composableBuilder(column: $table.letter, builder: (column) => column);

  GeneratedColumn<int> get taskScore =>
      $composableBuilder(column: $table.taskScore, builder: (column) => column);

  GeneratedColumn<int> get attendScore => $composableBuilder(
    column: $table.attendScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get utsScore =>
      $composableBuilder(column: $table.utsScore, builder: (column) => column);

  GeneratedColumn<int> get uasScore =>
      $composableBuilder(column: $table.uasScore, builder: (column) => column);

  GeneratedColumn<int> get attendPercent => $composableBuilder(
    column: $table.attendPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attendCount => $composableBuilder(
    column: $table.attendCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get permitCount => $composableBuilder(
    column: $table.permitCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sickCount =>
      $composableBuilder(column: $table.sickCount, builder: (column) => column);

  GeneratedColumn<int> get alphaCount => $composableBuilder(
    column: $table.alphaCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => column,
  );

  Expression<T> assessmentsRefs<T extends Object>(
    Expression<T> Function($$AssessmentsTableAnnotationComposer a) f,
  ) {
    final $$AssessmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assessments,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssessmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.assessments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attendanceLogsRefs<T extends Object>(
    Expression<T> Function($$AttendanceLogsTableAnnotationComposer a) f,
  ) {
    final $$AttendanceLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendanceLogs,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.attendanceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> feedbackNotesRefs<T extends Object>(
    Expression<T> Function($$FeedbackNotesTableAnnotationComposer a) f,
  ) {
    final $$FeedbackNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feedbackNotes,
      getReferencedColumn: (t) => t.courseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedbackNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.feedbackNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoursesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoursesTable,
          CourseRow,
          $$CoursesTableFilterComposer,
          $$CoursesTableOrderingComposer,
          $$CoursesTableAnnotationComposer,
          $$CoursesTableCreateCompanionBuilder,
          $$CoursesTableUpdateCompanionBuilder,
          (CourseRow, $$CoursesTableReferences),
          CourseRow,
          PrefetchHooks Function({
            bool assessmentsRefs,
            bool attendanceLogsRefs,
            bool feedbackNotesRefs,
          })
        > {
  $$CoursesTableTableManager(_$AppDatabase db, $CoursesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> colorIndex = const Value.absent(),
                Value<int> grade = const Value.absent(),
                Value<String> letter = const Value.absent(),
                Value<int> taskScore = const Value.absent(),
                Value<int> attendScore = const Value.absent(),
                Value<int> utsScore = const Value.absent(),
                Value<int> uasScore = const Value.absent(),
                Value<int> attendPercent = const Value.absent(),
                Value<int> attendCount = const Value.absent(),
                Value<int> permitCount = const Value.absent(),
                Value<int> sickCount = const Value.absent(),
                Value<int> alphaCount = const Value.absent(),
                Value<int> lastFetched = const Value.absent(),
              }) => CoursesCompanion(
                id: id,
                name: name,
                code: code,
                colorIndex: colorIndex,
                grade: grade,
                letter: letter,
                taskScore: taskScore,
                attendScore: attendScore,
                utsScore: utsScore,
                uasScore: uasScore,
                attendPercent: attendPercent,
                attendCount: attendCount,
                permitCount: permitCount,
                sickCount: sickCount,
                alphaCount: alphaCount,
                lastFetched: lastFetched,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String code,
                required int colorIndex,
                required int grade,
                required String letter,
                required int taskScore,
                required int attendScore,
                required int utsScore,
                required int uasScore,
                required int attendPercent,
                required int attendCount,
                required int permitCount,
                required int sickCount,
                required int alphaCount,
                required int lastFetched,
              }) => CoursesCompanion.insert(
                id: id,
                name: name,
                code: code,
                colorIndex: colorIndex,
                grade: grade,
                letter: letter,
                taskScore: taskScore,
                attendScore: attendScore,
                utsScore: utsScore,
                uasScore: uasScore,
                attendPercent: attendPercent,
                attendCount: attendCount,
                permitCount: permitCount,
                sickCount: sickCount,
                alphaCount: alphaCount,
                lastFetched: lastFetched,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoursesTable, CourseRow>(table),
                  $$CoursesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                assessmentsRefs = false,
                attendanceLogsRefs = false,
                feedbackNotesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (assessmentsRefs) db.assessments,
                    if (attendanceLogsRefs) db.attendanceLogs,
                    if (feedbackNotesRefs) db.feedbackNotes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (assessmentsRefs)
                        await $_getPrefetchedData<
                          CourseRow,
                          $CoursesTable,
                          AssessmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$CoursesTableReferences
                              ._assessmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).assessmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.courseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attendanceLogsRefs)
                        await $_getPrefetchedData<
                          CourseRow,
                          $CoursesTable,
                          AttendanceRow
                        >(
                          currentTable: table,
                          referencedTable: $$CoursesTableReferences
                              ._attendanceLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).attendanceLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.courseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (feedbackNotesRefs)
                        await $_getPrefetchedData<
                          CourseRow,
                          $CoursesTable,
                          FeedbackRow
                        >(
                          currentTable: table,
                          referencedTable: $$CoursesTableReferences
                              ._feedbackNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CoursesTableReferences(
                                db,
                                table,
                                p0,
                              ).feedbackNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.courseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CoursesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoursesTable,
      CourseRow,
      $$CoursesTableFilterComposer,
      $$CoursesTableOrderingComposer,
      $$CoursesTableAnnotationComposer,
      $$CoursesTableCreateCompanionBuilder,
      $$CoursesTableUpdateCompanionBuilder,
      (CourseRow, $$CoursesTableReferences),
      CourseRow,
      PrefetchHooks Function({
        bool assessmentsRefs,
        bool attendanceLogsRefs,
        bool feedbackNotesRefs,
      })
    >;
typedef $$AssessmentsTableCreateCompanionBuilder =
    AssessmentsCompanion Function({
      Value<int> id,
      required int courseId,
      required String title,
      required String status,
      Value<int?> score,
      required int position,
    });
typedef $$AssessmentsTableUpdateCompanionBuilder =
    AssessmentsCompanion Function({
      Value<int> id,
      Value<int> courseId,
      Value<String> title,
      Value<String> status,
      Value<int?> score,
      Value<int> position,
    });

final class $$AssessmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AssessmentsTable, AssessmentRow> {
  $$AssessmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CoursesTable _courseIdTable(_$AppDatabase db) =>
      db.courses.createAlias('assessments__course_id__courses__id');

  $$CoursesTableProcessedTableManager get courseId {
    final $_column = $_itemColumn<int>('course_id')!;

    final manager = $$CoursesTableTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AssessmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AssessmentsTable> {
  $$AssessmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$CoursesTableFilterComposer get courseId {
    final $$CoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssessmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssessmentsTable> {
  $$AssessmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$CoursesTableOrderingComposer get courseId {
    final $$CoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableOrderingComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssessmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssessmentsTable> {
  $$AssessmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$CoursesTableAnnotationComposer get courseId {
    final $$CoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssessmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssessmentsTable,
          AssessmentRow,
          $$AssessmentsTableFilterComposer,
          $$AssessmentsTableOrderingComposer,
          $$AssessmentsTableAnnotationComposer,
          $$AssessmentsTableCreateCompanionBuilder,
          $$AssessmentsTableUpdateCompanionBuilder,
          (AssessmentRow, $$AssessmentsTableReferences),
          AssessmentRow,
          PrefetchHooks Function({bool courseId})
        > {
  $$AssessmentsTableTableManager(_$AppDatabase db, $AssessmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssessmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssessmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssessmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => AssessmentsCompanion(
                id: id,
                courseId: courseId,
                title: title,
                status: status,
                score: score,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int courseId,
                required String title,
                required String status,
                Value<int?> score = const Value.absent(),
                required int position,
              }) => AssessmentsCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                status: status,
                score: score,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssessmentsTable, AssessmentRow>(table),
                  $$AssessmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({courseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (courseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.courseId,
                        referencedTable: $$AssessmentsTableReferences
                            ._courseIdTable(db),
                        referencedColumn: $$AssessmentsTableReferences
                            ._courseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AssessmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssessmentsTable,
      AssessmentRow,
      $$AssessmentsTableFilterComposer,
      $$AssessmentsTableOrderingComposer,
      $$AssessmentsTableAnnotationComposer,
      $$AssessmentsTableCreateCompanionBuilder,
      $$AssessmentsTableUpdateCompanionBuilder,
      (AssessmentRow, $$AssessmentsTableReferences),
      AssessmentRow,
      PrefetchHooks Function({bool courseId})
    >;
typedef $$AttendanceLogsTableCreateCompanionBuilder =
    AttendanceLogsCompanion Function({
      Value<int> id,
      required int courseId,
      required String title,
      required String status,
      required int position,
    });
typedef $$AttendanceLogsTableUpdateCompanionBuilder =
    AttendanceLogsCompanion Function({
      Value<int> id,
      Value<int> courseId,
      Value<String> title,
      Value<String> status,
      Value<int> position,
    });

final class $$AttendanceLogsTableReferences
    extends BaseReferences<_$AppDatabase, $AttendanceLogsTable, AttendanceRow> {
  $$AttendanceLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CoursesTable _courseIdTable(_$AppDatabase db) =>
      db.courses.createAlias('attendance_logs__course_id__courses__id');

  $$CoursesTableProcessedTableManager get courseId {
    final $_column = $_itemColumn<int>('course_id')!;

    final manager = $$CoursesTableTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttendanceLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceLogsTable> {
  $$AttendanceLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$CoursesTableFilterComposer get courseId {
    final $$CoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceLogsTable> {
  $$AttendanceLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$CoursesTableOrderingComposer get courseId {
    final $$CoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableOrderingComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceLogsTable> {
  $$AttendanceLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$CoursesTableAnnotationComposer get courseId {
    final $$CoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceLogsTable,
          AttendanceRow,
          $$AttendanceLogsTableFilterComposer,
          $$AttendanceLogsTableOrderingComposer,
          $$AttendanceLogsTableAnnotationComposer,
          $$AttendanceLogsTableCreateCompanionBuilder,
          $$AttendanceLogsTableUpdateCompanionBuilder,
          (AttendanceRow, $$AttendanceLogsTableReferences),
          AttendanceRow,
          PrefetchHooks Function({bool courseId})
        > {
  $$AttendanceLogsTableTableManager(
    _$AppDatabase db,
    $AttendanceLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => AttendanceLogsCompanion(
                id: id,
                courseId: courseId,
                title: title,
                status: status,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int courseId,
                required String title,
                required String status,
                required int position,
              }) => AttendanceLogsCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                status: status,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttendanceLogsTable, AttendanceRow>(table),
                  $$AttendanceLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({courseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (courseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.courseId,
                        referencedTable: $$AttendanceLogsTableReferences
                            ._courseIdTable(db),
                        referencedColumn: $$AttendanceLogsTableReferences
                            ._courseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttendanceLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceLogsTable,
      AttendanceRow,
      $$AttendanceLogsTableFilterComposer,
      $$AttendanceLogsTableOrderingComposer,
      $$AttendanceLogsTableAnnotationComposer,
      $$AttendanceLogsTableCreateCompanionBuilder,
      $$AttendanceLogsTableUpdateCompanionBuilder,
      (AttendanceRow, $$AttendanceLogsTableReferences),
      AttendanceRow,
      PrefetchHooks Function({bool courseId})
    >;
typedef $$FeedbackNotesTableCreateCompanionBuilder =
    FeedbackNotesCompanion Function({
      Value<int> id,
      required int courseId,
      required String title,
      required String body,
      required int position,
    });
typedef $$FeedbackNotesTableUpdateCompanionBuilder =
    FeedbackNotesCompanion Function({
      Value<int> id,
      Value<int> courseId,
      Value<String> title,
      Value<String> body,
      Value<int> position,
    });

final class $$FeedbackNotesTableReferences
    extends BaseReferences<_$AppDatabase, $FeedbackNotesTable, FeedbackRow> {
  $$FeedbackNotesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CoursesTable _courseIdTable(_$AppDatabase db) =>
      db.courses.createAlias('feedback_notes__course_id__courses__id');

  $$CoursesTableProcessedTableManager get courseId {
    final $_column = $_itemColumn<int>('course_id')!;

    final manager = $$CoursesTableTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FeedbackNotesTableFilterComposer
    extends Composer<_$AppDatabase, $FeedbackNotesTable> {
  $$FeedbackNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$CoursesTableFilterComposer get courseId {
    final $$CoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedbackNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedbackNotesTable> {
  $$FeedbackNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$CoursesTableOrderingComposer get courseId {
    final $$CoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableOrderingComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedbackNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedbackNotesTable> {
  $$FeedbackNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$CoursesTableAnnotationComposer get courseId {
    final $$CoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courseId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedbackNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedbackNotesTable,
          FeedbackRow,
          $$FeedbackNotesTableFilterComposer,
          $$FeedbackNotesTableOrderingComposer,
          $$FeedbackNotesTableAnnotationComposer,
          $$FeedbackNotesTableCreateCompanionBuilder,
          $$FeedbackNotesTableUpdateCompanionBuilder,
          (FeedbackRow, $$FeedbackNotesTableReferences),
          FeedbackRow,
          PrefetchHooks Function({bool courseId})
        > {
  $$FeedbackNotesTableTableManager(_$AppDatabase db, $FeedbackNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedbackNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedbackNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedbackNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => FeedbackNotesCompanion(
                id: id,
                courseId: courseId,
                title: title,
                body: body,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int courseId,
                required String title,
                required String body,
                required int position,
              }) => FeedbackNotesCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                body: body,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FeedbackNotesTable, FeedbackRow>(table),
                  $$FeedbackNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({courseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (courseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.courseId,
                        referencedTable: $$FeedbackNotesTableReferences
                            ._courseIdTable(db),
                        referencedColumn: $$FeedbackNotesTableReferences
                            ._courseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FeedbackNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedbackNotesTable,
      FeedbackRow,
      $$FeedbackNotesTableFilterComposer,
      $$FeedbackNotesTableOrderingComposer,
      $$FeedbackNotesTableAnnotationComposer,
      $$FeedbackNotesTableCreateCompanionBuilder,
      $$FeedbackNotesTableUpdateCompanionBuilder,
      (FeedbackRow, $$FeedbackNotesTableReferences),
      FeedbackRow,
      PrefetchHooks Function({bool courseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$CoursesTableTableManager get courses =>
      $$CoursesTableTableManager(_db, _db.courses);
  $$AssessmentsTableTableManager get assessments =>
      $$AssessmentsTableTableManager(_db, _db.assessments);
  $$AttendanceLogsTableTableManager get attendanceLogs =>
      $$AttendanceLogsTableTableManager(_db, _db.attendanceLogs);
  $$FeedbackNotesTableTableManager get feedbackNotes =>
      $$FeedbackNotesTableTableManager(_db, _db.feedbackNotes);
}
