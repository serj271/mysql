#!/usr/local/bin/perl -w
use DBI;
use strict;

my $host = 'localhost';
my $user = 'user_db';
my $port = '3306';
my $database='test';

my $dbh = DBI->connect( "DBI:mysql:host=$host;database=$database", $user, "123456s" ) || die "Connection error: ".$DBI::errstr;;
$dbh->do('set @myvariable=10')||die $DBI::errstr;

my $sql = "SELECT customer_id,customer_name FROM customers WHERE sales_rep_id=1";
my $sth = $dbh->prepare($sql) || die $DBI::errstr;
$sth->execute || die $DBI::errstr;
while ( my @row = $sth->fetchrow_array ) {
	print $row[0] ."\t". $row[1] . "\n";
}

$sth->finish;








__END__
