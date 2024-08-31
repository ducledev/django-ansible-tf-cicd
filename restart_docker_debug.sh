#!/bin/bash

# Stop and remove existing containers
docker-compose -f docker-compose.debug.yml down

# Build and start the containers in detached mode
docker-compose -f docker-compose.debug.yml up --build -d

# Display the logs
docker-compose -f docker-compose.debug.yml logs -f/