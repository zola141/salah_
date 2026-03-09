#!/bin/bash

echo "🚀 Starting LudoX Project Setup..."
echo "=================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Node.js found: $(node -v)${NC}"

# Function to install dependencies and build
install_and_build() {
    local dir=$1
    local name=$2
    
    echo ""
    echo -e "${BLUE}📦 Installing dependencies for $name...${NC}"
    cd "$dir" || exit 1
    
    if [ ! -d "node_modules" ]; then
        echo "Installing npm packages..."
        npm install
    else
        echo "Dependencies already installed, checking for updates..."
        npm install
    fi
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install dependencies for $name${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Dependencies installed for $name${NC}"
    
    # Build if package.json has a build script
    if grep -q '"build"' package.json 2>/dev/null; then
        echo -e "${BLUE}🔨 Building $name...${NC}"
        npm run build
        
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Failed to build $name${NC}"
            exit 1
        fi
        
        echo -e "${GREEN}✓ Build completed for $name${NC}"
    fi
    
    cd - > /dev/null
}

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT" || exit 1

# 1. Install root dependencies
echo -e "${BLUE}📦 Installing root dependencies...${NC}"
npm install
echo -e "${GREEN}✓ Root dependencies installed${NC}"

# 2. Install and build thegame (Vite React app)
if [ -d "thegame" ]; then
    install_and_build "thegame" "Game (Vite)"
else
    echo -e "${RED}⚠️  thegame directory not found${NC}"
fi

# 3. Install and build kamal_part (Homepage)
if [ -d "kamal_part" ]; then
    install_and_build "kamal_part" "Homepage (Kamal)"
else
    echo -e "${RED}⚠️  kamal_part directory not found${NC}"
fi

# 4. Install and build hamza_part (Analytics/Leaderboard)
if [ -d "hamza_part" ]; then
    install_and_build "hamza_part" "Analytics (Hamza)"
else
    echo -e "${RED}⚠️  hamza_part directory not found${NC}"
fi

# Back to project root
cd "$PROJECT_ROOT" || exit 1

echo ""
echo "=================================="
echo -e "${GREEN}✅ All dependencies installed and built!${NC}"
echo ""

# Stop any existing server
echo -e "${BLUE}🛑 Stopping any existing server...${NC}"
pkill -f "node server.js" 2>/dev/null
sleep 1

# Start the server
echo -e "${BLUE}🚀 Starting server...${NC}"
echo ""

node server.js
