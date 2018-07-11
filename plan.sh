go_pkg="github.com/sensu/sensu-go"
pkg_name=sensu-agent
pkg_origin=gscho
pkg_version="2.0.0-beta.2-4"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=("Apache-2.0")
pkg_source="https://$go_pkg"
pkg_scaffolding=core/scaffolding-go
pkg_shasum="54b93c8e54fd07dc90e7a0c840e5d93c43055499f612325c6d94d8f66f7e42e9"
pkg_build_deps=(core/which)
pkg_bin_dirs=(bin)
# pkg_description="Some description."
pkg_upstream_url="https://sensu.io"

do_prepare() {
  mkdir -p "$scaffolding_go_pkg_path/bin"
  export PATH=$scaffolding_go_pkg_path/bin:$PATH
}

do_download() {
  # We need to override the scaffold's default download because the agent
  # is in a subdir of the package repository
  go get -d $go_pkg 2>&1 | grep -q "no Go files"
  cd $scaffolding_go_pkg_path && git reset --hard $pkg_version
}

do_build() {
  ln -fs "$(which env)" /usr/bin/env
  cd $scaffolding_go_pkg_path && ./build.sh build_agent
}

do_install() {
  cp -f ${scaffolding_go_pkg_path:?}/bin/sensu-agent $pkg_prefix/bin
}
