## The fprint project aims to plug a gap in the Linux desktop: support for consumer fingerprint reader devices.
# http://reactivated.net/fprint/wiki/Main_Page

dir2portage() {
	TDIR=$1
	PDIR=$2
	CATG=$3
	NAME=$4
	mkdir -p "${PDIR}/${CATG}/${NAME}" \
	&& mv "${TDIR}"/${NAME}-* "${PDIR}/${CATG}/${NAME}/" \
	&& for E in "${PDIR}/${CATG}/${NAME}"/*.ebuild; do
		ebuild "${E}" digest;
	done
	return $?
}

TDIR=/tmp/fprint.$$

[ -d "${DIR}" ] \
&& wget -nv -np -nd -r -A ebuild -P "${TDIR}" http://www.reactivated.net/fprint/ebuilds/ \
&& dir2portage "${TDIR}" "${DIR}" media-libs libfprint \
&& dir2portage "${TDIR}" "${DIR}" sys-auth pam_fprint \
&& dir2portage "${TDIR}" "${DIR}" app-misc fprint_demo \
&& rm -r "${TDIR}" \
&& echo "ok" >&2 || echo 'error' >&2