# NEXA Backend (Express + Sequelize + XAMPP MySQL)

REST API for the Flutter app in `../frontend`.

## 1. Prerequisites

- XAMPP MySQL running on `127.0.0.1:3306`
- Node.js 20+
- Database `lecturer_assistant` already imported in phpMyAdmin
  (the SQL dump is `N:/lecturer_assistant.sql`)

Default XAMPP credentials used by the API:

```
host: 127.0.0.1
port: 3306
database: lecturer_assistant
user: root
password: (empty)
```

Copy `.env.example` to `.env` if you need to change them.

## 2. Install & seed

```bash
cd backend
npm install
npm run seed
```

`npm run seed` is idempotent: if `courses` already has rows it does nothing.
It creates 7 demo courses, classes, enrollments, assessments, scores,
attendance and feedback for the existing demo student.

Demo login for the mobile app:

```
NIM: 253100000000
Password: password123
```

## 3. Run

```bash
npm start       # normal
npm run dev     # auto-reload with node --watch
```

Test it:

```bash
curl http://localhost:3000/health
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"nim":"253100000000","password":"password123"}'
```

## 4. Endpoints used by Flutter

| Method | Path | Auth |
| --- | --- | --- |
| POST | `/auth/login` | no |
| POST | `/auth/refresh` | no |
| GET | `/student/me` | Bearer token |
| GET | `/student/courses` | Bearer token |
| GET | `/health` | no |

The response shape matches `frontend/lib/data/remote/http_nexa_api.dart`.

## 5. Connect the Flutter app

The app uses the real API by default (`NEXA_USE_MOCK=false`).

| Target | Base URL | Command |
| --- | --- | --- |
| Android emulator | `http://10.0.2.2:3000` | `cd frontend && flutter run` |
| Windows / Chrome | `http://localhost:3000` | `cd frontend && flutter run -d windows` |
| Physical phone | PC LAN IP | `flutter run --dart-define=NEXA_API_BASE_URL=http://<PC-LAN-IP>:3000` |

Check the PC LAN IP with `ipconfig` (example: `192.168.100.16`). The phone and
PC must be on the same Wi-Fi, and Windows Firewall must allow Node.js on
port 3000.

To force the old offline sample data instead:

```bash
flutter run --dart-define=NEXA_USE_MOCK=true
```

## Notes / limitations

- The DB schema has no weekly timetable/room table, so `schedule` is returned
  as `[]`; the reminder feature simply has nothing to schedule yet.
- `attendance_records.status` (`present/late/absent/excused`) is mapped to the
  app's `attend/permit/sick/alpha` values.
- The current `lecturer_assistant` database does not contain the `ai_*`
  tables from the SQL dump; they are not required by the mobile API.
