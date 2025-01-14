theme := wp-content/themes/ilme

all: install build

install:
	composer install
	cd $(theme); pnpm i

build:
	cd $(theme); pnpm build

watch:
	cd $(theme); pnpm watch

clean:
	rm -rf $(theme)/dist
	rm -rf $(theme)/node_modules
	rm -rf node_modules
	rm -rf vendor
