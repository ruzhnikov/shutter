package Shutter::NewApp;

use strict;
use warnings;
use 5.010;
use utf8;
use diagnostics;

use Carp::Always;

binmode(STDOUT, "encoding(UTF-8)");
use Encode;

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

use Pango;
use Gtk3 '-init';
use Glib::Object::Subclass qw/Gtk3::Application/;
use Gtk3::ImageView 10;

my $shutter_root = $ENV{'SHUTTER_ROOT'};

# require lib;
# import lib "$shutter_root/share/shutter/resources/modules";

sub STARTUP {
    my ($app) = @_;
    $app->SUPER::STARTUP();

    my $window = Gtk3::ApplicationWindow->new($app);
    $window->show_all;
}

1;
