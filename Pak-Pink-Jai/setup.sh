#!/bin/bash
# ─────────────────────────────────────────────
#  Pak Pink Jai — Setup Script
#  รัน: chmod +x setup.sh && ./setup.sh
# ─────────────────────────────────────────────
set -e

echo "🌿 Pak Pink Jai — Project Setup"
echo "================================"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Install from https://nodejs.org"
    exit 1
fi
echo "✅ Node.js $(node -v)"

# Check MongoDB
if ! command -v mongod &> /dev/null; then
    echo "⚠️  MongoDB not found locally."
    echo "   Option 1: Install MongoDB: https://www.mongodb.com/try/download/community"
    echo "   Option 2: Use MongoDB Atlas (cloud): https://cloud.mongodb.com"
    echo "   Option 3: Use Docker: docker run -d -p 27017:27017 mongo"
    echo ""
fi

# Install backend dependencies
echo ""
echo "📦 Installing backend dependencies..."
cd backend
npm install
echo "✅ Backend dependencies installed"

# Setup .env
if [ ! -f .env ]; then
    cp .env.example .env
    echo ""
    echo "⚙️  Created .env file. Please edit it:"
    echo "   1. Add your ANTHROPIC_API_KEY"
    echo "   2. Set MONGODB_URI if not using localhost"
    echo "   3. Change JWT_SECRET to a random string"
    echo ""
    echo "   Get Claude API key: https://console.anthropic.com"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit backend/.env with your API keys"
echo "  2. Start MongoDB (if local)"
echo "  3. Run: cd backend && npm run dev"
echo "  4. Open: frontend/index.html in browser"
echo ""
echo "API will run on: http://localhost:3001"
echo "Health check:   http://localhost:3001/health"
