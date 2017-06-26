Name:           mydumper
Version:        0.9.1
Release:        1%{?dist}
Summary:        How MySQL DBA & support engineer would imagine 'mysqldump' ;-)

License:        GNU GPL v3
URL:            https://github.com/twindb/mydumper
Source0:        mydumper-%{version}.tar.gz

BuildRequires:  gcc gcc-c++ cmake glib2-devel mysql-devel zlib-devel pcre-devel openssl-devel
Requires:       mysql-devel

%description
* Parallelism (hence, speed) and performance (avoids expensive character set conversion routines, efficient code overall)
* Easier to manage output (separate files for tables, dump metadata, etc, easy to view/parse data)
* Consistency - maintains snapshot across all threads, provides accurate master and slave log positions, etc
* Manageability - supports PCRE for specifying database and tables inclusions and exclusions

%prep
%setup -q


%build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
%make_install


%files
%{_bindir}/mydumper
%{_bindir}/myloader
%doc



%changelog
