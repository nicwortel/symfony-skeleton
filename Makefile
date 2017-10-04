.PHONY: all
all: vendor

vendor: composer.json composer.lock
	composer install

.PHONY: test lint
test: lint

lint: vendor
	vendor/bin/parallel-lint bin/console config/ public/ src/
	bin/console lint:yaml config/

.PHONY: clean
clean:
	rm -rf vendor/
