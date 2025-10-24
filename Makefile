# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: hoannguy <hoannguy@student.42lausanne.c    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/10 14:55:00 by hoannguy          #+#    #+#              #
#    Updated: 2025/07/18 11:14:14 by hoannguy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER_COMPOSE = ./srcs/docker-compose.yml
ENV_FILE = ./srcs/.env
WORDPRESS_DATABASE = $(HOME)/data/wordpress
MARIADB_DATABASE = $(HOME)/data/mariadb

NAME = Inception

all: dir build up

dir:
	@mkdir -p $(WORDPRESS_DATABASE)
	@mkdir -p $(MARIADB_DATABASE)
	@echo "Folders for database created"

build:
	@docker compose -f $(DOCKER_COMPOSE) --env-file $(ENV_FILE) build
	@echo "Images built"

up:
	@docker compose -f $(DOCKER_COMPOSE) --env-file $(ENV_FILE) up -d
	@echo "Containers started"

down:
	@docker compose -f $(DOCKER_COMPOSE) --env-file $(ENV_FILE) down
	@echo "Containers stopped"

clean: down
	@docker system prune -a -f
	@sudo rm -rf $(WORDPRESS_DATABASE)/*
	@sudo rm -rf $(MARIADB_DATABASE)/*
	@echo "All containers, networks and images removed"

fclean: down
	@docker system prune -a -f --volumes
	@rm -rf $(WORDPRESS_DATABASE)/* $(WORDPRESS_DATABASE)/.* 2>/dev/null || true
	@rm -rf $(MARIADB_DATABASE)/* $(MARIADB_DATABASE)/.* 2>/dev/null || true
	@echo "All containers, images, networks and volumes removed"
	@echo "Database folders cleared"

re: fclean dir build up

show:
	@docker compose -f $(DOCKER_COMPOSE) ps

.PHONY: all dir build up down clean fclean re show
