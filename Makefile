PATH := ./node_modules/.bin:${PATH}
LSC_VER := $(shell lsc -v)

.PHONY : init clean build test dist check-lsc publish

init:
	npm install

clean:
	rm -rf lib/* node_modules

check-lsc:
	@ if [ "$(LSC_VER)" != "LiveScript version 1.4.0" ] ; then \
		echo "LiveScript 1.4.0 required." ; \
		exit 1 ; \
	fi

build: check-lsc
	lsc -o lib/ -c src/

test:
	./node_modules/.bin/mocha --harmony --compilers ls:livescript

dist: clean init build test

publish: dist
	npm publish
