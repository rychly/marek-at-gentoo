#!/bin/sh

if [ $# -lt 2 -o ! -d "${1}" ]; then
	echo "Usage:	${0} <trd-directory> <stardict|goldendict>" >&2
	echo "Translate *.trd file in the first directory into a working directory (\$PWD) as StarDict/GoldenDict dictionaries." >&2
	exit -1
fi

## Output style (linebreaks, fonts etc.)
OUT_STYLE_HTML=2	# StarDict
OUT_STYLE_XHTML=3	# GoldenDict
if [ "${2}" == "goldendict" ]; then
	echo "Building dictionaries for GoldenDict (XHTML)"
	OUT_STYLE=${OUT_STYLE_XHTML}
else
	echo "Building dictionaries for StarDict (HTML)"
	OUT_STYLE=${OUT_STYLE_HTML}
fi

for I in "${1}"/*.trd; do
	echo "${I} ..."
	lingea-trd-decoder --out-style "${OUT_STYLE}" "${I}" | bzip2 -9 >$(basename "${I}" .trd).tab.bz2 || break
	cut -d '' -f 1 "${I}" | head -2 >$(basename "${I}" .trd).txt
	echo "... OK"
done
