theme := wp-content/themes/tivolisariola
.PHONY: all dev ci ci-install install build watch clean

all: install build

dev: install watch

ci: ci-install build

ci-install:
	composer install --no-dev --no-interaction --optimize-autoloader
	pnpm i

install:
	composer install
	pnpm i

build:
	pnpm run build

watch:
	pnpm run watch

clean:
	rm -rf $(theme)/dist
	rm -rf node_modules
	rm -rf vendor
