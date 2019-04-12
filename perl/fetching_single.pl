#!/usr/local/bin/perl -w
use DBI;
use strict;

my $host = 'localhost';
my $user = 'user_db';
my $port = '3306';
my $database='test';

my $dbh = DBI->connect( "DBI:mysql:host=$host;database=$database", $user, "123456s" ) || die "Connection error: ".$DBI::errstr;;
#$dbh->do('set @myvariable=10')||die $DBI::errstr;

my $sth = $dbh->prepare('call department_list()') || die $DBI::errstr;
$sth->execute || die $DBI::errstr;
while ( my @row = $sth->fetchrow_array ) {
	print join("\t",@row),"\n";
}
$sth->finish;







__END__
