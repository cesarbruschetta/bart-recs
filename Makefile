# https://johnfraney.ca/posts/2019/05/28/create-publish-python-package-poetry/
.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

use36: 
	@cd ${P} && \
		poetry env use 3.6

install: ## Install package dependencies
	@cd ${P} && \
		poetry install

publish: ## build the package and publishing package to PyPI
	@cd ${P} && \
		poetry build \
		&& poetry publish

publish-test: ##  publish the package to Test PyPI
	#  poetry config repositories.testpypi https://test.pypi.org/legacy/
	@cd ${P} && \
		poetry publish -r testpypi

run-simulator: ## run scrypt, on "k=" recebe os parametros enciados ao script'
	@cd ${P} && \
		poetry run simulator ${k}