use 5.010;
use strict;
use warnings;

use Gtk3;    # to escape warnings "Too late to run INIT block"

use Test::More;

use_ok("Shutter::Draw::Utils");

subtest "points_to_canvas_points" => sub {
    can_ok( "Shutter::Draw::Utils", "points_to_canvas_points" );

    my @points = qw/116.295135498047 146.150695800781 463.101501464844 458.543548583984/;
    my $res    = Shutter::Draw::Utils::points_to_canvas_points(@points);

    ok( defined $res, "There's a result of points_to_canvas_points" );
    isa_ok( $res, "GooCanvas2::CanvasPoints" );
};

subtest "modify_text_in_properties" => sub {
    can_ok( "Shutter::Draw::Utils", "modify_text_in_properties" );

    # ..
};

subtest "import_from_utheme_ctxt" => sub {
    can_ok( "Shutter::Draw::Utils", "import_from_utheme_ctxt" );

    # ..
};

subtest "import_from_session" => sub {
    can_ok( "Shutter::Draw::Utils", "import_from_session" );

    # ..
};

done_testing;
