.PHONY: uv-clean uv-delete help

# Some colour codes for formatting.
COLOR_GREEN=\033[0;32m
COLOR_RED=\033[0;31m
COLOR_BLUE=\033[0;34m
COLOR_RESET=\033[0m
COLOR_YELLOW=\033[0;33m
COLOR_CYAN=\033[0;36m


help: ## Show help for each of the Makefile recipes.
	@echo "$(COLOR_BLUE)FastAPI Security Practice$(COLOR_RESET)"
	@echo "Usage: make [target] ...\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(COLOR_CYAN)%-20s$(COLOR_RESET) %s\n", $$1, $$2}'
	@echo "" # just a blank line for nice formatting

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