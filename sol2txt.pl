#!/bin/perl

use v5.16;
use warnings;
no warnings qw(uninitialized);
use utf8;

my %puzzles = (
	PB000  => [ 50, 'TWN1'],
	PB001  => [ 50, 'TWN2'],
	PB037  => [ 50, 'TWN3'],
	PB002  => [ 50, 'TWN4'],
	PB003B => [ 50, 'PIZZA'],
	PB004  => [ 50, 'M1'],
	PB005  => [ 50, 'SNAXNET1'],
	PB006B => [ 50, 'ZEBROS'],
	PB007  => [ 50, 'HIGHWAY'],
	PB008  => [ 50, 'UN1'],
	PB009  => [ 75, 'UCB'],
	PB010B => [ 75, 'WORKHOUSE'],
	PB012  => [ 50, 'BANK1'],
	PB011B => [ 50, 'M2'],
	PB013C => [ 50, 'TWN5'],
	PB015  => [ 50, 'REDSHIFT'],
	PB016  => [ 75, 'LIBRARY'],
	PB040  => [100, 'MODEM1'],
	PB018  => [ 75, 'EMERSONS'],
	PB038  => [ 75, 'M3'],
	PB020  => [100, 'SAWAYAMA'],
	PB021  => [ 75, 'APL'],
	PB023  => [100, 'XLB'],
	PB024  => [100, 'KRO'],
	PB028  => [100, 'KGOG'],
	PB025  => [ 75, 'BANK2'],
	PB026B => [100, 'MODEM2'],
	PB029B => [100, 'SNAXNET2'],
	PB030  => [ 75, 'M4'],
	PB032  => [150, 'HOLMAN'],
	PB033  => [150, 'USGov'],
	PB034  => [ 75, 'UN2'],
	PB035B => [100, 'MODEM3'],
	PB036  => [150, 'M5'],

	PB054  => [150, 'BLOODLUST'],
	PB053  => [100, 'MVA'],
	PB050  => [150, 'CYBERMYTH'],
	PB056  => [150, 'USDoD'],
	PB051  => [150, 'MODEM4'],
	PB057  => [150, 'SCHOOL'],
	PB052  => [150, 'x10x10x'],
	PB055  => [150, 'AIRPLANES'],
	PB058  => [100, 'MOSS'],
);

my @MODE = qw(GLOBAL LOCAL);

sub slurp {
	open my $fh, '<', $_[0];
	local $/;
	binmode $fh;
	<$fh>;
}

for my $filename (@ARGV) {
	$_ = slurp($filename);
	s/\cK.\cA\0\0//g;

	my ($head, $puzzle, $solname, $wins, $sandbox, $solved, $cycles, $size, $activity, @exas);

	$head = unpack 'L';

	if ($head == 1006) {
		($puzzle, $solname, $solved, $cycles, $size, $activity, @exas) =
		unpack 'x4L/aL/a(Lx4)4X32L/(x8)x4(xL/aL/axCx100)*';
	}
	elsif ($head == 1007 || $head == 1008) {
		($puzzle, $solname, $wins, $sandbox, $solved, $cycles, $size, $activity, @exas) =
		unpack 'x4L/aL/aLL(Lx4)4X32L/(x8)x4(xL/aL/axCx100)*';
	}
	else {
		die "Unknown version code: $head";
	}

	my ($size_limit, $puzzle_name) = @{$puzzles{$puzzle}};

	# Unsolved, hacker battles, oversize, redshift, workshop
	next if $solved != 3 || $wins || $size > $size_limit || $sandbox || $puzzle !~ /^P/;

	my $out = join "\n============\n", map "$MODE[$exas[3*$_+2]]\n$exas[3*$_+1]", 0..($#exas / 3);
	my $out_file = "$puzzle_name/$cycles|$size|$activity";
	say $out;
	say "Save as $out_file? (y/n)";
	if (<STDIN> =~ /^y/i) {
		open my $fh, '>', $out_file;
		print $fh $out;
	}
}
