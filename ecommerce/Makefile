.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

dependency: ## Instalação das dependencias
	@echo "Execute a instalação das dependencias abaixo:"
	@echo "\t$$ sudo apt install ruby-full"
	@echo "\t$$ sudo gem install jekyll bundler"

install: ## Instalação do projeto
	@bundle install


build: ## Compilação do site final
	@rm -fr ./_site && \
		JEKYLL_ENV=production bundle exec jekyll build

deploy: ## Deploy e-commerce in AWS S3 bucket
	@aws s3 sync --delete --profile=bart-recs \
		./_site s3://ecommerce-raw-bart
	@echo "Acesse http://ecommerce-raw-bart.s3-website-us-east-1.amazonaws.com"

runserver: ## Inicia o servidor Jekyll local no endereço 'http://localhost:4000'
	@bundle exec jekyll serve
