# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_PV="${PV/./_}"
MY_PV="${MY_PV/./_}"

DESCRIPTION="The XMLmind XML Editor (Personal Edition)"
HOMEPAGE="http://www.xmlmind.com/xmleditor/index.html"
SRC_URI="http://www.xmlmind.net/xmleditor/_download/${PN}-perso-${MY_PV}.tar.gz"
IUSE=""
# Download translations of XXE
IUSE="${IUSE} linguas_fr linguas_cs linguas_fi linguas_de linguas_it linguas_pl linguas_es"
SRC_URI="${SRC_URI}
	linguas_fr? ( http://www.xmlmind.net/xmleditor/_download/fr_translation-${MY_PV}.zip )
	linguas_cs? ( http://www.xmlmind.com/xmleditor/_usercontrib/cs_translation-081129191441951/cs_translation.zip )
	linguas_fi? ( http://www.xmlmind.com/xmleditor/_usercontrib/fi_translation-080428135602301/fi_translation.zip )
	linguas_de? ( http://www.xmlmind.com/xmleditor/_usercontrib/de_translation-081203214945446/de_translation.zip )
	linguas_it? ( http://www.xmlmind.com/xmleditor/_usercontrib/it_translation-080501061331567/it_translation.zip )
	linguas_pl? ( http://www.xmlmind.com/xmleditor/_usercontrib/pl_translation-080929154739451/pl_translation.zip )
	linguas_es? ( http://www.xmlmind.com/xmleditor/_usercontrib/es_translation-081201115919295/es_translation.zip )
"
# Download spell checker dictionaries for XXE
IUSE="${IUSE} spell_de spell_es spell_fr spell_cs spell_hi spell_pl spell_ru spell_sk spell_sv"
SRC_URI="${SRC_URI}
	spell_de? ( http://www.xmlmind.net/xmleditor/_download/de_dictionary-${MY_PV}.zip )
	spell_es? ( http://www.xmlmind.net/xmleditor/_download/es_dictionary-${MY_PV}.zip )
	spell_fr? ( http://www.xmlmind.net/xmleditor/_download/fr_dictionary-${MY_PV}.zip )
	spell_cs? ( http://www.xmlmind.net/spellchecker/_download/cs_dictionary.zip )
	spell_hi? ( http://www.xmlmind.net/spellchecker/_download/hi_dictionary.zip )
	spell_pl? ( http://www.xmlmind.net/spellchecker/_download/pl_dictionary.zip )
	spell_ru? ( http://www.xmlmind.net/spellchecker/_download/ru_dictionary.zip )
	spell_sk? ( http://www.xmlmind.net/spellchecker/_download/sk_dictionary.zip )
	spell_sv? ( http://www.xmlmind.net/spellchecker/_download/sv_dictionary.zip )
"
# Download configurations for XXE
IUSE="${IUSE} cfg_dita cfg_mathml cfg_samples cfg_sdb cfg_slides cfg_wxs cfg_xxe"
SRC_URI="$SRC_URI
	cfg_dita? ( http://www.xmlmind.net/xmleditor/_download/dita_dtd_config-${MY_PV}.zip )
	cfg_mathml? ( http://www.xmlmind.net/xmleditor/_download/mathml_config-${MY_PV}.zip )
	cfg_samples? ( http://www.xmlmind.net/xmleditor/_download/sample_customize_xxe-${MY_PV}.zip )
	cfg_sdb? ( http://www.xmlmind.net/xmleditor/_download/sdocbook_config-${MY_PV}.zip )
	cfg_slides? ( http://www.xmlmind.net/xmleditor/_download/slides_config-${MY_PV}.zip )
	cfg_wxs? ( http://www.xmlmind.net/xmleditor/_download/wxs_config-${MY_PV}.zip )
	cfg_xxe? ( http://www.xmlmind.net/xmleditor/_download/xxe_config_pack-${MY_PV}.zip )
"
# Download XSL-FO processor plug-ins
IUSE="${IUSE} fop_fop1 fop_xep fop_xfc"
SRC_URI="$SRC_URI
	fop_fop1? ( http://www.xmlmind.net/xmleditor/_download/fop1_foprocessor-${MY_PV}.zip )
	fop_xep? ( http://www.xmlmind.net/xmleditor/_download/xep_foprocessor-${MY_PV}.zip )
	fop_xfc? ( http://www.xmlmind.net/xmleditor/_download/xfc_foprocessor-${MY_PV}.zip )
"
# Download image toolkit plug-ins
IUSE="$IUSE img_batik img_jeuclid img_jimi"
SRC_URI="$SRC_URI
	img_batik? ( http://www.xmlmind.net/xmleditor/_download/batik_imagetoolkit-${MY_PV}.zip )
	img_jeuclid? ( http://www.xmlmind.net/xmleditor/_download/jeuclid_imagetoolkit-${MY_PV}.zip )
	img_jimi? ( http://www.xmlmind.net/xmleditor/_download/jimi_imagetoolkit-${MY_PV}.zip )
"
# Download virtual drive plug-ins
IUSE="$IUSE vd_dav vd_ftp"
SRC_URI="$SRC_URI
	vd_dav? ( http://www.xmlmind.net/xmleditor/_download/dav_vdrive-${MY_PV}.zip )
	vd_ftp? ( http://www.xmlmind.net/xmleditor/_download/ftp_vdrive-${MY_PV}.zip )
"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 amd64"

RESTRICT="nostrip nomirror"
RDEPEND=">=virtual/jre-1.5"
DEPEND=""

S="${WORKDIR}/${PN}-perso-${MY_PV}"
INSTALLDIR="/opt/${PN}"

src_unpack() {
	unpack ${A}

	local addon="${S}/addon/"
	local i

	mv $addon/spell $addon/en_dictionary
	use cfg_samples && mv ${WORKDIR}/sample_customize_xxe $addon
	for i in \
		${WORKDIR}/*_translation \
		${WORKDIR}/*_dictionary \
		${WORKDIR}/*_config \
		${WORKDIR}/*_foprocessor \
		${WORKDIR}/*_imagetoolkit \
		${WORKDIR}/*_vdrive; \
	do
		mv $i $addon
	done
	einfo ""
	einfo "Move language files, you must have linguas_* in USE where"
	einfo "'*' is the language files you wish. English is always available"
	einfo ""
}

src_install() {
	dodir "${INSTALLDIR}"
	cp -pPR "${S}"/* "${D}/${INSTALLDIR}"

	dodir /etc/env.d
	echo -e "PATH=${INSTALLDIR}/bin\nROOTPATH=${INSTALLDIR}" > "${D}"/etc/env.d/10xxe

	insinto /usr/share/applications
	doins "${FILESDIR}"/xxe.desktop
}

pkg_postinst() {
	einfo
	einfo "XXE has been installed in /opt/xxe, to include this"
	einfo "in your path, run the following:"
	eerror "    /usr/sbin/env-update && source /etc/profile"
	einfo
	ewarn "If you need special/accented characters, you'll need to export LANG"
	ewarn "to your locale.  Example: export LANG=es_ES.ISO8859-1"
	ewarn "See http://www.xmlmind.com/xmleditor/user_faq.html#linuxlocale"
	if use fop_xep; then
		einfo
		einfo "To use XEP fo-processor you must finish install. Run following:"
		eerror "    ${INSTALLDIR}/addon/xep_foprocessor/xep_finish_install"
	fi
	einfo
}
