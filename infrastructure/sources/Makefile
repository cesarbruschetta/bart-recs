.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

package-bart-simulator:
	@pip install bart-simulator -t ./tmp && \
		cd ./tmp && zip -r ../bart-simulator-lambda.zip .
	@cd ./bart-simulator-lambda && zip -r ../bart-simulator-lambda.zip .
	@rm -r ./tmp 

