theme := wp-content/themes/netprofile
lohko := wp-content/plugins/lohko
.PHONY: all dev ci ci-install install build watch watch-theme watch-lohko clean

all: install build

dev: install watch

ci: ci-install build

ci-install:
	composer install --no-dev --no-interaction --optimize-autoloader
	pnpm i
	cd $(theme); ${MAKE} ci-install
	cd $(lohko); ${MAKE} ci-install

install:
	composer install
	pnpm i
	cd $(theme); ${MAKE} install
	cd $(lohko); ${MAKE} install

build:
	cd $(theme); ${MAKE} build
	cd $(lohko); ${MAKE} build

watch:
	${MAKE} -j 2 watch-theme watch-lohko

watch-theme:
	cd $(theme); ${MAKE} watch

watch-lohko:
	cd $(lohko); ${MAKE} watch

clean:
	cd $(theme); ${MAKE} clean
	cd $(lohko); ${MAKE} clean
	rm -rf node_modules
	rm -rf vendor
