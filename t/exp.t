# -*-Perl-*-
# $Id$
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'

use strict;
use vars qw($error $NUMTESTS);
BEGIN {
	$NUMTESTS = 5;
	$error = 0;
	# to handle systems with no installed Test module
	# we include the t dir (where a copy of Test.pm is located)
	# as a fallback
	eval { require Test::More; };
	if ( $@ ) {
		use lib 't/lib';
	}
	# SeqIO modules abi.pm, ctf.pm, exp.pm, pln.pm, ztr.pm
	# all require Bio::SeqIO::staden::read, part of bioperl-ext

	use Test::More;
	plan tests => $NUMTESTS;
	use_ok('Bio::SeqIO::exp');
	use_ok('Bio::Root::IO');
}

SKIP: {
	eval {
		require Bio::SeqIO::staden::read;
	};
	if ( $@ ) {
		$error = 1;
		skip("Bio::SeqIO::staden::read of bioperl-ext is not installed or is installed incorrectly - skipping exp.t tests", 3);
	}
	ok(1);

	my $verbose = $ENV{'BIOPERLDEBUG'};

	my $io = Bio::SeqIO->new(-format => 'exp',
				 -verbose => $verbose,
				 -file => Bio::Root::IO->catfile
				 (qw(t data readtest.exp) ));
	ok(my $seq = $io->next_seq);
	is($seq->seq, "GATGATTCCGGCTTCGGACGACTCTAGAGGATCCCCATTTTTATAGTTTTTATCTTGTAATAGATGTTTAGATTTTTCGTTGTAATTATTTTCTTTATTGTTGAAATTAGTATCTCTGGGTAATTTATCATATTCTCTGGAAAATGATTTACTATCACTAGATACTTCATAAGATTTATAATCTTTATTATGAAAATCATCTCTATTTTTCAAATTATTATTATATCTATCAAAGTTTCTGTCTTCATTATATCTATTAGCATATCTATCTTTATCTTTATCCCTATCACTATATCTATCATATGGTTCATCTTGTTCAACCGATCAGACTCGATTCGCCATCGCCTCTAACGGATGGCCGCTCCCCCTCTCATACCTCGCTCCCCTCGACATCCCCCGTCTCGCCACCCTATCCGCCCCCTTCATCACCCCCCCTTATCCACACCCTCACCCCCCGCATCGCGCACCCACGACCACCCGAAGAACCGCCCTTACTCCCAAGTACGCCCCGACCTCCATCACCCTATGCGGTACCACTCCCACCACACCCAGTCCTACTTTCGCCCGCACATCGGCCCCGCTTCAGACAGCTCCCAACTACGCAACCCACGCTTGTTCTTGTTCACACTCGAATACTCGAATCTCTCATTACTCCGCGGACTCCGCCGCACCTGTGCACCATTAACTGTGTAGCGCCTGAACCGGCACCTCTGATTACCACTTCCTCCACCAGCACAGTCCTATTACCGCATGTCGCTCTGCTAAGACAGTGCAAGACTCTGCGGTCGCTCTGACCCGCATCCGCCAGGGCACCTCTCACCCTCGCTGGCCACCCCGCCCCCCTCTCCCTGCCCCTTCATTCCCCCAAACCGCTTTCAACGGGACACACCCCTCCGCGGCGGACCACAACTCGCCGTCGGCCACCACTCACACCTTCCCTCCTCCTTCCCCCACATCACGCCAACCCCGTGGGACGGCTCTCCCGCGGCTACGACGCGCAACCCCCCCTCGCCGCTTCCCCCCCAACTTCCCACGGGCTCCCCTCCGCCCCTTACCCGCGAGGAGCTTCACCCGCGAACCACCTCCCCCCTTTCCCAACAGCACCG");
}

1;
