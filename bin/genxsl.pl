#!/usr/bin/perl -w
#
# This is a script coded for generate beautiful excel report document
# from bugzilla databse. The test version is bugzilla 3.0rc1.
#
# Author: fog.hua@gmail.com, Sun Mar 18 20:08:08 2007
#
# Help Document for excel module:
# - http://search.cpan.org/src/JMCNAMARA/Spreadsheet-WriteExcel-2.18/doc/WriteExcel.html
# - http://search.cpan.org/~dankogai/Encode-2.18/Encode.pm
#
# Usage:
#   
#   genxsl.pl <product name>
#
#
# Design:
#
#   NO,Status,Version,Severity,Description,Owner,Deadline
#
#   Closed:               silver
#   Open + Major:         yellow
#
#
#
# ChangeLog:
#  
#       * Sun Mar 18 23:33:15 2007 - R0003
#
#               - Add almost all func except autofilter which not
#                 supported by WriteExcel module.
#
#
#       * Sun Mar 18 23:33:15 2007
#
#               - Recode the script, make it more easy for extend
#
#       * Sun Mar 18 20:03:19 2007
#
#               - Add parameter for product
#
#	* Sun Mar 18 19:15:42 2007 - R0002
#
#		- Change severity to upper case
#		- Change valign to top
#		- Add freeze panes on header
#
# TODO:
#	
#	- Optimize the code
#	- Add support for chinese
#

use strict;
use DBI;
use Spreadsheet::WriteExcel;
use POSIX; # for strftime using
#use Encode;

my %h_status_op = (
    "NEW" => "OPEN",
    "ASSIGNED" => "OPEN",
    "REOPENED" => "OPEN",
    "RESOLVED" => "CLOSE",
    "VERIFIED" => "CLOSE",
    "CLOSED" => "CLOSE",
    "FIXED" => "CLOSE",
    "INVALID" => "CLOSE",
    "WONTFIX" => "CLOSE",
    "WORKSFORME" => "CLOSE",
    );

my %h_status_cl = (
    "NEW" => "white",
    "ASSIGNED" => "white",
    "REOPENED" => "white",
    "RESOLVED" => "silver",
    "VERIFIED" => "silver",
    "CLOSED" => "silver",
    );

my %h_resolution_cl = (
    "FIXED" => "silver",
    "INVALID" => "silver",
    "WONTFIX" => "silver",
    "WORKSFORME" => "silver",
    );

my %h_severity_cl = (
    "BLOCKER" => "yellow",
    "CRITICAL" => "yellow",
    "MAJOR" => "yellow",
    "NORMAL" => 'white',
    "MINOR" => "white",
    "TRIVIAL" => "white",
    "ENHANCEMENT" => "white",    
    );

my $product_name = shift @ARGV;

my $dbh = DBI->connect('DBI:mysql:bugs3','bugs3','16131613')
    or die "Can't connect to the database:" . DBI->errstr;

my $sth = $dbh->prepare('select id from products where name=?');
$sth->execute($product_name);

my @data = $sth->fetchrow_array();
my $product_id = $data[0];

