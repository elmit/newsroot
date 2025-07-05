# Newsroot Docker Development Commands
.PHONY: help build up down setup clean logs shell db-shell test deps compile format check restart

# Default target
help: ## Show this help message
	@echo "Newsroot Development Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build Docker images
	docker-compose build

up: ## Start all services in development mode
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

dev: ## Start services and follow logs
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

down: ## Stop all services
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

setup: ## Run initial setup (database creation, migration, etc.)
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml --profile setup run --rm setup

clean: ## Stop services and remove volumes (WARNING: deletes data)
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down -v
	docker system prune -f

logs: ## Show logs from all services
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f

logs-app: ## Show logs from app service only
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f app

logs-db: ## Show logs from database service only
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs -f postgres

shell: ## Open shell in app container
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app sh

db-shell: ## Open PostgreSQL shell
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec postgres psql -U postgres -d newsroot_dev

db-reset: ## Reset database (drop, create, migrate)
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app mix cmd --app newsroot_core mix ecto.reset

migrate: ## Run database migrations
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app mix cmd --app newsroot_core mix ecto.migrate

rollback: ## Rollback last migration
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app mix cmd --app newsroot_core mix ecto.rollback

test: ## Run tests
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app mix test

deps: ## Get dependencies
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app mix deps.get

compile: ## Compile the project
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app mix compile

format: ## Format code
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app mix format

check: ## Run code analysis (credo, dialyzer if available)
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec app mix compile --warnings-as-errors

restart: ## Restart app service
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml restart app

restart-db: ## Restart database service
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml restart postgres

status: ## Show status of all services
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml ps

# Quick start workflow
quick-start: build setup up ## Build, setup, and start everything

# Full reset and restart
reset: down clean build setup up ## Complete reset: stop, clean, build, setup, start
