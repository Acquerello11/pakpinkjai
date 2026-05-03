# ─────────────────────────────────────────────
#  Pak Pink Jai — Azure Deployment Script
#  รัน: bash deploy-azure.sh
#  ต้องติดตั้ง: Azure CLI (az)
# ─────────────────────────────────────────────

# ── CONFIG — แก้ไขตรงนี้ ──
RESOURCE_GROUP="pakpinkjai-rg"
LOCATION="southeastasia"
APP_NAME="pakpinkjai-api"          # ต้องเป็นชื่อที่ unique บน Azure
DB_NAME="pakpinkjai-cosmos"
PLAN_NAME="pakpinkjai-plan"

echo "🌿 Deploying Pak Pink Jai to Azure..."
echo "Resource Group: $RESOURCE_GROUP"
echo "App Name: $APP_NAME"
echo "Location: $LOCATION"
echo ""

# 1. Login
echo "1️⃣  Login to Azure..."
az login

# 2. Create Resource Group
echo "2️⃣  Creating Resource Group..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# 3. Create Azure Cosmos DB (MongoDB API)
echo "3️⃣  Creating Cosmos DB (MongoDB)..."
az cosmosdb create \
  --name $DB_NAME \
  --resource-group $RESOURCE_GROUP \
  --kind MongoDB \
  --server-version 4.2 \
  --capabilities EnableMongo

# Get connection string
COSMOS_URI=$(az cosmosdb keys list \
  --name $DB_NAME \
  --resource-group $RESOURCE_GROUP \
  --type connection-strings \
  --query "connectionStrings[0].connectionString" -o tsv)

echo "✅ Cosmos DB created"

# 4. Create App Service Plan
echo "4️⃣  Creating App Service Plan..."
az appservice plan create \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --sku B1 \
  --is-linux

# 5. Create Web App
echo "5️⃣  Creating Web App..."
az webapp create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --plan $PLAN_NAME \
  --runtime "NODE:18-lts"

# 6. Configure Environment Variables
echo "6️⃣  Setting environment variables..."
# !! ใส่ค่าจริงก่อน deploy !!
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    NODE_ENV=production \
    PORT=8080 \
    MONGODB_URI="$COSMOS_URI" \
    JWT_SECRET="$(openssl rand -hex 32)" \
    ANTHROPIC_API_KEY="sk-ant-api03-YOUR-KEY-HERE" \
    FRONTEND_URL="https://YOUR-FRONTEND-URL.com"

# 7. Enable logging
echo "7️⃣  Enabling logging..."
az webapp log config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --application-logging filesystem \
  --level information

# 8. Deploy code
echo "8️⃣  Deploying code..."
cd backend
az webapp deployment source config-local-git \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP

GIT_URL=$(az webapp deployment source show \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "repoUrl" -o tsv)

git init
git add .
git commit -m "Deploy Pak Pink Jai"
git remote add azure $GIT_URL
git push azure main

echo ""
echo "🎉 Deployment complete!"
echo "API URL: https://$APP_NAME.azurewebsites.net"
echo "Health:  https://$APP_NAME.azurewebsites.net/health"
echo ""
echo "Next: Update frontend/index.html API URL to:"
echo "  const API = 'https://$APP_NAME.azurewebsites.net/api'"
