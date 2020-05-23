.PHONY: test clean shove

SHELLS := bash zsh

test: shove
	@set -e; \
	for sh in $(SHELLS); do \
		if which $$sh >/dev/null 2>&1; then \
			vendor/shove/bin/shove -r t -v -s $$sh; \
		else \
			echo "$$sh is not found. skip."; \
		fi; \
	done

clean:
	rm -rf vendor

shove: vendor
	@echo checkout or update vendor/shove
	@if [ -d vendor/shove ]; then \
		cd vendor/shove && git pull origin master --depth=1; \
	else \
		git clone --depth=1 https://github.com/progrhyme/shove.git vendor/shove; \
	fi

vendor:
	mkdir vendor
