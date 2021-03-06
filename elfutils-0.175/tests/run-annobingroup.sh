#! /bin/sh
# Copyright (C) 2018 Red Hat, Inc.
# This file is part of elfutils.
#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# elfutils is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

. $srcdir/test-subr.sh

# Testfile generated by annobin, creates group.
# strip and unstrip it. Check group symbol/name is correct.

# echo "int __attribute__((cold)) foo (void) { return 42; }" \
#      > testfile-annobingroup.c
# gcc -g -O2 -fplugin=annobin -c testfile-annobingroup.c
testfiles testfile-annobingroup.o

tempfiles merged.elf stripped.elf debugfile.elf remerged.elf

testrun_compare ${abs_top_builddir}/src/readelf -g testfile-annobingroup.o << EOF

Section group [ 1] '.group' with signature '.text.unlikely.group' contains 3 entries:
  [ 7] .gnu.build.attributes..text.unlikely
  [ 8] .rela.gnu.build.attributes..text.unlikely
  [ 9] .text.unlikely
EOF

testrun ${abs_top_builddir}/src/strip -o stripped.elf -f debugfile.elf testfile-annobingroup.o

testrun_compare ${abs_top_builddir}/src/readelf -g stripped.elf << EOF

Section group [ 1] '.group' with signature '.text.unlikely.group' contains 3 entries:
  [ 7] .gnu.build.attributes..text.unlikely
  [ 8] .rela.gnu.build.attributes..text.unlikely
  [ 9] .text.unlikely
EOF

testrun_compare ${abs_top_builddir}/src/readelf -g debugfile.elf << EOF

Section group [ 1] '.group' with signature '.text.unlikely.group' contains 3 entries:
  [ 7] .gnu.build.attributes..text.unlikely
  [ 8] .rela.gnu.build.attributes..text.unlikely
  [ 9] .text.unlikely
EOF

testrun ${abs_top_builddir}/src/unstrip -o remerged.elf stripped.elf debugfile.elf

testrun_compare ${abs_top_builddir}/src/readelf -g remerged.elf << EOF

Section group [ 1] '.group' with signature '.text.unlikely.group' contains 3 entries:
  [ 7] .gnu.build.attributes..text.unlikely
  [ 8] .rela.gnu.build.attributes..text.unlikely
  [ 9] .text.unlikely
EOF

testrun ${abs_top_builddir}/src/elfcmp testfile-annobingroup.o remerged.elf

# echo "void * __attribute__((cold)) foo (void) { return foo; }"
#      > testfile-annobingroup-i386.c
# gcc -fpic -g -O2 -fplugin=annobin -c testfile-annobingroup-i386.c
testfiles testfile-annobingroup-i386.o

testrun_compare ${abs_top_builddir}/src/readelf -g testfile-annobingroup-i386.o << EOF

Section group [ 1] '.group' with signature '.text.unlikely.group' contains 3 entries:
  [ 8] .gnu.build.attributes..text.unlikely
  [ 9] .rel.gnu.build.attributes..text.unlikely
  [10] .text.unlikely

COMDAT section group [ 2] '.group' with signature '__x86.get_pc_thunk.ax' contains 1 entry:
  [13] .text.__x86.get_pc_thunk.ax
EOF

testrun ${abs_top_builddir}/src/strip -o stripped.elf -f debugfile.elf testfile-annobingroup-i386.o

testrun_compare ${abs_top_builddir}/src/readelf -g stripped.elf << EOF

Section group [ 1] '.group' with signature '.text.unlikely.group' contains 3 entries:
  [ 8] .gnu.build.attributes..text.unlikely
  [ 9] .rel.gnu.build.attributes..text.unlikely
  [10] .text.unlikely

COMDAT section group [ 2] '.group' with signature '__x86.get_pc_thunk.ax' contains 1 entry:
  [13] .text.__x86.get_pc_thunk.ax
EOF

testrun_compare ${abs_top_builddir}/src/readelf -g debugfile.elf << EOF

Section group [ 1] '.group' with signature '.text.unlikely.group' contains 3 entries:
  [ 8] .gnu.build.attributes..text.unlikely
  [ 9] .rel.gnu.build.attributes..text.unlikely
  [10] .text.unlikely

COMDAT section group [ 2] '.group' with signature '__x86.get_pc_thunk.ax' contains 1 entry:
  [13] .text.__x86.get_pc_thunk.ax
EOF

testrun ${abs_top_builddir}/src/unstrip -o remerged.elf stripped.elf debugfile.elf

testrun_compare ${abs_top_builddir}/src/readelf -g remerged.elf << EOF

Section group [ 1] '.group' with signature '.text.unlikely.group' contains 3 entries:
  [ 8] .gnu.build.attributes..text.unlikely
  [ 9] .rel.gnu.build.attributes..text.unlikely
  [10] .text.unlikely

COMDAT section group [ 2] '.group' with signature '__x86.get_pc_thunk.ax' contains 1 entry:
  [13] .text.__x86.get_pc_thunk.ax
EOF

testrun ${abs_top_builddir}/src/elfcmp testfile-annobingroup-i386.o remerged.elf

# echo "void * foo (void) { return foo; }" > testfile-annobingroup-x86_64.c
# gcc -g -O2 -fplugin=annobin -c testfile-annobingroup-x86_64.c
testfiles testfile-annobingroup-x86_64.o

testrun_compare ${abs_top_builddir}/src/readelf -g testfile-annobingroup-x86_64.o << EOF

Section group [ 1] '.group' with signature '.text.hot.group' contains 3 entries:
  [11] .text.hot
  [12] .gnu.build.attributes.hot
  [13] .rela.gnu.build.attributes.hot

Section group [ 2] '.group' with signature '.text.unlikely.group' contains 3 entries:
  [14] .text.unlikely
  [15] .gnu.build.attributes.unlikely
  [16] .rela.gnu.build.attributes.unlikely

Section group [ 3] '.group' with signature '.text.hot..group' contains 1 entry:
  [26] .text.hot

Section group [ 4] '.group' with signature '.text.unlikely..group' contains 1 entry:
  [27] .text.unlikely
EOF

testrun ${abs_top_builddir}/src/strip -o stripped.elf -f debugfile.elf testfile-annobingroup-x86_64.o

# This would/should work, except for the unknown NOTEs.
# testrun ${abs_top_builddir}/src/elflint --gnu stripped.elf
# testrun ${abs_top_builddir}/src/elflint --gnu --debug debugfile.elf

testrun ${abs_top_builddir}/src/unstrip -o remerged.elf stripped.elf debugfile.elf

testrun ${abs_top_builddir}/src/elfcmp testfile-annobingroup-x86_64.o remerged.elf

exit 0
