# -*-Perl-*-
## Bioperl Test Harness Script for Modules
##
# $Id$

my $error;
use strict;
use vars qw($TESTCOUNT);

BEGIN { 
    # to handle systems with no installed Test module
    # we include the t dir (where a copy of Test.pm is located)
    # as a fallback
    $error = 0; 
    eval { require Test::More; };
    if( $@ ) {
	use lib 't/lib';
    }
    use Test::More;
    $TESTCOUNT = 61;
    plan tests => $TESTCOUNT;
	use_ok('Bio::Tools::Est2Genome');
}

my $verbose = 0;

my $parser = new Bio::Tools::Est2Genome(-file   => Bio::Root::IO->catfile
					('t','data', 'hs_est.est2genome'));

ok($parser);
my $feature_set = $parser->parse_next_gene;
like(ref($feature_set), qr/ARRAY/i );

is(scalar @$feature_set, 7);
my @exons = grep { $_->primary_tag eq 'Exon' } @$feature_set;
my @introns = grep { $_->primary_tag eq 'Intron' } @$feature_set;

my @expected_exons = ( [695,813,1,1,119,1],
		       [1377,1493,1,120,236,1],
		       [1789,1935,1,237,382,1],
		       [2084,2180,1,383,479,1]);
my @expected_introns = ( [814,1376,1],
			 [1494,1788,1],
			 [1936,2083,1] );

foreach my $e ( @exons ) {
    my $test_e = shift @expected_exons;
    my $i = 0;
    is($e->query->start, $test_e->[$i++]);
    is($e->query->end, $test_e->[$i++]);
    is($e->query->strand, $test_e->[$i++]);

    is($e->hit->start, $test_e->[$i++]);
    is($e->hit->end, $test_e->[$i++]);
    is($e->hit->strand, $test_e->[$i++]);
}
ok(! @expected_exons);
foreach my $intron ( @introns ) {
    my $test_i = shift @expected_introns;
    my $i = 0;
    is($intron->start, $test_i->[$i++]);
    is($intron->end, $test_i->[$i++]);
    is($intron->strand, $test_i->[$i++]);
}
ok(! @expected_introns);

$parser = new Bio::Tools::Est2Genome(-file   => Bio::Root::IO->catfile
					('t','data', 'hs_est.est2genome'));

ok($parser);
my $gene = $parser->parse_next_gene(1);
@expected_exons = ( [695,813,1,1,119,1],
		       [1377,1493,1,120,236,1],
		       [1789,1935,1,237,382,1],
		       [2084,2180,1,383,479,1]);
@expected_introns = ( [814,1376,1],
			 [1494,1788,1],
			 [1936,2083,1] );

foreach my $trans($gene->transcripts){
   my @exons = $trans->exons;
   foreach my $e(@exons){
    my $test_e = shift @expected_exons;
    my $i = 0;
    is($e->start, $test_e->[$i++]);
    is($e->end, $test_e->[$i++]);
    is($e->strand, $test_e->[$i++]);
  }
  my @introns = $trans->introns;
  foreach my $intron ( @introns ) {
    my $test_i = shift @expected_introns;
    my $i = 0;
    is($intron->start, $test_i->[$i++]);
    is($intron->end, $test_i->[$i++]);
    is($intron->strand, $test_i->[$i++]);
  }
}

