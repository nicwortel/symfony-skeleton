.PHONY: all
all: vendor

vendor: composer.json composer.lock
	composer install

.PHONY: clean
clean:
	rm -rf vendor/
