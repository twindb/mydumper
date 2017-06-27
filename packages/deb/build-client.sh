set -eux
version=0.0
src_dir=twindb-$version

rm -rvf $src_dir
mkdir $src_dir
cp -vR twindb-client/* $src_dir
tar zvcf twindb-$version.tar.gz  $src_dir

# 1)
mv twindb-$version.tar.gz twindb_${version}.orig.tar.gz

# 2)

tar zxf twindb_${version}.orig.tar.gz
cd twindb-$version
cp -R support/deb/debian .
debuild -us -uc


#scp /home/akuzminsky/rpmbuild/RPMS/noarch/twindb-0.0-*.noarch.rpm twindb-production:/var/lib/twindb-repo-public
#ssh twindb-production createrepo /var/lib/twindb-repo-public

