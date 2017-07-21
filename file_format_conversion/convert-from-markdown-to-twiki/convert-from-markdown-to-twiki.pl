#!/usr/bin/env perl
#!/Users/meng/perl5/perlbrew/perls/perl-5.22.1/bin/perl

######################################################################
#+ Summary: Convert Markdown file to TWiki.
#+ Author: Meng LU <lumeng.dev@gmail.com>
#+ (Adapted from https://metacpan.org/pod/Markdown::Foswiki)
#+
#+ ## Installation
#+ * Install perlbrew. Then install a Perl installation at $HOME that
#+ is separate from OS's system Perl, e.g. OS X's /usr/bin/perl.
#+ See note <https://meng6.net/pages/computing/installing_and_configuring/installing_and_configuring_Perl>
#+ 
#+ * In that Perlbrew's perl environment:
#+
#+ Install the newest stable version of Perl: 
#+
#+     perlbrew install perl X.Y.Z
#+     perlbrew use X.Y.Z
#+
#+ Install the required Perl modules
#+
#+     cpanm Markdown::Foswiki
#+     cpanm experimental
#+
#+ ## Usage:
#+
#+    Optionally turn on perlbrew's version of perl:
#+
#+       perlbrew available
#+       perlbrew use perl-5.22.1
#+
#+    Convert:
#+
#+       convert-from-markdown-to-twiki.pl myfile.md
##

use strict;
use warnings;
use experimental 'switch';
#no if ($] >= 5.018), 'warnings' => 'experimental';

## Turn on to print variables for debugging.
#use Data::Dumper qw(Dumper);

#######################################################################
# Quit unless we have the correct number of command-line args

my $num_args = $#ARGV + 1;

## debug
#print Dumper \@ARGV;

if ($num_args != 1) {
    print "\nUsage: $ARGV[0] file.md\n";
    exit;
}

my $md_file=$ARGV[0];
#print Dumper $md_file;

######################################################################
#+ Convert Markdown file to TWiki text and save it to file with
#+ extension .twiki.
#+
#+
##

use Markdown::Foswiki;

my $mc = Markdown::Foswiki->new();

my @md_lines = $mc->getData( $md_file );

my $fw_text = $mc->process(@md_lines);

## debug
#print $fw_text;

$mc->save ( $fw_text, '', $md_file . '.twiki');

## END
