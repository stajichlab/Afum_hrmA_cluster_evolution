#!/usr/bin/env perl
use strict;
use warnings;

# run summarize_results.sh first
my $sum = 'hrmA_search_results.txt';

open(my $fh => $sum) || die $!;
my %n;
my %names;
my $cutoff_pid = 90; # 90% cutoff for cgnA hits

sub has_hit_greater {
    my ($cutoff,$nums) = @_;
    my $rc = 0;
    for my $n ( @{$nums || []} ) {
	if ( $n >= $cutoff ) {
	    return 1;
	}
    }
    return 0;
}

while(<$fh>) {
    chomp;
    next if /^\/\//;
# gather strain info from summarize table results
    my ($q,$h,$pid,@row) = split;
    $names{$q}++;
    if ( $h =~  /(\S+)\.(scf|scaffold\S+)/ ||
	 $h =~  /(\S+)_gbk\.(\S+)/ ) {
	my ($hit_strain,$hit_ctg) = ($1,$2);    
	push @{$n{$hit_strain}->{$q}}, $pid;
    }
}
my @names = sort keys %names;
print join("\t", qw(STRAIN),map { $_, sprintf("%s-like",$_) } @names),"\n";
# now print out
for my $strain ( keys %n ) {
    
    my @row;
    
    for my $gene ( @names ) {
	my @ordered = sort { $b <=> $a } @{$n{$strain}->{$gene} || []}; 
	
	if ( &has_hit_greater($cutoff_pid, \@ordered) ) {
	    push @row, (1, ( @ordered > 1 ) ? 1 : 0);
	} else {
	    # if no good hit, does it have -like hits
	    push @row, (0, (@ordered > 0) ? 1 : 0);
	}
    }
    print join("\t", $strain, @row),"\n";     
}
