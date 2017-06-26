name 'mydumper'

license 'GPL-3.0'

dependency 'glib'
dependency 'mysql-client'
dependency 'pcre'

source path: '/mydumper'

build do
  env = with_standard_compiler_flags(with_embedded_path)
  command "cmake -DCMAKE_INSTALL_PREFIX:PATH=#{install_dir}/embedded .", env: env
  make env: env
  make 'install', env: env
end
