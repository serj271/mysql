#!/usr/local/bin/perl -w
use DBI;
use strict;

my $host = 'localhost';
my $user = 'user_db';
my $port = '3306';
my $database='test';
sub execute_procedure($$);

my $dbh = DBI->connect( "DBI:mysql:host=$host;database=$database", $user, "123456s" ) || die "Connection error: ".$DBI::errstr;; 
#my $sth = $dbh->prepare("CALL sp_rep_report(?)") || die $DBI::errstr;
my $sales_rep_id = 1;


execute_procedure($dbh, "CALL sp_rep_report(1)");




sub execute_procedure($$) {
	my ( $dbh, $stored_procedure_call ) = @_;
	my $sth = $dbh->prepare($stored_procedure_call)	|| die $DBI::err . ": " . $DBI::errstr;
	$sth->execute || die DBI::err . ": " . $DBI::errstr;
	my $result_set_no = 0;

	do {
		if ($sth->{NUM_OF_FIELDS}){
			print "\n", ( '=' x 20 ) . " Result Set # ",
			++$result_set_no . ( '=' x 20 ), "\n\n";

			print join( "\t", @{ $sth->{NAME} } ),"\n", ( '-' x 54 ), "\n";

			while ( my @row = $sth->fetchrow_array( ) ) {

				print join( "\t", @row ), "\n";
			}
		}
	}until ( !$sth->more_results );
	$sth->finish;
	
}


__END__
