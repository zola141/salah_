# ╔═══════════════════════════════════════════════════════════╗
# ║                   LudoX - Makefile                       ║
# ║     Works on any Ubuntu machine — NO sudo required       ║
# ╚═══════════════════════════════════════════════════════════╝

# ── Variables ─────────────────────────────────────────────
SHELL        := /bin/bash
PROJECT_ROOT := $(shell pwd)
NODE_VERSION := 20
PORT         := 3000

# NVM (Node Version Manager) — installed per-user, no sudo
export NVM_DIR := $(HOME)/.nvm
NVM_SH        := $(NVM_DIR)/nvm.sh

# Helper: source nvm before running node/npm commands
# This ensures node/npm are on PATH even inside make recipes
NVM_LOAD = . $(NVM_SH) 2>/dev/null || true

# Colors
GREEN  := \033[0;32m
BLUE   := \033[0;34m
RED    := \033[0;31m
YELLOW := \033[1;33m
NC     := \033[0m

# Sub-project directories
KAMAL_DIR     := $(PROJECT_ROOT)/kamal_part
THEGAME_DIR   := $(PROJECT_ROOT)/thegame
HAMZA_BE_DIR  := $(PROJECT_ROOT)/hamza_part/backend
HAMZA_FE_DIR  := $(PROJECT_ROOT)/hamza_part/frontend

# ── Default target ────────────────────────────────────────
.PHONY: all
all: setup install build dirs
	@echo -e "$(GREEN)✅  Everything is ready! Run 'make start' to launch the server.$(NC)"

# ── Setup (no sudo needed) ────────────────────────────────
.PHONY: setup
setup: setup-node
	@echo -e "$(GREEN)✅  System setup complete (no sudo used).$(NC)"

.PHONY: setup-node
setup-node:
	@echo -e "$(BLUE)🔍 Checking Node.js...$(NC)"
	@$(NVM_LOAD); \
	if command -v node >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓  Node.js $$(node -v) already installed.$(NC)"; \
		echo -e "$(BLUE)   npm  : $$(npm -v)$(NC)"; \
	else \
		echo -e "$(YELLOW)📦 Node.js not found — installing via nvm (no sudo)...$(NC)"; \
		if [ ! -f "$(NVM_SH)" ]; then \
			echo -e "$(YELLOW)   Installing nvm...$(NC)"; \
			curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash; \
		fi; \
		. $(NVM_SH); \
		echo -e "$(YELLOW)   Installing Node.js $(NODE_VERSION)...$(NC)"; \
		nvm install $(NODE_VERSION); \
		nvm use $(NODE_VERSION); \
		nvm alias default $(NODE_VERSION); \
		echo -e "$(GREEN)✓  Node.js $$(node -v) installed via nvm.$(NC)"; \
		echo -e "$(BLUE)   npm  : $$(npm -v)$(NC)"; \
		echo ""; \
		echo -e "$(YELLOW)💡 TIP: Add this to your ~/.bashrc or ~/.zshrc if not already there:$(NC)"; \
		echo -e '   export NVM_DIR="$$HOME/.nvm"'; \
		echo -e '   [ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh"'; \
	fi

# ── Install all npm dependencies ──────────────────────────
.PHONY: install
install: install-root install-thegame install-kamal install-hamza-backend install-hamza-frontend
	@echo -e "$(GREEN)✅  All dependencies installed.$(NC)"

.PHONY: install-root
install-root:
	@echo -e "$(BLUE)📦 Installing root dependencies...$(NC)"
	@$(NVM_LOAD); cd $(PROJECT_ROOT) && npm install --legacy-peer-deps
	@echo -e "$(GREEN)✓  Root deps done.$(NC)"

.PHONY: install-thegame
install-thegame:
	@echo -e "$(BLUE)📦 Installing thegame dependencies...$(NC)"
	@$(NVM_LOAD); \
	if [ -d "$(THEGAME_DIR)" ]; then \
		cd $(THEGAME_DIR) && npm install --legacy-peer-deps; \
		echo -e "$(GREEN)✓  thegame deps done.$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠️  thegame/ not found, skipping.$(NC)"; \
	fi

.PHONY: install-kamal
install-kamal:
	@echo -e "$(BLUE)📦 Installing kamal_part dependencies...$(NC)"
	@$(NVM_LOAD); \
	if [ -d "$(KAMAL_DIR)" ]; then \
		cd $(KAMAL_DIR) && npm install --legacy-peer-deps; \
		echo -e "$(GREEN)✓  kamal_part deps done.$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠️  kamal_part/ not found, skipping.$(NC)"; \
	fi

.PHONY: install-hamza-backend
install-hamza-backend:
	@echo -e "$(BLUE)📦 Installing hamza_part/backend dependencies...$(NC)"
	@$(NVM_LOAD); \
	if [ -d "$(HAMZA_BE_DIR)" ]; then \
		cd $(HAMZA_BE_DIR) && npm install --legacy-peer-deps; \
		echo -e "$(GREEN)✓  hamza backend deps done.$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠️  hamza_part/backend/ not found, skipping.$(NC)"; \
	fi

.PHONY: install-hamza-frontend
install-hamza-frontend:
	@echo -e "$(BLUE)📦 Installing hamza_part/frontend dependencies...$(NC)"
	@$(NVM_LOAD); \
	if [ -d "$(HAMZA_FE_DIR)" ]; then \
		cd $(HAMZA_FE_DIR) && npm install --legacy-peer-deps; \
		echo -e "$(GREEN)✓  hamza frontend deps done.$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠️  hamza_part/frontend/ not found, skipping.$(NC)"; \
	fi

# ── Build all frontend projects ───────────────────────────
.PHONY: build
build: build-thegame build-kamal build-hamza-frontend build-hamza-backend
	@echo -e "$(GREEN)✅  All builds complete.$(NC)"

.PHONY: build-thegame
build-thegame:
	@echo -e "$(BLUE)🔨 Building thegame (Vite)...$(NC)"
	@$(NVM_LOAD); \
	if [ -d "$(THEGAME_DIR)" ]; then \
		cd $(THEGAME_DIR) && npm run build; \
		echo -e "$(GREEN)✓  thegame built → thegame/dist/$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠️  thegame/ not found, skipping build.$(NC)"; \
	fi

.PHONY: build-kamal
build-kamal:
	@echo -e "$(BLUE)🔨 Building kamal_part (Vite)...$(NC)"
	@$(NVM_LOAD); \
	if [ -d "$(KAMAL_DIR)" ]; then \
		cd $(KAMAL_DIR) && npm run build; \
		echo -e "$(GREEN)✓  kamal_part built → kamal_part/dist/$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠️  kamal_part/ not found, skipping build.$(NC)"; \
	fi

.PHONY: build-hamza-frontend
build-hamza-frontend:
	@echo -e "$(BLUE)🔨 Building hamza_part/frontend (React)...$(NC)"
	@$(NVM_LOAD); \
	if [ -d "$(HAMZA_FE_DIR)" ]; then \
		cd $(HAMZA_FE_DIR) && npm run build; \
		echo -e "$(GREEN)✓  hamza frontend built → hamza_part/frontend/build/$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠️  hamza_part/frontend/ not found, skipping build.$(NC)"; \
	fi

.PHONY: build-hamza-backend
build-hamza-backend:
	@echo -e "$(BLUE)🔨 Building hamza_part/backend (TypeScript)...$(NC)"
	@$(NVM_LOAD); \
	if [ -d "$(HAMZA_BE_DIR)" ]; then \
		cd $(HAMZA_BE_DIR) && npm run build; \
		echo -e "$(GREEN)✓  hamza backend built → hamza_part/backend/dist/$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠️  hamza_part/backend/ not found, skipping build.$(NC)"; \
	fi

# ── Run the server ────────────────────────────────────────
.PHONY: start
start:
	@echo -e "$(BLUE)🚀 Starting LudoX server on port $(PORT)...$(NC)"
	@$(NVM_LOAD); cd $(PROJECT_ROOT) && node server.js

.PHONY: dev
dev:
	@echo -e "$(BLUE)🚀 Starting LudoX in dev mode (nodemon)...$(NC)"
	@$(NVM_LOAD); cd $(PROJECT_ROOT) && npx nodemon server.js

# ── Stop the server ───────────────────────────────────────
.PHONY: stop
stop:
	@echo -e "$(RED)🛑 Stopping server...$(NC)"
	@-pkill -f "node server.js" 2>/dev/null || true
	@-lsof -ti:$(PORT) | xargs kill -9 2>/dev/null || true
	@echo -e "$(GREEN)✓  Server stopped.$(NC)"

# ── Restart ───────────────────────────────────────────────
.PHONY: restart
restart: stop start

# ── Clean everything ──────────────────────────────────────
.PHONY: clean
clean:
	@echo -e "$(RED)🗑  Cleaning node_modules and build artifacts...$(NC)"
	@rm -rf $(PROJECT_ROOT)/node_modules
	@rm -rf $(THEGAME_DIR)/node_modules $(THEGAME_DIR)/dist
	@rm -rf $(KAMAL_DIR)/node_modules $(KAMAL_DIR)/dist
	@rm -rf $(HAMZA_BE_DIR)/node_modules $(HAMZA_BE_DIR)/dist
	@rm -rf $(HAMZA_FE_DIR)/node_modules $(HAMZA_FE_DIR)/build
	@echo -e "$(GREEN)✓  Cleaned.$(NC)"

# ── Full re-build from scratch ────────────────────────────
.PHONY: re
re: clean install build
	@echo -e "$(GREEN)✅  Full rebuild complete.$(NC)"

# ── Quick full pipeline: setup + install + build + start ──
.PHONY: run
run: all start

# ── Status / health check ────────────────────────────────
.PHONY: status
status:
	@echo -e "$(BLUE)── System ──$(NC)"
	@echo -n "  OS        : "; lsb_release -ds 2>/dev/null || (cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d= -f2) || echo "unknown"
	@$(NVM_LOAD); echo -n "  Node.js   : "; node -v 2>/dev/null || echo "not installed"
	@$(NVM_LOAD); echo -n "  npm       : "; npm -v 2>/dev/null || echo "not installed"
	@echo -n "  nvm       : "; [ -f "$(NVM_SH)" ] && echo "installed ($(NVM_DIR))" || echo "not installed"
	@echo ""
	@echo -e "$(BLUE)── Project ──$(NC)"
	@echo -n "  Root deps       : "; [ -d "$(PROJECT_ROOT)/node_modules" ] && echo "✓" || echo "✗"
	@echo -n "  thegame deps    : "; [ -d "$(THEGAME_DIR)/node_modules" ] && echo "✓" || echo "✗"
	@echo -n "  thegame build   : "; [ -d "$(THEGAME_DIR)/dist" ] && echo "✓" || echo "✗"
	@echo -n "  kamal deps      : "; [ -d "$(KAMAL_DIR)/node_modules" ] && echo "✓" || echo "✗"
	@echo -n "  kamal build     : "; [ -d "$(KAMAL_DIR)/dist" ] && echo "✓" || echo "✗"
	@echo -n "  hamza-be deps   : "; [ -d "$(HAMZA_BE_DIR)/node_modules" ] && echo "✓" || echo "✗"
	@echo -n "  hamza-be build  : "; [ -d "$(HAMZA_BE_DIR)/dist" ] && echo "✓" || echo "✗"
	@echo -n "  hamza-fe deps   : "; [ -d "$(HAMZA_FE_DIR)/node_modules" ] && echo "✓" || echo "✗"
	@echo -n "  hamza-fe build  : "; [ -d "$(HAMZA_FE_DIR)/build" ] && echo "✓" || echo "✗"
	@echo ""
	@echo -e "$(BLUE)── Server ──$(NC)"
	@if pgrep -f "node server.js" >/dev/null 2>&1; then \
		echo -e "  Status: $(GREEN)RUNNING$(NC) (PID $$(pgrep -f 'node server.js'))"; \
	else \
		echo -e "  Status: $(RED)STOPPED$(NC)"; \
	fi

# ── Logs (follow server output) ──────────────────────────
.PHONY: logs
logs:
	@echo -e "$(BLUE)📋 Tailing server logs (Ctrl+C to stop)...$(NC)"
	@$(NVM_LOAD); cd $(PROJECT_ROOT) && node server.js 2>&1 | tee ludox.log

# ── Ensure uploads dir exists ─────────────────────────────
.PHONY: dirs
dirs:
	@mkdir -p $(PROJECT_ROOT)/uploads
	@echo -e "$(GREEN)✓  uploads/ directory ready.$(NC)"

# ── Help ──────────────────────────────────────────────────
.PHONY: help
help:
	@echo ""
	@echo -e "$(BLUE)╔═══════════════════════════════════════════════╗$(NC)"
	@echo -e "$(BLUE)║           LudoX — Makefile Commands           ║$(NC)"
	@echo -e "$(BLUE)╠═══════════════════════════════════════════════╣$(NC)"
	@echo -e "$(BLUE)║$(NC)  make              $(BLUE)│$(NC) setup + install + build    $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make setup        $(BLUE)│$(NC) install Node.js via nvm   $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)                    $(BLUE)│$(NC)   (no sudo needed)         $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make install      $(BLUE)│$(NC) npm install (all parts)    $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make build        $(BLUE)│$(NC) build all frontend apps    $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make start        $(BLUE)│$(NC) start the server           $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make dev          $(BLUE)│$(NC) start with nodemon         $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make run          $(BLUE)│$(NC) setup + install + build +  $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)                    $(BLUE)│$(NC)   start (full pipeline)     $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make stop         $(BLUE)│$(NC) stop the running server    $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make restart      $(BLUE)│$(NC) stop + start               $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make status       $(BLUE)│$(NC) show system & project info $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make clean        $(BLUE)│$(NC) remove node_modules/dist   $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make re           $(BLUE)│$(NC) clean + install + build    $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make logs         $(BLUE)│$(NC) start server & save logs   $(BLUE)║$(NC)"
	@echo -e "$(BLUE)║$(NC)  make help         $(BLUE)│$(NC) show this help             $(BLUE)║$(NC)"
	@echo -e "$(BLUE)╚═══════════════════════════════════════════════╝$(NC)"
	@echo ""
