use strict;
use warnings;
use Test::More;

use Dancer2 qw(:syntax :tests);
use Dancer2::Plugin::DBIC;
use t::lib::TestApp;
use Dancer2::Test apps => [ 't::lib::TestApp' ];
use DBI;
use File::Temp qw(tempfile);

eval { require DBD::SQLite; require DBIx::Class::Schema::Loader };
if ($@) {
    plan skip_all =>
        'DBD::SQLite and DBIx::Class::Schema::Loader required for these tests';
} else {
    plan tests => 7;
}

my (undef, $dbfile) = tempfile(SUFFIX => '.db');

set plugins => {
    DBIC => {
        foo => {
            dsn =>  "dbi:SQLite:dbname=$dbfile",
        }
    }
};

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile");

my @sql = (
    q/create table users (id INTEGER primary key, name VARCHAR(64))/,
    q/insert into users values (1, 'sukria')/,
    q/insert into users values (2, 'bigpresh')/,
);

$dbh->do($_) for @sql;

response_status_is    [ GET => '/' ], 200,   "GET / is found";
response_content_like [ GET => '/' ], qr/2/, "content looks good for /";

response_status_is [ GET => '/user/1' ], 200, 'GET /user/1 is found';

response_content_like [ GET => '/user/1' ], qr/sukria/,
  'content looks good for /user/1';
response_content_like [ GET => '/user/2' ], qr/bigpresh/,
  "content looks good for /user/2";

response_status_is [ DELETE => '/user/2' ], 200, 'DELETE /user/2 is ok';
response_content_like [ GET => '/' ], qr/1/, 'content looks good for /';

unlink $dbfile;
