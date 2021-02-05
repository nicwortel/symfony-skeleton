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

.PHONY: check lint static-analysis unit-tests integration-tests acceptance-tests system-tests coding-standards security-tests composer-validate
check: lint static-analysis unit-tests integration-tests acceptance-tests system-tests coding-standards security-tests composer-validate

lint: vendor
	bin/console lint:yaml config/
	bin/console lint:twig templates/

static-analysis: vendor
	vendor/bin/phpstan analyse
	vendor/bin/deptrac analyze

unit-tests: vendor
	vendor/bin/phpunit --testsuite unit

integration-tests: vendor
	vendor/bin/phpunit --testsuite integration

acceptance-tests: vendor
	vendor/bin/behat -v --suite=acceptance

system-tests: vendor
	vendor/bin/behat -v --suite=system

coding-standards: vendor
	vendor/bin/phpcs -p --colors
	vendor/bin/phpmd src/ text phpmd.xml

security-tests: bin/local-php-security-checker
	bin/local-php-security-checker

composer-validate:
	composer validate --no-check-publish

bin/local-php-security-checker:
	mkdir -p $(@D)
	curl -LS https://github.com/fabpot/local-php-security-checker/releases/download/v1.0.0/local-php-security-checker_1.0.0_linux_amd64 -o $@
	chmod +x $@

.PHONY: clean
clean:
	rm -rf build/ vendor/ bin/local-php-security-checker
