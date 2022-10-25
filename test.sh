#!/bin/bash

function fail {
    echo "FAILURE: $1"; exit "$1"
}

mkdir -p ./build
BUILDDIR="$(realpath ./build)"
RP="$(realpath ./rp)"

$RP --killdaemon

rm -rf "$BUILDDIR"
mkdir -p "$BUILDDIR"/{src,dst}\ repo

DST="$BUILDDIR/dst repo"
cd "$BUILDDIR/src repo" || fail 99

#Setup initial repo, and populate it a bit.
git init .
echo "ignored*" > .gitignore
mkdir "test dir"
touch file
touch ignored
touch "test dir/file2"
mkdir -p a/b/c/d
touch a/b/c/d/file
touch "test dir/committedfile"
git add "test dir/committedfile"
git commit -q -m "test commit"
touch "test dir/stagedfile"
git add "test dir/stagedfile"

trap '$RP --killdaemon' EXIT
$RP --init "$DST" || fail 98

$RP true || fail 97 #Make sure the daemon has completed initial sync.

#Test initial sync.
[ -f "$DST/.git/config" ] || fail 89
[ -f "$DST/.git/info/exclude" ] || fail 88
[ -f "$DST/file" ] || fail 87
[ -f "$DST/test dir/file2" ] || fail 86
[ -f "$DST/a/b/c/d/file" ] || fail 85
[ -f "$DST/test dir/committedfile" ] || fail 84
[ -f "$DST/test dir/stagedfile" ] || fail 83
[ ! -f "$DST/ignored" ] || fail 82

$RP ls "test dir" >/dev/null || fail 81
$RP ls "test dir/nothere" 2>/dev/null && fail 80

#Test incremental changes.
mkdir -p "incr dir/a/b/c/d"
touch "incr dir/a/b/c/file"
touch ignored2
rm file

$RP true || fail 97

[ -d "$DST/incr dir/a/b/c/d" ] || fail 79 #race in inotifywait for new directories.
[ -f "$DST/incr dir/a/b/c/file" ] || fail 78
[ ! -f "$DST/ignored" ] || fail 77
[ ! -f "$DST/ignored2" ] || fail 76
[ ! -f "$DST/file" ] || fail 75

#Check that repos are the same
[ "$(find .git | wc -l)" -eq "$(find "$DST/.git" | wc -l)" ] || fail 69
[ "$(git ls-files -co --exclude-standard | wc -l)" \
      -eq \
      "$(git -C "$DST" ls-files -co --exclude-standard | wc -l)" ] || fail 68

#Cleanup
if [ -n "$RP_TESTS_DUMP_LOGS" ]; then
    echo Dameon logs:
    cat ~/.local/share/rp/*.log
fi
$RP --uninit
echo Success
exit 0
