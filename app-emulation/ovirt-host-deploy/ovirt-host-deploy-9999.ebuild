# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="*"
inherit python java-pkg-opt-2
inherit git-2 autotools

DESCRIPTION="OVirt host deploy"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://git.engineering.redhat.com/users/abarlev/${PN}.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-devel/gettext
	app-emulation/otopi
	java? (
		>=virtual/jre-1.4
		dev-java/commons-logging
	)
"
DEPEND="${RDEPEND}
	dev-python/pep8
	dev-python/pyflakes
	java? (
		>=virtual/jdk-1.4
		dev-java/junit:4
	)
"

pkg_setup() {
	python_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	eautoreconf
	python_copy_sources
}

src_configure() {
	conf() {
		econf \
			$(use_enable java java-sdk)
	}
	python_execute_function -s conf
}

src_compile() {
	python_execute_function -d -s
}

src_install() {
	inst() {
		emake install DESTDIR="${D}"

		use java && java-pkg_dojar target/ovirt-host-deploy*.jar
		dodoc README*
	}
	python_execute_function -s inst
	python_clean_installation_image
}

pkg_postinst() {
	local share=share # hack python eclass
	python_mod_optimize $(echo "${PN}" | sed 's/-/_/g')
	python_mod_optimize --allow-evaluated-non-sitedir-paths \
		/usr/\${share}/${PN}/plugins
}

pkg_postrm() {
	local share=share # hack python eclass
	python_mod_cleanup $(echo "${PN}" | sed 's/-/_/g')
	python_mod_cleanup --allow-evaluated-non-sitedir-paths \
		/usr/\${share}/${PN}/plugins
}
