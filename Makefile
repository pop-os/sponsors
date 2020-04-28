#!/usr/bin/make -f

################
# Image Settings
################
SHELL                   := /usr/bin/env bash
ECR_REPO_BASE           ?= 
REPO_NAMESPACE          ?= 
IMAGE_NAME              ?= sponsors
BASE_IMAGE              ?= alpine:3.10

###############
# ECR Push Keys
###############
AWS_ACCESS_KEY_ID       ?= ""
AWS_SECRET_ACCESS_KEY   ?= ""
AWS_SESSION_TOKEN       ?= ""

##############################
# Image Tag & Version Settings
##############################
BANNER                  := --------------------------------------------------------------------------------
VERSION                 := $(shell git rev-parse --abbrev-ref HEAD | sed 's|release/||g' 2>/dev/null | sed 's|/|-|g' 2>/dev/null)
VCS_REF                 := $(shell git rev-parse --short HEAD 2>/dev/null || echo "0000000")
BUILD_DATE              := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

######################################
# Default target is to build container
######################################
.PHONY: default
default: build

#####################
# Build the api image
#####################
.PHONY: build
build:
	docker build \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VERSION=$(VERSION) \
		--tag $(IMAGE_NAME):latest \
		--tag $(IMAGE_NAME):$(VCS_REF) \
		--tag $(IMAGE_NAME):$(VERSION) \
		--file Dockerfile .

###################
# List built images
###################
.PHONY: list
.SILENT: list
list:
	echo $(BANNER)
	echo "Listing Docker Images: $(IMAGE_NAME)"
	echo $(BANNER)
	docker images $(IMAGE_NAME) --filter "dangling=false"
	echo -en "\n"

###############
# Run any tests
###############
.PHONY: test
test: build
	docker run -e CI=true $(IMAGE_NAME):build env | grep VERSION | grep $(VERSION)

####################
# Push images to ECR
####################
.PHONY: push
push: build
	$$(aws ecr get-login --registry-ids $$(echo $(ECR_REPO_BASE) | sed -En 's|([[:digit:]]+).*|\1|p') --no-include-email --region us-west-2)
	docker tag $(IMAGE_NAME):latest $(ECR_REPO_BASE)/$(IMAGE_NAME):latest
	docker tag $(IMAGE_NAME):$(VCS_REF) $(ECR_REPO_BASE)/$(IMAGE_NAME):$(VCS_REF)
	docker tag $(IMAGE_NAME):$(VERSION) $(ECR_REPO_BASE)/$(IMAGE_NAME):$(VERSION)
	docker push $(ECR_REPO_BASE)/$(IMAGE_NAME):latest
	docker push $(ECR_REPO_BASE)/$(IMAGE_NAME):$(VCS_REF)
	docker push $(ECR_REPO_BASE)/$(IMAGE_NAME):$(VERSION)

########################
# Remove existing images
########################
.PHONY: clean
.SILENT: clean
clean:
	echo "Cleaning Docker Images: $(IMAGE_NAME)"
	docker rmi $$(docker images $(IMAGE_NAME) --format="{{.Repository}}:{{.Tag}}") --force > /dev/null 2>&1 || echo "Cleaned $(IMAGE_NAME)"
	docker rmi $$(docker images $(REPO_NAMESPACE)/$(IMAGE_NAME) --format="{{.Repository}}:{{.Tag}}") --force > /dev/null 2>&1 || echo "Cleaned $(ECR_REPO_BASE)/$(IMAGE_NAME)"

