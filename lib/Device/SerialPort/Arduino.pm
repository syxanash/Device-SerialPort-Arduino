package Device::SerialPort::Arduino;

use strict;
use warnings;

use Time::HiRes;
use Carp;
use Device::SerialPort;

use vars qw($VERSION);

our $VERSION = '0.07';

sub new {
    my $class = shift;
    
    my $self = bless {}, $class;

    my %init = @_;

    # Sets many parameters for Device::SerialPort usage

    $self->{'port'}     = $init{'port'};
    $self->{'baudrate'} = $init{'baudrate'};

    $self->{'databits'} = $init{'databits'};
    $self->{'parity'}   = $init{'parity'};
    $self->{'stopbits'} = $init{'stopbits'};

    $self->initialize();

    return $self;
}

sub initialize {

    my $self = shift;

    $self->{'DSP'} = Device::SerialPort->new( $self->{'port'} )
      or croak "Can't open " . $self->{'port'} . " - $!\n";

    # Checks if the baudrate was defined otherwise sets a default
    # value which is 9600

    $self->{'baudrate'} = 9600
      unless ( defined( $self->{'baudrate'} ) );

    $self->{'DSP'}->baudrate( $self->{'baudrate'} );

    # Checks for some default parameters which shouldn't be changed

    $self->{'databits'} = 8
      unless ( defined( $self->{'databits'} ) );

    $self->{'parity'} = 'none'
      unless ( defined( $self->{'parity'} ) );

    $self->{'stopbits'} = 1
      unless ( defined( $self->{'stopbits'} ) );

    # Sets the remaining parameters

    $self->{'DSP'}->databits( $self->{'databits'} );
    $self->{'DSP'}->parity( $self->{'parity'} );
    $self->{'DSP'}->stopbits( $self->{'stopbits'} );
}

sub communicate {

    my $self  = shift;
    my $chars = shift;
    
    # Returns 0 if $chars is an empty string

    return 0 unless $chars;

    $self->{'DSP'}->write($chars);

    return $chars;
}

sub receive {

    my $self  = shift;
    my $delay = shift;

    while (1) {

        # Check if any data is coming in. If true
        # returns the character just catched.

        my $char = $self->{'DSP'}->lookfor();

        return $char
            if $char;
        
        # The following lines, will be used for
        # slower reading, but lower CPU usage, and to
        # avoid buffer overflow due to sleep function. (arduino.cc)

        if ( defined $delay ) {
            $self->{'DSP'}->lookclear;

            sleep($delay);
        }
    }
}

1;

__END__

=head1 NAME

Device::SerialPort::Arduino - A friendly way to interface Perl with your Arduino using Device::SerialPort

=head1 VERSION

Version 0.07

=head1 SYNOPSIS

  use Device::SerialPort::Arduino;

  my $Arduino = Device::SerialPort::Arduino->new(
    port     => '/dev/ttyACM0',
    baudrate => 9600,

    databits => 8,
    parity   => 'none',
  );

  # Reading from Arduino via Serial

  while (1) {
      print $Arduino->receive(), "\n";
  }

  # or with a delay

  while (1) {
      print $Arduino->receive(1), "\n";
  }

  # Send something via Serial

  $Arduino->communicate('oh hi!!11')
    or die 'Warning, empty string: ', "$!\n";

=head1 DESCRIPTION

The C<Device::SerialPort::Arduino> is a class which aims to be an easier
way to write Perl applications which easily communicate with Arduino.
If you'd like to create an application using this module you firstly
have to declare many parameters such as port, baudrate, databits etc.
Remember that, some parameters such as databits, parity and stopbits,
shouldn't be changed for a well serial communication with your Arduino.

=head1 METHODS

Here are some methods which will be used to communicate with your device.

=over

=item $Arduino->receive()

The method C<receive> checks if there's a stream of information via serial port
using the method C<lookfor> contained into C<Device::SerialPort>
You can also send via C<receive> an integer parameter, if you'd like to delay
the recepit of information from your Arduino board.

=item $arduino->communicate( $chars )

The method C<communicate> simply sends to your Arduino board characters taken
as a parameter, using the method C<write> of C<Device::SerialPort>

=back

=head1 AUTHOR

Simone 'Syxanash' Marzulli, C<< <syxanash at cpan.org> >>

=head1 DEPENDENCIES

Device::SerialPort ~ http://search.cpan.org/~cook/Device-SerialPort-1.04/SerialPort.pm

=head1 SEE ALSO

Carp ~ http://search.cpan.org/~zefram/Carp-1.25/lib/Carp.pm

Time::HiRes ~ http://search.cpan.org/~zefram/Time-HiRes-1.9725/HiRes.pm

http://arduino.cc/playground/Interfacing/PERL

=head1 BUGS

Please report any bugs or feature requests to C<syxanash at cpan.org>, I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Device::SerialPort::Arduino

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Simone 'Syxanash' Marzulli.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
