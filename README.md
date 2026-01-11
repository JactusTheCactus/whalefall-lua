Thoughts?
# `data.env`
```env
TITLE=Whalefall
```
# `.sh`
```sh
#!/usr/bin/env bash
set -euo pipefail
flag() {
	for f in "$@"
		do [[ -e ".flags/$f" ]] || return 1
	done
}
source data.env
[[ -d node_modules ]] || npm ci
rm -rf logs
mkdir -p bin logs
make &> logs/make.log
if flag local
	then ./bin/love src
	else npx serve "bin/$TITLE"
fi
if [[ "$(<logs/make.log)" = "make: Nothing to be done for 'ALL'." ]]
	then rm logs/make.log
fi
find -empty -delete
```
# `Makefile`
```makefile
.ONESHELL :
SHELL := /usr/bin/bash
VER := 11.5
.PHONY := ALL CLEAN
include data.env
ALL : bin/love src/conf.lua bin/${TITLE}
bin/love :
	@curl -L \
		"https://github.com/love2d/love/releases/download/${VER}/love-${VER}-x86_64.AppImage" \
		-o bin/love \
		&> /dev/null \
		&& chmod +x bin/love
src/conf.lua : data/conf.lua
	@cat data/conf.lua \
		| perl -pe "s|<title>|${TITLE}|g" \
		> src/conf.lua
bin/${TITLE} : $(wildcard src/*)
	@npx love.js \
		src "bin/${TITLE}" \
		-t "${TITLE}" \
		-m "$$((((2 ** 6)) * ((1024 ** 2))))" \
		-c
```
