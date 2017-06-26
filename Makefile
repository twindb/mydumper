VERSION = 0.9.1

build_dir = .build
pwd := $(shell pwd)
top_dir = ${pwd}/${build_dir}/rpmbuild
spec = packages/rpm/mydumper.spec

package:
	@if ! test -z "`which yum 2>/dev/null`"; then make build-rpm; fi
	@if ! test -z "`which apt-get 2>/dev/null`"; then make deb-dependencies build-deb; fi


build-rpm: rpmbuild-package rpm-src rpm-dependencies
	rpmbuild --define '_topdir ${top_dir}' -ba ${spec}


rpm-src:
	rm -rf "${build_dir}"
	mkdir -p ${top_dir}/SOURCES/mydumper-$(VERSION)
	cp -R * ${top_dir}/SOURCES/mydumper-$(VERSION)
	tar zcf ${top_dir}/SOURCES/mydumper-$(VERSION).tar.gz -C ${top_dir}/SOURCES mydumper-$(VERSION)

rpmbuild-package:
	which rpmbuild || yum -y install rpm-build

rpm-dependencies:
	yum -y install $(shell grep BuildRequires ${spec} | sed 's/BuildRequires://')


clean:
	rm -rf "${build_dir}"
	rm -rf CMakeFiles
	rm -rf cmake_install.cmake
	rm -rf docs/CMakeFiles docs/cmake_install.cmake
	rm -rf config.h


DOCKER_IMAGE := "centos:centos7"
docker-start:
	@docker run \
        -v $(pwd):/mydumper \
        -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
        -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" \
        -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
        -it \
        "${DOCKER_IMAGE}" \
        bash -l
