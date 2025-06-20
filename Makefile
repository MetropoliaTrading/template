# ------------------------------------------------------------------------------
# Configuration variables (can be overridden via environment)
# ------------------------------------------------------------------------------
DB_USER     ?= devuser         # Postgres username
DB_PASS     ?= devpass         # Postgres password
DB_NAME     ?= devdb           # Postgres database name
DB_HOST     ?= localhost       # Host where Postgres is reachable (docker service is “db”)
DB_PORT     ?= 5432            # Postgres port

# ------------------------------------------------------------------------------
# Phony targets
# ------------------------------------------------------------------------------
.PHONY: help setup install uninstall freeze docker-up db-up db-down db-shell status

# Collect any extra words after “make install …” or “make uninstall …”
PKGS := $(filter-out help setup install uninstall freeze docker-up db-up db-down db-shell status,$(MAKECMDGOALS))

# ------------------------------------------------------------------------------
# help: show this help text
# ------------------------------------------------------------------------------
help:
	@echo "Usage:"
	@echo "  # Environment ----------------------------------------------------------"
	@echo "  make setup                        Run initial ./bin/setup.sh"
	@echo "  # Python packages ------------------------------------------------------"
	@echo "  make install                      Install all from requirements.txt"
	@echo "  make install pkg1 pkg2 …          Install new package(s) and add them"
	@echo "  make uninstall                    Uninstall everything in requirements.txt"
	@echo "  make uninstall pkg1 pkg2 …        Uninstall package(s) and update file"
	@echo "  make freeze                       Re-generate requirements.txt"
	@echo "  # Docker ---------------------------------------------------------------"
	@echo "  make docker-up                    docker compose up --build -d (app+db)"
	@echo "  make db-up                        Start ONLY the db service"
	@echo "  make db-down                      Stop the db service"
	@echo "  make db-shell                     Enter psql in the running db container"
	@echo "  make status                       Show status of all compose services"

# ------------------------------------------------------------------------------
# setup: set up the environment for the first time
# ------------------------------------------------------------------------------
setup:
	chmod +x ./bin/setup.sh
	./bin/setup.sh

# ------------------------------------------------------------------------------
# install: installs packages; extra args are treated as new packages
# ------------------------------------------------------------------------------
install:
	@pip install --upgrade pip
ifneq ($(PKGS),)
	@echo "Installing new package(s): $(PKGS)"
	@pip install $(PKGS)
else
	@echo "Installing from requirements.txt"
	@pip install -r requirements.txt
endif
	@$(MAKE) freeze

# ------------------------------------------------------------------------------
# uninstall: removes packages; extra args are treated as package names
# ------------------------------------------------------------------------------
uninstall:
ifneq ($(PKGS),)
	@echo "Uninstalling package(s): $(PKGS)"
	@pip uninstall -y $(PKGS)
else
	@echo "Uninstalling everything in requirements.txt"
	@pip uninstall -y -r requirements.txt || true
endif
	@$(MAKE) freeze

# ------------------------------------------------------------------------------
# freeze: capture current env into requirements.txt
# ------------------------------------------------------------------------------
freeze:
	@echo "Freezing installed packages into requirements.txt"
	@pip freeze > requirements.txt

# ------------------------------------------------------------------------------
# docker-up: build and start the full Docker Compose stack (app + db)
# ------------------------------------------------------------------------------
docker-up:
	docker compose up --build -d

# ------------------------------------------------------------------------------
# db-up: start ONLY the Postgres service
# ------------------------------------------------------------------------------
db-up:
	docker compose up -d db

# ------------------------------------------------------------------------------
# db-down: stop ONLY the Postgres service
# ------------------------------------------------------------------------------
db-down:
	docker compose stop db

# ------------------------------------------------------------------------------
# db-shell: open psql inside the running Postgres container
# ------------------------------------------------------------------------------
db-shell:
	docker exec -it postgres_dev psql -U $(DB_USER) -d $(DB_NAME)

# ------------------------------------------------------------------------------
# status: show all compose services and their current state
# ------------------------------------------------------------------------------
status:
	docker compose ps

# ------------------------------------------------------------------------------
# Prevent “no rule to make target »pkg«” errors when pkg names are used
# ------------------------------------------------------------------------------
%:
	@:
