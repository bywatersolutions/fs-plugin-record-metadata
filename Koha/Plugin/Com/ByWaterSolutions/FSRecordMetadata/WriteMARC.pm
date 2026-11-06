package Koha::Plugin::Com::ByWaterSolutions::FSRecordMetadata::WriteMARC;

use Modern::Perl;

use MARC::Field;

use C4::Biblio qw( ModBiblio );
use Koha::Biblios;

use Exporter 'import';

our @EXPORT_OK = qw( write_entry_856 );

my %SUBFIELD_MAP = (
    dtn                => 'x',
    volume_description => 'j',
    owning_institution => 'i',
    scan_site          => 's',
    access             => 'l',
);

my @INDICATORS = ( ' ', ' ' );

sub write_entry_856 {
    my ( $entry, $opts ) = @_;
    $opts //= {};

    return 0 unless $entry && $entry->{dtn} && $entry->{biblionumber};

    my $ok = eval {

        my $biblio = Koha::Biblios->find( $entry->{biblionumber} );
        die "no biblio $entry->{biblionumber}\n" unless $biblio;

        my $record = $biblio->metadata->record;
        die "record for $entry->{biblionumber} will not parse\n" unless $record;

        my %value;
        for my $column ( keys %SUBFIELD_MAP ) {
            $value{ $SUBFIELD_MAP{$column} } = $entry->{$column};
        }

        my ($field) = grep { ( $_->subfield('x') // '' ) eq $entry->{dtn} }
            $record->field('856');

        if ($field) {
            for my $code ( sort keys %value ) {
                if ( defined $value{$code} && length $value{$code} ) {
                    $field->update( $code => $value{$code} );
                }
                else {
                    $field->delete_subfield( code => $code );
                }
            }
        }
        else {
            my @subfields =
                map  { ( $_ => $value{$_} ) }
                grep { defined $value{$_} && length $value{$_} }
                sort keys %value;

            return 0 unless @subfields;

            $record->insert_fields_ordered(
                MARC::Field->new( '856', @INDICATORS, @subfields )
            );
        }

        ModBiblio(
            $record,
            $entry->{biblionumber},
            $biblio->frameworkcode // '',
            {
                #do NOT re-link authority records.
                disable_autolink => 1,
                
                #skip record reindex
                skip_record_index => $opts->{skip_record_index} ? 1 : 0,
            }
        );

        1;
    };

    unless ($ok) {
        #if writeback to MARC fails we should still make the entry
        #warn why MARC writeback failed
        warn "FSRecordMetadata: 856 writeback failed for DTN "
            . ( $entry->{dtn} // '?' ) . ": $@";
        return 0;
    }

    return 1;
}

1;
