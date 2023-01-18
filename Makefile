.DEFAULT_GOAL := help
export PYTHONDEVMODE = 1

ifeq (test,$(firstword $(MAKECMDGOALS)))
  testargs := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
  $(eval $(testargs):;@true)
endif

.PHONY: test
test:  ## Run tests
	cp settings/test_local.py django/tests
	django/tests/runtests.py --settings test_local $(testargs)
	rm -rf django/tests/test_local.py

help:
	@echo "[Help] Makefile list commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
