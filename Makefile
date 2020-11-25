include .env

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

##
## ENVIRONMENT
##   Tasks to install appropriate node modules.
##

## setup              :   Install modules from package.json
.PHONY: setup
setup: 
	@echo "Installing modules from package.json for $(PROJECT_NAME)."
	npm install

## 
## STORYBOOK
##   Tasks to build and publish the demo storybook
##

## run_storybook      :   Runs a local webserver to preview the storybook
.PHONY: run_storybook
run_storybook:
	@echo "Running local web server storybook preview for $(PROJECT_NAME)."
	npm run storybook

## build_storybook    :   Builds the storybook's static site. 
.PHONY: build_storybook
build_storybook:
	@echo "Building storybook for $(PROJECT_NAME)."
	npm run build-storybook

## publish_storybook  :   Publishes the storybook to AWS S3.
.PHONY: publish_storybook
publish_storybook:
	@echo "Publish storybook for $(PROJECT_NAME) to $(AWSCLI_S3_PATH)."
#    awscli --profile $(AWSCLI_PROFILE) s3 sync /var/www/html/storybook-static/ s3://$(AWSCLI_S3_PATH)/
