#!/bin/sh
for I in $*; do
	[[ -e "${I}" ]] && chmod u+w "${I}"
done
exec /usr/bin/strip $*
