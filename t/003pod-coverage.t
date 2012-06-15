# $Id: 003pod-coverage.t,v 6eb3dbabe8f5 2011/06/27 08:04:33 tomh $

use strict;
use warnings;

use blib;

use Test::More;
eval {
    require Test::Pod::Coverage;
    Test::Pod::Coverage->import();
};
plan skip_all => 
    "Test::Pod::Coverage required for testing POD coverage" if $@;

all_pod_coverage_ok();

__END__

Copyright 2012 APNIC Pty Ltd.

This library is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

The full text of the license can be found in the LICENSE file included
with this module.

