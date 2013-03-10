use strict;
use Test::More tests => 14;
use lib "$ENV{LJHOME}/cgi-bin";
BEGIN { require 'ljlib.pl'; }

use LJ::Tags;

my $validated;

$validated = [];
ok(   LJ::Tags::is_valid_tagstring( "tag 1, tag 2", $validated ), "simple case" );
is_deeply( $validated, [ "tag 1", "tag 2" ], "simple case" );

note( "underscores" );
$validated = [];
ok( ! LJ::Tags::is_valid_tagstring( "tag 1, _tag 2, tag 3", $validated ), "has leading underscore" );
is_deeply( $validated, [ "tag 1" ], "has leading underscore (cut short)" );

$validated = [];
ok(   LJ::Tags::is_valid_tagstring( "tag 1, tag 2_, tag 3", $validated ), "has trailing underscore" );
is_deeply( $validated, [ "tag 1", "tag 2_", "tag 3" ], "has trailing underscore" );

$validated = [];
ok(   LJ::Tags::is_valid_tagstring( "tag 1, tag_2, tag 3", $validated ), "has internal underscore" );
is_deeply( $validated, [ "tag 1", "tag_2", "tag 3" ], "has internal underscore" );

note( "extra whitespace" );
$validated = [];
ok(   LJ::Tags::is_valid_tagstring( "tag 1 , tag 2  , tag 3   ", $validated ), "trailing spaces" );
is_deeply( $validated, [ "tag 1", "tag 2", "tag 3" ], "trailing spaces" );

$validated = [];
ok(   LJ::Tags::is_valid_tagstring( " tag 1,  tag 2,   tag 3", $validated ), "leading spaces" );
is_deeply( $validated, [ "tag 1", "tag 2", "tag 3" ], "leading spaces" );


note( "spaces + truncation" );
$validated = [];
ok(   LJ::Tags::is_valid_tagstring( "x" x ( LJ::CMAX_KEYWORD - 1 ) . " yyy" , $validated ), "truncated right at a trailing space" );
is_deeply( $validated, [ "x" x ( LJ::CMAX_KEYWORD - 1 ) ], "truncated right at a trailing space; didn't save the trailing space" );