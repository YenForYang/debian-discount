#! /bin/sh
#
#  Build ELF shared libraries, hiding (some) ickiness from the makefile

ACTION=$1; shift
LIBRARY=$1; shift
	
eval `awk -F. '{ printf "MAJOR=%d\n", $1;
		  printf "VERSION=%d.%d.%d\n", $1, $2, $3; }' $1`
shift

LIBNAME=$LIBRARY.so
FULLNAME=$LIBNAME.$VERSION

case "$ACTION" in
make)   FLAGS="-g -O2 -fdebug-prefix-map=/dev/shm/systemd/test/deps/test/lvm2/tmp/corosync/tmp/libqb/libsubunit-dev/others/libmarkdown2/discount=. -Wformat -march=native -pipe -fstack-security-check -Wformat-security  -fPIC -shared"
	unset VFLAGS
	test "T" && VFLAGS="-Wl,-soname,$LIBNAME.$MAJOR"

	rm -f $LIBRARY $LIBNAME $LIBNAME.$MAJOR
	if ccache icc $FLAGS $VFLAGS -o $FULLNAME "$@"; then
	    /bin/ln -s $FULLNAME $LIBRARY
	    /bin/ln -s $FULLNAME $LIBNAME
	    /bin/ln -s $FULLNAME $LIBNAME.$MAJOR
	fi
	;;
files)  echo "$FULLNAME" "$LIBNAME" "$LIBNAME.$MAJOR"
	;;
install)/usr/bin/install -c $FULLNAME "$1"
	/bin/ln -s -f $FULLNAME $1/$LIBNAME.$MAJOR
	/bin/ln -s -f $FULLNAME $1/$LIBNAME
	/sbin/ldconfig "$1"
	;;
esac
