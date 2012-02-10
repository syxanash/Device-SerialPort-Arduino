use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Device::SerialPort::Arduino',
    AUTHOR              => q{Simone (syxanash) <syxanash@gmail.com>},
    VERSION_FROM        => 'lib/Device/SerialPort/Arduino.pm',
    ABSTRACT_FROM       => 'lib/Device/SerialPort/Arduino.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Carp' => 0,
        'Time::HiRes' => 0,
        'Device::SerialPort' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Device-SerialPort-Arduino-*' },
);
