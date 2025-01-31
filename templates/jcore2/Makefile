theme := wp-content/themes/jcore2-child

all: install build

ci: ci-install build

install:
	composer install
	pnpm i

ci-install:
	composer install --no-dev --no-interaction --optimize-autoloader
	pnpm i

build:
	pnpm run build

watch:
	pnpm run watch

clean:
	rm -rf $(theme)/dist
	rm -rf node_modules
	rm -rf vendor
