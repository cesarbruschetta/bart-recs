.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

package: ## Gerar o pacote para o AWS Glue
	@mkdir -p ./bart_extract/libs \
		&& touch ./bart_extract/libs/__init__.py \
		&& pip install -t ./bart_extract/libs -r ./requirements_libs.txt \
		&& python setup.py bdist_egg -q -b /tmp/bart-extract -d ../ \
		&& rm -rf /tmp/bart-extract ./bart_extract/libs/*
