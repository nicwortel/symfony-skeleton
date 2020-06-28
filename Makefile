sources = bin/console config public src templates
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

.PHONY: test lint static-analysis unit-tests integration-tests acceptance-tests system-tests coding-standards security-tests composer-validate
test: lint static-analysis unit-tests integration-tests acceptance-tests system-tests coding-standards security-tests composer-validate

lint: vendor
	bin/console lint:yaml config/
	bin/console lint:twig templates/

static-analysis: vendor bin/deptrac.phar
	vendor/bin/phpstan analyse
	bin/deptrac.phar analyze

unit-tests: vendor
	vendor/bin/phpunit --testsuite unit-tests

integration-tests: vendor
	vendor/bin/phpunit --testsuite integration-tests

acceptance-tests: vendor
	vendor/bin/behat -v --suite=acceptance

system-tests: vendor
	vendor/bin/behat -v --suite=system

coding-standards: vendor
	vendor/bin/phpcs -p --colors
	vendor/bin/phpmd src/ text phpmd.xml

security-tests: vendor
	vendor/bin/security-checker security:check

composer-validate:
	composer validate --no-check-publish

bin/deptrac.phar:
	curl -LS https://github.com/sensiolabs-de/deptrac/releases/download/0.8.0/deptrac.phar -o bin/deptrac.phar
	chmod a+x bin/deptrac.phar

.PHONY: clean
clean:
	rm -rf build/ vendor/
