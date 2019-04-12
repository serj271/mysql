#!/usr/local/bin/perl -w
use DBI;
use strict;

my $host = 'localhost';
my $user = 'user_db';
my $port = '3306';
my $database='test';

my $dbh = DBI->connect( "DBI:mysql:host=$host;database=$database", $user, "123456s" ) || die "Connection error: ".$DBI::errstr;;
#$dbh->do('set @myvariable=10')||die $DBI::errstr;

my $sth = $dbh->prepare('call customer_list(?)') || die $DBI::errstr;
for ( my $sales_rep_id = 1 ; $sales_rep_id < 10 ; $sales_rep_id++ ) {
	print "Customers for sales rep id = " . $sales_rep_id;
	$sth->execute($sales_rep_id) || die $DBI::errstr;
	while ( my @row = $sth->fetchrow_array ) {
		print join( "\t", @row ), "\n";
	}
}
$sth->finish;







__END__
