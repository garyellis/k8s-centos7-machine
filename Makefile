.PHONY: help
	.DEFAULT_GOAL := help

VERSION := . ./VERSION

help: ## show this message
	grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ansible-syntax: ## synax check the ansible playbook
	cd ansible && ansible-playbook --syntax-check playbook.yaml -vvvv -ilocalhost,

ansible-test: ## molecule converge
	cd ansible/tests && molecule converge

ansible-validate: ## molecule validate
	cd ansible/tests && molecule verify

packer-validate: ## validate the packer template
	$(VERSION) && source $(ENV) && packer validate aws-ami.json

lint: ansible-lint packer-validate ## validate the packer template

build: ## run packer build on the template
	$(VERSION) && source $(ENV) && packer build aws-ami.json

e2etest: ## end to end test
	$(VERSION) && source $(ENV) && cd test && go test -v

