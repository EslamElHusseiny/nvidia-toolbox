help:
	@cat Makefile

DATA?="${HOME}/Data"
GPU?=0
DOCKER_FILE=Dockerfile
DOCKER=GPU=$(GPU) ./nvidia-docker

build:
	docker build -t nvidia-toolbox -f $(DOCKER_FILE) .

dev: build
	$(DOCKER) run -it -v `pwd`:/src -v $(DATA):/data nvidia-toolbox bash

notebook: build
	$(DOCKER) run -it -v `pwd`:/src -v $(DATA):/data -P nvidia-toolbox

test: build
	$(DOCKER) run -it -v `pwd`:/src -v $(DATA):/data nvidia-toolbox nosetests -v sensorcnn

