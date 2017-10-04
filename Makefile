sources = bin/console config public src
version = $(shell git describe --tags --dirty --always)
build_name = application-$(version)
build_dir = build/$(build_name)

.PHONY: all
all: vendor

vendor: composer.json composer.lock
	composer install

build/$(build_name).tar.gz: $(sources) vendor
	-rm -rf $(build_dir)
	mkdir -p $(build_dir)
	cp --recursive --parents $(sources) vendor composer.* $(build_dir)
	composer install --working-dir=$(build_dir) --no-dev --optimize-autoloader --no-plugins --no-scripts
	tar --create --gzip --directory=$(build_dir) --file=$@ $(sources) vendor
	-rm -rf $(build_dir)

.PHONY: dist
dist: build/$(build_name).tar.gz

.PHONY: test lint static-analysis unit-tests integration-tests coding-standards security-tests
test: lint static-analysis unit-tests integration-tests coding-standards security-tests

lint: vendor
	vendor/bin/parallel-lint $(sources)
	bin/console lint:yaml config/
	bin/console lint:twig templates/

static-analysis: vendor
	vendor/bin/phpstan analyse --level=7 src/

unit-tests: vendor
	vendor/bin/phpunit --testsuite unit-tests

integration-tests: vendor
	vendor/bin/phpunit --testsuite integration-tests

coding-standards: vendor
	vendor/bin/phpcs -p --colors
	vendor/bin/phpmd src/ text phpmd.xml

security-tests: vendor
	vendor/bin/security-checker security:check

.PHONY: clean
clean:
	rm -rf build/ vendor/
