theme := wp-content/themes/ilme

all: install build

install:
	composer install
	cd $(theme); npm ci

build:
	cd $(theme); npm run build

watch:
	cd $(theme); npm run watch

clean:
	rm -rf $(theme)/dist
	rm -rf $(theme)/node_modules
	rm -rf node_modules
	rm -rf vendor