if($product_id) {
#    print "Product id: $product_id\n";
    $sth = $dbh->prepare('select bug_id,bug_status,version,bug_severity,assigned_to
                          from bugs where product_id=?')
        or die $dbh->errstr;
    $sth->execute($product_id);
}
else {
#    print "No product id, all products will be reported\n";
    $product_name = "All";
    $sth = $dbh->prepare('select bug_id,bug_status,version,bug_severity,assigned_to
                          from bugs')
        or die $dbh->errstr;
    $sth->execute();
}

my $fname = "${product_name}_" . strftime("%Y%m%d%H%M", gmtime(time()+8*3600)) . ".xls";
my $workbook = Spreadsheet::WriteExcel->new($fname);
my $worksheet = $workbook->addworksheet();

my %h_mheading = (
    font => 'Lucida Console',
    size => 8,
    border => 2,
    pattern => 1,
    align => 'left',
    valign => 'vcenter',
    bold => 1,
    bg_color => 'white',
    color => 'red',
    );

my %h_heading = (
    font => 'Lucida Console',
    size => 8,
    border => 2,
    pattern => 1,
    align => 'center',
    valign => 'vcenter',
    bold => 1,
    bg_color => 'black',
    color => 'white',
    );

my %h_common = (
    font => 'Lucida Console',
    size => 8,
    border => 2,
    align => 'center',
    valign => 'top',
    bg_color => 'white',
    );

my %h_description = (
    font => 'Lucida Console',
    size => 8,
    border => 2,
    text_wrap => 1,
    align => 'left',
    valign => 'top',
    bg_color => 'white',
    );

my $fmt_mheading = $workbook->add_format(%h_mheading);
my $fmt_heading = $workbook->add_format(%h_heading);
my $fmt_common = $workbook->add_format(%h_common);
my $fmt_description = $workbook->add_format(%h_description);

my $row = 0;
my $col = 0;

#$worksheet->protect();
$worksheet->freeze_panes(2, 0); # freeze the first row

# set column length
$worksheet->set_column(0, 0, 6);
$worksheet->set_column(1, 1, 12);
$worksheet->set_column(2, 2, 16);
$worksheet->set_column(3, 3, 16);
$worksheet->set_column(4, 4, 72);
$worksheet->set_column(5, 5, 32);


$worksheet->set_row($row, 32, $fmt_heading);
$worksheet->merge_range('A1:B1', 
                        "F/W: $product_name", 
                        $fmt_mheading);
$worksheet->merge_range('C1:D1', 
                        '="Open issue: "&SUM(COUNTIF(B3:B113,"NEW"),COUNTIF(B3:B113,"ASSIGNED"),COUNTIF(B3:B113,"REOPENED"))', 
                        $fmt_mheading);
$worksheet->merge_range('E1:F1', 
                        '="Closed issue: "&SUM(COUNTIF(B3:B113,"RESOLVED"),COUNTIF(B3:B113,"VERIFIED"),COUNTIF(B3:B113,"CLOSED"))', 
                        $fmt_mheading);


$row++;
$worksheet->set_row($row, 16, $fmt_heading);

$worksheet->write($row, 0, "NO");
$worksheet->write($row, 1, "Status");
$worksheet->write($row, 2, "Version");
$worksheet->write($row, 3, "Severity");
$worksheet->write($row, 4, "Description");
$worksheet->write($row, 5, "Owner");

#print "Generating excel document ...\n";

$row++;

while(@data = $sth->fetchrow_array()) {

    # get user name
    my $sth1 = $dbh->prepare('select login_name from profiles where userid = ?');
    $sth1->execute($data[4]);
    my @data1 = $sth1->fetchrow_array();
    my $username = $data1[0];

    # we need just the first record which include the initial comment
    my $sth2 = $dbh->prepare('select thetext from longdescs where bug_id = ?');
    $sth2->execute($data[0]);
    my @data2 = $sth2->fetchrow_array();
    my $desp = $data2[0];
	
    # just get the overview description
    if($desp =~ m{- Overview Description:\n*(.*)\n- Steps to Reproduce:}s) {
	$desp = $1;
    }
    # $desp =~ s/\n//g; 

    # count the newline count
    my @desp_nl;
    my $desp_nl_cnt = 0;

    if($desp) {
        @desp_nl = $desp =~ m{\n}gi;
        $desp_nl_cnt = scalar(@desp_nl);
    }
    # print "$desp_nl_cnt \n";

    # change severity to uppercase
    $data[3] =~ tr/a-z/A-Z/;

    if($desp_nl_cnt < 5) {
        $worksheet->set_row($row, 64);
    }

    my ($fmt1,$fmt2);

    if($h_status_op{$data[1]} eq "CLOSE") {
        $fmt1 = $workbook->add_format(%h_common, 
                                     bg_color => $h_status_cl{$data[1]});
        
        $fmt2 = $workbook->add_format(%h_description, 
                                     bg_color => $h_status_cl{$data[1]});
        
    }
    else {
        $fmt1 = $workbook->add_format(%h_common, 
                                     bg_color => $h_severity_cl{$data[3]});
        $fmt2 = $workbook->add_format(%h_description, 
                                     bg_color => $h_severity_cl{$data[3]});
    }

    for ($col = 0; $col < 4; $col++) {
        $worksheet->write_string($row, $col, $data[$col], $fmt1);
    }

    $worksheet->write($row, $col++, $desp, $fmt2);
    $worksheet->write($row, $col++, $username, $fmt1);

    $row++;
}

$workbook->close();

$dbh->disconnect;

print $fname;

exit;
