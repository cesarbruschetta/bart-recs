.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

use36:
	@poetry env use 3.6

install: use36 ## instala dependencias do pacote
	@poetry install

publish: use36 ## build the package and publishing package to PyPI
	@poetry build \
		&& poetry publish

