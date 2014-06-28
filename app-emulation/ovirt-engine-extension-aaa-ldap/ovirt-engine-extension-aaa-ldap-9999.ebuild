# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
EANT_BUILD_TARGET="all"
EANT_EXTRA_ARGS=" \
	-Ddir.prefix=/usr \
	-Ddir.sysconf=/etc \
	-Ddir.pkgdata=/usr/share/${P} \
	-Ddir.destdir=${D} \
"

inherit java-pkg-2 java-ant-2
inherit git-2

DESCRIPTION="oVirt LDAP Authentication and Authorization Extension"
HOMEPAGE="http://ovirt.org"
EGIT_REPO_URI="git://gerrit.ovirt.org/${PN}.git"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=virtual/jdk-1.7
	>=dev-java/unboundid-ldapsdk-2.3.7_pre53
	>=app-emulation/ovirt-engine-3.5.0"
DEPEND="${RDEPEND}
	>=dev-java/slf4j-api-1.7"

src_prepare() {
	mkdir lib
	java-pkg_jar-from --into lib slf4j-api
	java-pkg_jar-from --into lib unboundid-ldapsdk
	java-pkg_jar-from --into lib ovirt-engine ovirt-engine-extensions-api.jar
	java-pkg-2_src_prepare
}

src_compile() {
	java-pkg-2_src_compile
}

src_install() {
	eant ${EANT_EXTRA_ARGS} install-no-build
	dodoc README*

	rm "${ED}/usr/share/${P}/modules/org/ovirt/engine-extensions/aaa/ldap/main/unboundid-ldapsdk.jar"
	# avoid repoman warnings
	cd "${ED}"
	java-pkg_jar-from --into "usr/share/${P}/modules/org/ovirt/engine-extensions/aaa/ldap/main" unboundid-ldapsdk
	cd "${S}"
}
