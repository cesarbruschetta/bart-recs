.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## instala dependencias do pacote
	@poetry install

package: ## Gerar o pacote para o AWS Glue
	@poetry build -f wheel \
		&& mv ./dist/*.whl ../
