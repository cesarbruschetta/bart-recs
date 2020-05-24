# https://johnfraney.ca/posts/2019/05/28/create-publish-python-package-poetry/
.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Instalação do projeto
	@poetry install

build: ## build the package
	@poetry build

publish-test: ##  publish the package to Test PyPI
	#  poetry config repositories.testpypi https://test.pypi.org/legacy/
	@poetry publish -r testpypi

publish: ## publishing package to PyPI
	@poetry publish

run: ## run scrypt, on "k=" recebe os parametros enciados ao script'
	@poetry run simulator ${k}
