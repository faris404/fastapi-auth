.PHONY: uv-clean uv-init uv-destroy help

# Some colour codes for formatting.
override COLOR_GREEN=\033[0;32m
override COLOR_RED=\033[0;31m
override COLOR_BLUE=\033[0;34m
override COLOR_RESET=\033[0m
override COLOR_YELLOW=\033[0;33m
override COLOR_CYAN=\033[0;36m

# Default arguments for database initialization using docker.
DB_USER=root
DB_PASS=root
override DB_VOLUME_NAME=fastapi-auth-pg
override DB_CONTAINER_NAME=fastapi-auth-postgres

help: ## Show help for each of the Makefile recipes.
	@echo "$(COLOR_BLUE)FastAPI Security Practice$(COLOR_RESET)"
	@echo "Usage: make [target] ...\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(COLOR_CYAN)%-20s$(COLOR_RESET) %s\n", $$1, $$2}'
	@echo "" # just a blank line for nice formatting

uv-init: ## Initialize UV with specified python version. Example: `make uv-init v=3.12`
	@uv init --python $(v)

uv-clean: ## Remove UV environment and pycache
	@echo "Cleaning environment..."
	@rm -r ./venv 2> /dev/null || true
	@echo "Removing pycache..."
	@rm -r __pycache__ 2> /dev/null || true
	@echo "Completed"

uv-destroy: ## Remove all UV related files includes: venv, lock, toml, and .python-version
	@echo "Cleaning environment..."
	@rm -r ./venv 2> /dev/null || true
	@echo "Removing pycache..."
	@rm -r __pycache__ 2> /dev/null || true
	@echo "Removing UV related files..."
	@rm .python-version pyproject.toml uv.lock 2> /dev/null || true 
	@echo "Completed"

docker-pg-up: ## Spin-up postgresql docker container used only for development
	@echo "Setting up volume ..."
	@docker volume inspect fast-volume >/dev/null 2>&1 || \
	docker volume create $(DB_VOLUME_NAME)
	@if docker container inspect $(DB_CONTAINER_NAME) >/dev/null 2>&1; then \
		echo "Container already exist"; \
		docker start $(DB_CONTAINER_NAME); \
	else \
		echo "Creating new container..."; \
		docker run --name $(DB_CONTAINER_NAME) \
		-e POSTGRES_PASSWORD=$(DB_PASS) \
		-e POSTGRES_USER=$(DB_USER) \
		-p 5433:5432 \
		-v $(DB_VOLUME_NAME):/var/lib/postgresql/data -d postgres; \
	fi
	@echo "Database is UP!"

docker-pg-down: ## Tear-down postgresql docker container
	@docker stop fastapi-auth-postgres
	@echo "Databese is DOWN!"



