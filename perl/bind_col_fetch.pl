#!/usr/local/bin/perl -w
use DBI;
use strict;

my $host = 'localhost';
my $user = 'user_db';
my $port = '3306';
my $database='test';

my $dbh = DBI->connect( "DBI:mysql:host=$host;database=$database", $user, "123456s" ) || die "Connection error: ".$DBI::errstr;;
$dbh->do('set @myvariable=10')||die $DBI::errstr;

my ( $customer_id, $customer_name );
my $sql ="SELECT customer_id,customer_name FROM customers WHERE sales_rep_id=1";
my $sth = $dbh->prepare($sql) || die $DBI::errstr;
$sth->execute || die $DBI::errstr;
$sth->bind_col( 1, \$customer_id );
$sth->bind_col( 2, \$customer_name );
while ( $sth->fetch ) {
	print join( "\t", ( $customer_id, $customer_name ) ), "\n";
}








__END__
