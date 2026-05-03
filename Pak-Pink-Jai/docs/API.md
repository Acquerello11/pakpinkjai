# Pak Pink Jai — API Documentation

Base URL: `http://localhost:3001/api`

## Authentication
ทุก endpoint (ยกเว้น auth) ต้องส่ง header:
```
Authorization: Bearer <token>
```

---

## 🔐 Auth

### POST /auth/register
สมัครสมาชิก
```json
Body: { "name": "มิ้นท์", "email": "mint@example.com", "password": "secret123" }
Response: { "token": "jwt...", "user": { "id": "...", "name": "มิ้นท์", "streak": 0 } }
```

### POST /auth/login
เข้าสู่ระบบ
```json
Body: { "email": "mint@example.com", "password": "secret123" }
Response: { "token": "jwt...", "user": { ... } }
```

### GET /auth/me
ดึงข้อมูล user ปัจจุบัน
```json
Response: { "user": { "name": "...", "streak": 5, "moodScore": 75 } }
```

---

## 📝 Journal

### POST /journal
บันทึก entry + รับ AI reflection
```json
Body: {
  "mood": "เครียด",
  "intensity": 7,
  "tags": ["💼 งาน", "💰 เงิน"],
  "text": "วันนี้งานเยอะมากเลย..."
}
Response: {
  "success": true,
  "entry": { "_id": "...", "mood": "เครียด", ... },
  "ai": {
    "reflection": "วันนี้ดาวอาทิตย์...",
    "safeActions": ["รอ 24 ชม.", "เขียน pros/cons", "โทรหาคนที่ไว้ใจ"],
    "insight": "วันนี้ให้ใจตัวเองพัก..."
  },
  "riskAlert": false
}

// กรณีความเสี่ยงสูง:
Response: {
  "success": true,
  "riskAlert": true,
  "reply": "ฉันเป็นห่วงคุณ...",
  "showHotline": true,
  "hotlineNumber": "1323"
}
```

### GET /journal
ดึงรายการ entries
```
Query: ?limit=20&skip=0&mood=เครียด&tag=งาน
Response: { "entries": [...], "total": 42, "hasMore": true }
```

### DELETE /journal/:id
ลบ entry

---

## 💬 Chat

### POST /chat/message
ส่งข้อความและรับ AI reply
```json
Body: { "message": "วันนี้เครียดมาก", "sessionId": "uuid-optional" }
Response: {
  "reply": "ฟังอยู่นะ...",
  "sessionId": "uuid",
  "riskLevel": "low",
  "showHotline": false
}
```

### GET /chat/history
ดึง chat history
```
Query: ?sessionId=uuid&limit=30
Response: { "messages": [{ "role": "user", "content": "..." }, ...] }
```

### POST /chat/session
เริ่ม session ใหม่
```json
Response: { "sessionId": "new-uuid" }
```

---

## 📊 Analytics

### GET /analytics/weekly
รายงานสัปดาห์
```json
Response: {
  "score": 75,
  "scoreTrend": "↑ ดีขึ้น 12%",
  "checkInCount": 5,
  "streak": 5,
  "totalEntries": 23,
  "safeActionsCompleted": 4,
  "moodRanking": [
    { "mood": "เครียด", "emoji": "😤", "count": 3 },
    { "mood": "โอเค", "emoji": "😌", "count": 2 }
  ],
  "patternInsight": "คุณมักเครียดช่วงต้นสัปดาห์..."
}
```

### GET /analytics/heatmap
Heatmap 30 วัน
```json
Response: {
  "heatmap": [
    { "date": "2026-04-04", "level": 0 },
    { "date": "2026-04-05", "level": 2 },
    ...
  ]
}
// level: 0=ไม่ได้ check-in, 1=check-in, 2=อารมณ์ดี, 3=อารมณ์ดีมาก
```

### GET /analytics/score
Mood score ปัจจุบัน
```json
Response: { "moodScore": 75, "streak": 5, "lastCheckIn": "2026-05-03T...", "latestMood": "โอเค" }
```

---

## 👤 User

### GET /user/profile
ดึง profile

### POST /user/pause
Decision Pause
```json
Body: { "input": "อยากลาออกทันที" }
Response: {
  "success": true,
  "ai": {
    "saferAlts": ["รอ 24 ชม.", "ลองคุยกับหัวหน้า", "หางานสำรอง"],
    "advice": "ลองหยุดคิดก่อนนะ..."
  },
  "riskAlert": false
}
```

### POST /user/safe-action
บันทึก safe action สำเร็จ
```json
Response: { "success": true }
```

---

## Error Responses
```json
{ "error": "Unauthorized" }           // 401
{ "error": "อีเมลนี้ถูกใช้แล้ว" }    // 409
{ "error": "Internal server error" }   // 500
```
