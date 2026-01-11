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
	#else npx serve "bin/$TITLE"
fi
if [[ "$(<logs/make.log)" = "make: Nothing to be done for 'ALL'." ]]
	then rm logs/make.log
fi
find -empty -delete
