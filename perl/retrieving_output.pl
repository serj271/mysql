#!/usr/local/bin/perl -w
use DBI;
use strict;

my $host = 'localhost';
my $user = 'user_db';
my $port = '3306';
my $database='test';

my $dbh = DBI->connect( "DBI:mysql:host=$host;database=$database", $user, "123456s" )
|| die "Connection error: ".$DBI::errstr;; 
my $sql = 'call sp_rep_customer_count(1,@customer_count)'; #watch out for the "@"! e.g., SELECT \@user_var
my $sth = $dbh->prepare($sql);
$sth->execute( ) || die $DBI::errstr;
$sth->finish;

my @result = $dbh->selectrow_array('SELECT @customer_count') || die $DBI::errstr;
print "customer_count=", $result[0], "\n";








__END__
