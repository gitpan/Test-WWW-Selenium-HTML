# $Id: 001basic.t,v 6eb3dbabe8f5 2011/06/27 08:04:33 tomh $

use strict;
use warnings;

use Test::More;

use File::Find;
use lib './t/lib2';

my @files = ();
find(sub { /\.pm$/ and push @files, $File::Find::name }, qw/blib/);

plan tests => @files + 1;

ok(@files, "At least one module found");

for my $module (@files) {
    $module =~ s!^blib/lib/!!;
    $module =~ s!/!::!g;
    $module =~ s/\.pm$//;
    use_ok($module);
}

__END__

Copyright 2012 APNIC Pty Ltd.

This library is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

The full text of the license can be found in the LICENSE file included
with this module.

