.PHONY: test

SHELLS := bash zsh

test:
	@set -e; \
	for sh in $(SHELLS); do \
		if which $$sh >/dev/null 2>&1; then \
			shove -r t -v -s $$sh; \
		else \
			echo "$$sh is not found. skip."; \
		fi; \
	done
