.PHONY: help check clean list plan apply destroy

# AWS exercises (03+) take TARGET=local|sandbox from the shared kit; 01-02 need no cloud.
SANDBOX_KIT ?= ../202610_05_aws_sandbox_kit
include $(SANDBOX_KIT)/sandbox.mk

EX ?=
DIR = exercises/$(EX)

help:
	@echo "make list                       list exercises"
	@echo "make check EX=01_first_config   init + fmt -check + validate + terraform test"
	@echo "make clean EX=01_first_config   remove .terraform, state and generated output"
	@echo "make plan|apply|destroy EX=03_meta_arguments [TARGET=local|sandbox]   hands-on AWS runs"

list:
	@ls exercises

check:
	@test -n "$(EX)" -a -d "$(DIR)" || { echo "usage: make check EX=<exercise>  (see make list)"; exit 1; }
	cd $(DIR) && terraform init -input=false -backend=false >/dev/null
	cd $(DIR) && terraform fmt -check -recursive -diff
	cd $(DIR) && terraform validate
	cd $(DIR) && terraform test

clean:
	@test -n "$(EX)" -a -d "$(DIR)" || { echo "usage: make clean EX=<exercise>"; exit 1; }
	rm -rf $(DIR)/.terraform $(DIR)/terraform.tfstate* $(DIR)/out

# Hands-on runs of AWS exercises (03+) against TARGET=local (LocalStack) or TARGET=sandbox.
# State is kept per target + account under .state/ by the sandbox kit.
plan apply destroy: whoami
	@test -n "$(EX)" -a -d "$(DIR)" || { echo "usage: make $@ EX=<exercise> [TARGET=local|sandbox]"; exit 1; }
	$(call tf_init,$(DIR)) >/dev/null
	$(call tf,$(DIR),$@ -input=false $(if $(filter apply destroy,$@),$(TF_APPROVE)))
