.PHONY: all
all: vendor

vendor: composer.json composer.lock
	composer install

.PHONY: lint
lint: vendor
	vendor/bin/parallel-lint bin/console config/ public/ src/

.PHONY: clean
clean:
	rm -rf vendor/
