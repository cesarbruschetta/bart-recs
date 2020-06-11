.PHONY: .

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

package:
	@cd ./${folder} && zip -r ../${folder}-lambda.zip .

package-api-authorizer: ## Gerar o pacote para o Lambda do api-authorizer
	@make package folder="api-authorizer"

package-recommendations: ## Gerar o pacote para o Lambda do bart-recommendations
	@make package folder="bart-recommendations"
