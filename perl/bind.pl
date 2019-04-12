#!/usr/local/bin/perl -w
use DBI;
use strict;

my $host = 'localhost';
my $user = 'user_db';
my $port = '3306';
my $database='test';

my $dbh = DBI->connect( "DBI:mysql:host=$host;database=$database", $user, "123456s" ) || die "Connection error: ".$DBI::errstr;;
$dbh->do('set @myvariable=10')||die $DBI::errstr;

my $sth=$dbh->prepare('INSERT INTO t4(id,value) VALUES(?,?)')
||die $DBI::errstr;
for (my $i=1; $i<=10;$i++) {
$sth->bind_param(1,$i);
$sth->bind_param(2,'Row# '||$i);
$sth->execute||die $DBI::errstr;
}
$sth->finish;








__END__
