######################################################
#            Docker Container Management             #
######################################################
# Build the Docker containers using the specified configuration file and run them in detached mode, 
# removing any orphan containers and forcing recreation if necessary.
build:
	docker compose -f ./compose.yml up --build -d --remove-orphans --force-recreate

# Start the Docker containers defined in the specified configuration file in detached mode.
up:
	docker compose -f ./compose.yml up -d

# Stop and remove the Docker containers defined in the specified configuration file.
down:
	docker compose -f ./compose.yml down

# Stop and remove the Docker containers defined in the specified configuration file, including any volumes.
down_v:
	docker compose -f ./compose.yml down -v

# Run a Django admin shell inside the Docker container after setting up the database
django_admin:
	docker compose -f ./compose.yml run --rm api sh -c "run_as $$(id -u) sh"

# Access the PostgreSQL database using the psql command within the Docker environment.
psql: up_db
	docker compose -f ./compose.yml exec db bash -c "psql --username=\$${POSTGRES_USER} --dbname=\$${POSTGRES_DB}"

# Display the logs of the Docker containers defined in the specified configuration file.
logs: up
	docker compose -f ./compose.yml logs

configs:
	docker compose -f ./compose.yml config

.PHONY: build up down down_v django_admin psql logs configs

######################################################
#              Django Admin Operations               #
######################################################
init:
	bash ./yarsin init config

startproject:
	docker compose -f ./compose.yml run --rm --no-deps api sh -c "DJANGO_SETTINGS_MODULE=""; run_as $$(id -u) yarsin startproject config"

.PHONY: init startproject 
