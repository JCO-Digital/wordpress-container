theme := wp-content/themes/jcore2-child

all: install build

install:
	composer install
	npm ci

build:
	npm run build

watch:
	npm run watch

clean:
	rm -rf $(theme)/dist
	rm -rf node_modules
	rm -rf vendor
