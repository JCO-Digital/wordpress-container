theme := wp-content/themes/ilme
lohko := wp-content/plugins/lohko
.PHONY: all dev ci ci-install install build watch clean

all: install build

dev: install watch

ci: ci-install build

ci-install:
	composer install --no-dev --no-interaction --optimize-autoloader
	cd $(theme); pnpm i
	cd $(lohko); pnpm i

install:
	composer install
	cd $(theme); pnpm i
	cd $(lohko); pnpm i

build:
	cd $(theme); pnpm build
	cd $(lohko); pnpm build

watch:
	pnpm exec concurrently --kill-others -c green,yellow,blue --names ' blocks,󱎵 sass,󱁤 esbuild' 'cd $(lohko); pnpm start' 'cd $(theme); pnpm watch:sass' 'cd $(theme); pnpm watch:esbuild'

clean:
	rm -rf $(theme)/dist
	rm -rf $(theme)/node_modules
	rm -rf $(lohko)/build
	rm -rf $(lohko)/node_modules
	rm -rf node_modules
	rm -rf vendor
