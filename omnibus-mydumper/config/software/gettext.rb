name 'gettext'
default_version '0.19.8'
skip_transitive_dependency_licensing true
license 'GPL-3.0'
license_file 'COPYING'

source url: "http://ftp.gnu.org/pub/gnu/gettext/gettext-#{version}.tar.gz"

version('0.19.8') { source md5: '7ad5c90e32ac6828de955a0432ab4a7c' }

relative_path "gettext-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_args = [
      "--prefix=#{install_dir}/embedded",
      '--disable-native-java',
      '--enable-threads',
      '--disable-csharp',
      '--disable-java',
      '--without-git',
  ]
  configure_cmd = './configure'
  configure_command = configure_args.unshift(configure_cmd).join(' ')

  command configure_command, env: env, in_msys_bash: true

  make env: env
  make 'install', env: env
end