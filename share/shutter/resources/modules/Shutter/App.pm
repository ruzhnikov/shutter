package Shutter::App;

use strict;
use warnings;
use 5.10;
use utf8;

BEGIN {
    use Glib::Object::Introspection;
    Glib::Object::Introspection->setup(
        basename => 'Gio',
        version  => '2.0',
        package  => 'Glib::IO',
    );
    Glib::Object::Introspection->setup(
        basename => 'Wnck',
        version  => '3.0',
        package  => 'Wnck',
    );
    Glib::Object::Introspection->setup(
        basename => 'GdkX11',
        version  => '3.0',
        package  => 'Gtk3::GdkX11',
    );
}

use Gtk3 '-init';

my $shutter_root = $ENV{'SHUTTER_ROOT'}

require lib;
import lib "$shutter_root/share/shutter/resources/modules";

1;
