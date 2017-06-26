#
# Copyright 2017 YOUR NAME
#
# All Rights Reserved.
#

name 'mydumper'
maintainer 'TwinDB LLC'
homepage 'https://twindb.com'

# Defaults to C:/mydumper on Windows
# and /opt/mydumper on all other platforms
install_dir "#{default_root}/#{name}"

build_version '0.9.1'
build_iteration 1

# Creates required build directories
dependency 'preparation'

# mydumper dependencies/components
dependency 'mydumper'

# Version manifest file
dependency 'version-manifest'

exclude '**/.git'
exclude '**/bundler/git'
