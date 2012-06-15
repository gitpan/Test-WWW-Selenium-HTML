# $Id: 107action-died.t,v 2aef9f46b0fd 2012/06/06 03:27:58 tomh $

use warnings;
use strict;

use Test::More;

use Test::WWW::Selenium::HTML;
use IO::Socket::INET;
use Test::WWW::Selenium;
use Time::HiRes qw(usleep);

use lib './t/lib';
use TestDaemon;

if (not TestDaemon::selenium_server_exists()) {
    plan skip_all => "Unable to test, could not find Selenium Server.";
}
plan tests => 4;

my $port = TestDaemon::get_port();

my $pid = fork();
if (not $pid) {
    close STDIN;
    close STDOUT;
    close STDERR;
    TestDaemon::start($port);
} else {
    my $sel = 
        Test::WWW::Selenium->new(
            host        => "localhost",
            port        => 4444,
            browser     => "*firefox",
            browser_url => "http://localhost:$port/"
        );
    my $asc = Test::WWW::Selenium::HTML->new($sel);
    eval { $asc->run(data => <<EOF);
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head></head><body><table><tbody>
    <tr><td>actionThatDoesNotExist</td>
        <td></td>
        <td></td></tr>
</tbody></table></body></html>
EOF
    };
    ok($@, 'Died on invalid action');
    like($@, qr/Unhandled command at \[no filename\]:4.*actionThatDoesNotExist/,
        'Got correct error message');

    {
        no warnings;
        no strict 'refs';
        *{'Test::WWW::Selenium::AUTOLOAD'} = sub {
            die 'action error';
        };
    }

    eval { $asc->run(data => <<EOF);
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head></head><body><table><tbody>
    <tr><td>goBack</td>
        <td></td>
        <td></td></tr>
</tbody></table></body></html>
EOF
    };
    ok($@, 'Died during action execution');
    like($@, qr/Died while running test: action error/,
        'Got correct error message');

    my $ua = LWP::UserAgent->new();
    $ua->get('http://localhost:port/shutdown.html');

    kill 15, $pid;
}

1;

__END__

Copyright 2012 APNIC Pty Ltd.

This library is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

The full text of the license can be found in the LICENSE file included
with this module.

