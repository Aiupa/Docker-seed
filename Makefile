# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP) bin/console

# Misc
.DEFAULT_GOAL = help
.PHONY        : help build up start down logs install update cc test quality rector-dry rector phpcs phpstan phpunit vendor sf

## —— Help Output ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the Docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

start: build up ## Build and start the containers

down: ## Stop the Docker containers
	@$(DOCKER_COMP) down --remove-orphans

## —— Symfony 🎵 ——————————————————————————————
sf: ## List all Symfony commands or pass the parameter "c=" to run a given command
	@$(eval c ?=)
	@$(SYMFONY) $(c)

cc: ## Clear the cache
	@$(SYMFONY) c:c

## —— Composer 🧙 ——————————————————————————————————
composer: ## Run composer, pass the parameter "c=" to run a given command
	@$(eval c ?=)
	@$(COMPOSER) $(c)

install: ## Install packages with composer
	@$(COMPOSER) install --no-interaction --ignore-platform-reqs --optimize-autoloader

update: ## Update packages with composer
	@$(COMPOSER) self-update
	@$(COMPOSER) update --no-interaction --ignore-platform-reqs --optimize-autoloader
## —— Code Quality 👀 ——————————————————————————————
rector-dry: ## Run Rector without making changes
	@$(PHP_CONT) vendor/bin/rector process src tests --dry-run

rector: ## Apply Rector changes
	@$(PHP_CONT) vendor/bin/rector process src tests

phpcs: ## Run PHP Code Sniffer
	@$(PHP_CONT) vendor/bin/php-cs-fixer fix

phpstan: ## Run PHPStan for code analysis
	@$(PHP_CONT) vendor/bin/phpstan analyse src tests

## —— Unit Testing 🧪 ——————————————————————————
phpunit: ## Run unit tests with coverage report
	@$(PHP_CONT) php vendor/bin/phpunit --coverage-html var/html
	# Uncomment the following line if you want to automatically open the coverage report
	# @$(PHP) -S 127.0.0.1:8080 -t var/html

test: phpunit ## Run the test suite

quality: rector phpcs phpstan ## Run code quality checks