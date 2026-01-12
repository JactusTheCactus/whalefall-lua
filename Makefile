.ONESHELL :
.SILENT :
SHELL := /usr/bin/bash
.PHONY := all clean
include data.env
LUA_IN := $(wildcard src/*.lua)
LUA_OUT := $(patsubst src/%.lua,dist/%.lua,$(LUA_IN))
all : $(LOVE) $(LUA_OUT) bin/$(TITLE)
$(LOVE) :
	VER=11.5
	curl -L \
		"https://github.com/love2d/love/releases/download/$$VER/love-$$VER-x86_64.AppImage" \
		-o $(LOVE) \
		&> /dev/null \
		&& chmod +x $(LOVE)
$(LUA_OUT) : $(LUA_IN) data.env
	while read -r i
		do cat $$i \
			| perl -pe "s|<title>|$(TITLE)|g" \
			> "dist/$${i#src/}"
	done < <(find src -name "*.lua")
bin/$(TITLE) : $(LUA_OUT)
	npx love.js \
		dist "bin/$(TITLE)" \
		-t "$(TITLE)" \
		-m "$$(((2 ** 6) * (1024 ** 2)))" \
		-c
clean :
	rm -rf bin dist
