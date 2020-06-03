.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

_package:
	@cd ./${folder} && zip -r ../${folder}-lambda.zip .

package-api-authorizer: ## Gerar o pacote para o Lambda do api-authorizer
	@_package folder="lambda-api-authorizer"

package-recommendations: ## Gerar o pacote para o Lambda do bart-recommendations
	@_package folder="bart-recommendations"
