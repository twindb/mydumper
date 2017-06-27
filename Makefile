VERSION = 0.9.1

build_dir = .build
pwd := $(shell pwd)
top_dir = ${pwd}/${build_dir}/rpmbuild
spec = packages/rpm/mydumper.spec

package:
	if test -f /etc/redhat-release ; then make build-rpm; fi
	if test -f /etc/debian_version ; then make build-deb; fi

###### PRM stuff

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


###### Debian stuff
deb_packages = build-essential devscripts debhelper libglib2.0-dev libmysqlclient-dev zlib1g-dev libpcre3-dev libssl-dev cmake libmariadbclient-dev


build-deb: deb-dependencies deb-changelog deb-src
	cd "${build_dir}/mydumper-${VERSION}" && debuild -us -uc

deb-dependencies:
	@echo "Checking dependencies"
	@for p in ${deb_packages}; \
    do echo -n "$$p ... " ; \
        if test -z "`dpkg -l | grep $$p`"; \
        then \
            echo "$$p ... NOT installed"; \
            apt-get -y install $$p; \
        else \
            echo "installed"; \
        fi ; \
    done

deb-src:
	echo "Preparing source code"
	rm -rf "${build_dir}"
	mkdir -p "${build_dir}/mydumper-${VERSION}"
	cp -R * "${build_dir}/mydumper-${VERSION}"
	tar zcf "${build_dir}/mydumper_${VERSION}.orig.tar.gz" -C "${build_dir}" "mydumper-${VERSION}"
	cp -LR packages/deb/debian.`lsb_release -sc`/ "${build_dir}/mydumper-${VERSION}/debian"
	cp -LR packages/deb/debian/changelog "${build_dir}/mydumper-${VERSION}/debian"


deb-changelog:
	@echo "Generating changelog"
	export DEBEMAIL="TwinDB Packager (TwinDB packager key) <packager@twindb.com>" ; \
	export version=${VERSION}-1 ; \
	cd packages/deb/ ; \
	rm -f debian/changelog ; \
	export distr=`lsb_release -sc` ; \
	dch -v $$version+$$distr --create --package mydumper --distribution $$distr --force-distribution "New version $$version" ;



clean:
	rm -rf "${build_dir}"
	rm -rf CMakeFiles
	rm -rf cmake_install.cmake
	rm -rf docs/CMakeFiles docs/cmake_install.cmake
	rm -rf config.h


DOCKER_IMAGE ?= "centos:centos7"
docker-start:
	@docker run \
        -v $(pwd):/mydumper \
        -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
        -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" \
        -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
        -it \
        "${DOCKER_IMAGE}" \
        bash -l


package-centos:
	@docker run \
        -v $(pwd):/mydumper \
        "${DOCKER_IMAGE}" \
        bash -c "yum clean all && yum -y install make && make -C /mydumper package"

package-debian:
	@docker run \
        -v $(pwd):/mydumper \
        "${DOCKER_IMAGE}" \
        bash -c "apt-get update && apt-get -y install make && make -C /mydumper package"


package-ubuntu:
	@docker run \
        -v $(pwd):/mydumper \
        "${DOCKER_IMAGE}" \
        bash -c "apt-get update && apt-get -y install make && make -C /mydumper package"
