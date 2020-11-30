# only include .env if it exists.
ifneq (,$(wildcard ./.env))
	dropped := $(info Found .env, loading.)
	include .env
	export
else 
	dropped := $(info No .env file found, assuming environment variables loaded elsewhere.)
endif

ifndef BRANCH_NAME
	BRANCH_NAME:= $(shell git rev-parse --abbrev-ref HEAD)
endif


.DEFAULT_GOAL := help

## 
## STORYBOOK-TEST
##   A simple, test storybook installation that can be used to test
##   publishing.
##

## GENERAL
## help               :   Display this helpful instructional text.
help : Makefile 
	@sed -n 's/^##//p' $<
	@echo "\n Currently on branch: $(BRANCH_NAME)"

##
## ENVIRONMENT
##   Tasks to install appropriate node modules.
##

## docker_pull          :   Pull required docker containers.
.PHONY: docker_pull
docker_pull:
	@echo "Pulling docker containers for $(PROJECT_NAME)."
	@docker-compose pull

## docker_prune       :     Remove all containers and their volumes.
##                          Optional: Service name to prune those containers. Ex: 
##                              prune node : Prune `node` container and remove its volumes
.PHONY: docker_prune
docker_prune:
	@echo "Removing containers for $(PROJECT_NAME)."
	@docker-compose down -v $(filter-out $@,$(MAKECMDGOALS))

## init               :   Initialize a new storybook.
.PHONY: init
init:
	@echo "Initializing a new storybook for $(PROJECT_NAME)."
	docker-compose run node npx -p @storybook/cli sb init
	docker-compose run node npm i @storybook/storybook-deployer --save-dev

## setup              :   Install modules from package.json.
.PHONY: setup
setup: 
	@echo "Installing modules from package.json for $(PROJECT_NAME)."
	docker-compose run node npm install

## 
## STORYBOOK
##   Tasks to build and publish the demo storybook
##

## run_storybook      :   Runs a local webserver to preview the storybook
.PHONY: run_storybook
run_storybook:
	@echo "Running local web server storybook preview for $(PROJECT_NAME)."
	docker-compose run node npm run storybook

## build_storybook    :   Builds the storybook's static site. 
.PHONY: build_storybook
build_storybook:
	@echo "Building storybook for $(PROJECT_NAME)."
	docker-compose run node npm run build-storybook

## publish_storybook  :   Publishes the storybook to AWS S3.
.PHONY: publish_storybook
publish_storybook:
	@echo "Publish storybook for $(PROJECT_NAME) at branch $(BRANCH_NAME) to $(AWSCLI_S3_PATH)."
	docker-compose run awscli --profile $(AWSCLI_PROFILE) s3api put-object --bucket $(AWSCLI_S3_BUCKET) --key $(BRANCH_NAME)
	docker-compose run awscli --profile $(AWSCLI_PROFILE) s3 sync $(PROJECT_PATH_TO_STORYBOOK) s3://$(AWSCLI_S3_BUCKET)/$(BRANCH_NAME)
#    awscli --profile $(AWSCLI_PROFILE) s3 sync /var/www/html/storybook-static/ s3://$(AWSCLI_S3_PATH)/
