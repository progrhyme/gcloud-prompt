.PHONY: test release clean shove

SHELLS  := bash zsh
VERSION := $(shell . gcloud-prompt.sh && echo $$GCLOUD_PROMPT_VERSION)

test: shove
	@set -e; \
	for sh in $(SHELLS); do \
		if which $$sh >/dev/null 2>&1; then \
			vendor/shove/bin/shove -r t -v -s $$sh; \
		else \
			echo "$$sh is not found. skip."; \
		fi; \
	done

release:
	git commit -m $(VERSION)
	git tag -a v$(VERSION) -m $(VERSION)
	git push origin v$(VERSION)
	git push origin master

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
