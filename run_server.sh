#!/bin/bash

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "⚠️  No .env file found!"
    echo "Please create a .env file with your API keys."
    echo "See SETUP_GUIDE.md for instructions."
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

echo "="*60
echo "  Starting FuelAI Agents Web Server"
echo "="*60
echo ""
echo "🚀 Server will be available at:"
echo "   - API: http://localhost:8000"
echo "   - Docs: http://localhost:8000/docs"
echo "   - Discovery UI: http://localhost:8000/discovery/ui"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Start the server
uvicorn app.main:app --reload --port 8000

