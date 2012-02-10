#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Device::SerialPort::Arduino' ) || print "Bail out!
";
}

diag( "Testing Device::SerialPort::Arduino $Device::SerialPort::Arduino::VERSION, Perl $], $^X" );
