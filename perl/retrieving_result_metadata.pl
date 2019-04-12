#!/usr/local/bin/perl -w
use DBI;
use strict;

my $host = 'localhost';
my $user = 'user_db';
my $port = '3306';
my $database='test';

my $dbh = DBI->connect( "DBI:mysql:host=$host;database=$database", $user, "123456s" ) || die "Connection error: ".$DBI::errstr;;
$dbh->do('set @myvariable=10')||die $DBI::errstr;

my $sql ="SELECT customer_id,customer_name FROM customers WHERE sales_rep_id=1"; 
my $sth = $dbh->prepare($sql) || die $DBI::errstr;
$sth->execute || die $DBI::errstr;
foreach my $colno ( 0 .. $sth->{NUM_OF_FIELDS} - 1 ) {
	print "Name= ". $sth->{NAME}->[$colno]. "\tType=". $sth->{TYPE}->[$colno] . "\n";
}








__END__
