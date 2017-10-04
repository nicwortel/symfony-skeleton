.PHONY: all
all: vendor

vendor: composer.json composer.lock
	composer install

.PHONY: test lint static-analysis coding-standards security-tests
test: lint static-analysis coding-standards security-tests

lint: vendor
	vendor/bin/parallel-lint bin/console config/ public/ src/
	bin/console lint:yaml config/

static-analysis: vendor
	vendor/bin/phpstan analyse --level=7 src/

coding-standards: vendor
	vendor/bin/phpcs -p --colors
	vendor/bin/phpmd src/ text phpmd.xml

security-tests: vendor
	vendor/bin/security-checker security:check

.PHONY: clean
clean:
	rm -rf vendor/
