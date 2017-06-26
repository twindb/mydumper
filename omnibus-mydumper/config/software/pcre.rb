name 'pcre'
default_version '8.31'
skip_transitive_dependency_licensing true
license 'GPL-3.0'
license_file 'COPYING'

source url: "http://archive.ubuntu.com/ubuntu/pool/main/p/pcre3/pcre3_#{version}.orig.tar.gz"

version('8.31') { source sha256: '4e1f5d462796fdf782650195050953b8503b2a2fc05c31b681c2d5d54d1f659b' }

relative_path "pcre-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_args = [
      "--prefix=#{install_dir}/embedded",
      '--enable-utf8',
      '--enable-unicode-properties',
  ]
  configure_cmd = './configure'
  configure_command = configure_args.unshift(configure_cmd).join(' ')

  command configure_command, env: env, in_msys_bash: true

  make env: env
  make 'install', env: env
end