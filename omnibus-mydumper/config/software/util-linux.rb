name 'util-linux'
default_version '2.20.1'
skip_transitive_dependency_licensing true
license 'GPL-3.0'
license_file 'COPYING'

source url: "http://archive.ubuntu.com/ubuntu/pool/main/u/util-linux/util-linux_#{version}.orig.tar.gz"

version('2.20.1') { source md5: '00bbf6e9698a713a9452c91b76eda756' }

relative_path "util-linux-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  configure_args = [
      "--prefix=#{install_dir}/embedded"
  ]
  configure_cmd = './configure'
  configure_command = configure_args.unshift(configure_cmd).join(' ')

  command configure_command, env: env, in_msys_bash: true

  make env: env
  make 'install', env: env
end