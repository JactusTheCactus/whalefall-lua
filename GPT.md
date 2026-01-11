Thoughts?
# `data.env`
```env
TITLE="Whalefall"
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
TITLE=`echo "$TITLE" | perl -pe 's|/|_|g'`
[[ -d node_modules ]] || npm ci
make clean
rm -rf logs
mkdir -p bin dist logs
make &> logs/make.log
if flag local
	then ./bin/love dist
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
.SILENT :
SHELL := /usr/bin/bash
.PHONY := all clean
include data.env
VER := 11.5
TITLE := $(shell echo '$(TITLE)' | perl -pe 's/^"|"$$//g')
LUA_IN := $(wildcard src/*.lua)
LUA_OUT := $(patsubst src/%.lua,dist/%.lua,$(LUA_IN))
all : bin/love $(LUA_OUT) bin/$(TITLE)
bin/love :
	curl -L \
		"https://github.com/love2d/love/releases/download/$(VER)/love-$(VER)-x86_64.AppImage" \
		-o bin/love \
		&> /dev/null \
		&& chmod +x bin/love
$(LUA_OUT) : $(LUA_IN) data.env
	while read -r i
		do cat $$i \
			| perl -pe "s|<title>|$(shell echo '$(TITLE)' | perl -pe 's/\|/_/g')|g" \
			> "dist/$${i#src/}"
	done < <(find src -name "*.lua")
bin/$(TITLE) : $(LUA_OUT)
	npx love.js \
		dist "bin/$(shell echo '$(TITLE)' | perl -pe 's|[/]|_|g')" \
		-t "$(TITLE)" \
		-m "$$(((2 ** 6) * (1024 ** 2)))" \
		-c
clean :
	rm -rf bin dist
```
