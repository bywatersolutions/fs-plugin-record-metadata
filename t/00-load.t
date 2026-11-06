use Modern::Perl;
use Test::More tests => 7;

use FindBin;
use lib "$FindBin::Bin/..";

use_ok('Koha::Plugin::Com::ByWaterSolutions::FSRecordMetadata');
use_ok('Koha::Plugin::Com::ByWaterSolutions::FSRecordMetadata::AccessLevel');
use_ok('Koha::Plugin::Com::ByWaterSolutions::FSRecordMetadata::UserRoles');
use_ok('Koha::Plugin::Com::ByWaterSolutions::FSRecordMetadata::Entries');
use_ok('Koha::Plugin::Com::ByWaterSolutions::FSRecordMetadata::Problems');
use_ok('Koha::Plugin::Com::ByWaterSolutions::FSRecordMetadata::WriteMARC');
use_ok('Koha::Plugin::Com::ByWaterSolutions::FSRecordMetadata::Controller');
