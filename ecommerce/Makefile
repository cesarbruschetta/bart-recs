.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

dependency: ## Instalação das dependencias
	@echo "Execute a instalação das dependencias abaixo:"
	@echo "\t$$ sudo apt install ruby-full"
	@echo "\t$$ sudo gem install jekyll bundler"

install: ## Instalação do projeto
	@bundle install

runserver: ## Inicia o servidor Jekyll local no endereço 'http://localhost:4000'
	@bundle exec jekyll serve
