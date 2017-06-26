name 'glib'
default_version '2.52.3'
skip_transitive_dependency_licensing true
license 'GPL-3.0'
license_file 'COPYING'


dependency 'util-linux'
dependency 'gettext'
# dependency 'pcre'

source url: "https://ftp.gnome.org/pub/gnome/sources/glib/2.52/glib-#{version}.tar.xz"

version('2.52.3') { source sha256: '25ee7635a7c0fcd4ec91cbc3ae07c7f8f5ce621d8183511f414ded09e7e4e128' }

relative_path "glib-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_args = [
      "--prefix=#{install_dir}/embedded",
      '--disable-gtk-doc',
      '--enable-static',
      '--with-pcre=system',
  ]
  configure_cmd = './configure'
  configure_command = configure_args.unshift(configure_cmd).join(' ')

  command configure_command, env: env, in_msys_bash: true

  make env: env
  make 'install', env: env
end