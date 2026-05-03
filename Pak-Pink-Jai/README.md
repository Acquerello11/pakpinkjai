# 🌿 Pak Pink Jai — Full Project

> AI Mental Health Coach สำหรับคนทำงานไทย

## Stack
- **Frontend**: HTML/CSS/JS (Web App) → ย้ายเป็น React Native ได้
- **Backend**: Node.js + Express
- **Database**: MongoDB (local) / Azure Cosmos DB (production)
- **AI**: Anthropic Claude API
- **Deploy**: Azure App Service

## Quick Start

```bash
# 1. Clone & install
cd pakpinkjai/backend
npm install

# 2. ตั้งค่า environment
cp .env.example .env
# แก้ไข ANTHROPIC_API_KEY ใน .env

# 3. รัน backend
npm run dev

# 4. เปิด frontend
open frontend/index.html
```

## Structure
```
pakpinkjai/
├── backend/          ← Node.js API server (port 3001)
│   ├── server.js     ← entry point
│   ├── routes/       ← API endpoints
│   ├── models/       ← MongoDB schemas
│   ├── middleware/   ← auth, guardrail
│   └── services/     ← AI, analytics
├── frontend/         ← Web app (เปิดได้เลย)
│   ├── index.html    ← main app
│   └── src/          ← components
└── docs/             ← API documentation
```
