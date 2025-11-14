#!/bin/bash

echo "======================================================"
echo "  FuelAI Agents - Quick Setup"
echo "======================================================"
echo ""

# Check if .env exists
if [ -f .env ]; then
    echo "⚠ .env file already exists!"
    read -p "Do you want to overwrite it? (y/n): " overwrite
    if [ "$overwrite" != "y" ]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

echo "Let's configure your environment..."
echo ""

# Apify Token
echo "1. APIFY TOKEN (required for Instagram scraping)"
echo "   Get it from: https://console.apify.com/account/integrations"
read -p "   Enter your Apify token: " APIFY_TOKEN

# OpenAI Key
echo ""
echo "2. OPENAI API KEY (required for AI agents)"
echo "   Get it from: https://platform.openai.com/api-keys"
read -p "   Enter your OpenAI API key: " OPENAI_API_KEY

# OpenAI Project ID (optional)
echo ""
echo "3. OPENAI PROJECT ID (optional)"
read -p "   Enter your OpenAI project ID (press Enter to skip): " OPENAI_PROJECT_ID

# Instagram Session
echo ""
echo "4. INSTAGRAM SESSION COOKIE (optional but recommended)"
echo "   Get it from: Browser Dev Tools → Cookies → sessionid"
read -p "   Enter your Instagram sessionid (press Enter to skip): " IG_SESSIONID

# Create .env file
echo ""
echo "Creating .env file..."

cat > .env << EOF
# OpenAI Configuration
OPENAI_API_KEY=${OPENAI_API_KEY}
OPENAI_PROJECT_ID=${OPENAI_PROJECT_ID}

# Apify Configuration
APIFY_TOKEN=${APIFY_TOKEN}

# Instagram Session Cookie
IG_SESSIONID=${IG_SESSIONID}

# Database Configuration (for Docker)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=asa
DB_USER=postgres
DB_PASSWORD=postgres

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379

# MinIO Configuration
MINIO_ENDPOINT=localhost:9000
MINIO_ACCESS_KEY=minio
MINIO_SECRET_KEY=minio123
MINIO_BUCKET=asa-media
EOF

echo "✓ .env file created!"
echo ""

# Test Apify connection
echo "======================================================"
echo "Testing Apify connection..."
echo "======================================================"

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Activate venv if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Run test
python3 test_apify.py

echo ""
echo "======================================================"
echo "Next steps:"
echo "======================================================"
echo "1. Start Docker services: make up"
echo "2. Initialize database: make init"
echo "3. Start web server: uvicorn app.main:app --reload"
echo "4. Visit: http://localhost:8000/discovery/ui"
echo ""

