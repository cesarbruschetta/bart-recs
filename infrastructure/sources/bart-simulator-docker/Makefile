
.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Criar docker image
	@docker build --tag bart-simulator:${V} ./

tag: ## Criar Tags da image docker
	@docker tag bart-simulator:${V} cesarbruschetta/bart-simulator:${V}
	@docker tag bart-simulator:${V} cesarbruschetta/bart-simulator:latest

push: ## Enviar Tags para o Docker hub
	@docker push cesarbruschetta/bart-simulator:${V}
	@docker push cesarbruschetta/bart-simulator:latest
