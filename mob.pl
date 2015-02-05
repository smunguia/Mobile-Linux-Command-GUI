#!/usr/bin/perl


use Term::ANSIColor; 
use feature "switch";
#require Term::Screen::Uni;

#use strict;
#use warnings;

my $srv="/sbin/service";
open CMDS, "cmds.txt" or die $!;
while(<CMDS>){
	($name,$cmd) = split(",","$_");
	push(@pgd,$name);
	push(@pgc,$cmd);
}

sub cmd{
	my $inp,my $pgd,my $cmd, my $read;
	($inp,$pgd,$cmd) = @_;
	print "Are you sure you want me to:\n";
	print $pgd[$inp - 1] . "\n";
	print "Answer[y/n]?";
	$read = <>;
	chomp($read);
	if($read eq "y"){
		print "Command Run: " . $pgc[$inp - 1] . "\n";
		my $output = system("$pgc[$inp - 1]");
		print $output;
		$read = <>;
	}else{
		print "You didn't want me to run it so canceling command!\n";	
		$read = <>;
	}	
}

sub user{
	my $in, my $p, my $pgd, my $pgc, my $ret;
	($in,$p,$pgd,$pgc) = @_;
	given($in) {
		when (/^p/){
    			$ret = $p - 1;      
    			break;
			}
  		when (/^n/){
			$ret = $p + 1;
			break;
			}
  		when (/^e/){
			$ret = null;
			break;
			}
		when (/^[1-9]/){
			cmd($in,$pgd,$pgc);
			$ret = $p;
			break;
			}
		default{
				print "Not sure what you want me to do!!!\n";
				$ret = null;
			}
	}
	return $ret;
}


sub page{
	#my $scr = new Term::Screen::Uni;
	# $scr->clrscr();
	my $clear_str = `clear`;
	my $p1, my $p2, my $p, my $out, my $n;
	($p1,$p2) = @_;
	$p = 1;
	$n = 14;
	$out = "empty";
	while ("$out" ne "e") {
		print $clear_str;
		$s = ($p - 1) * $n;
		if( "$p" != '1'){ $s++; }
		print colored ['yellow'], "==================================================", "\n";
		print colored ['yellow'], "		CMD MENU"			      , "\n";
		print colored ['yellow'], "==================================================", "\n";
		for(my $i=$s;$i<=($s+$n);$i++){
			my $id = $i + 1;
			my $item = $pgd[$i];
			if( ($i%2) != 0){
				print colored ["yellow"], "\t$id.\t$item", "\n";
			}else{
				print colored ["white"], "\t$id.\t$item", "\n";
			}
		}
		print "\n";
		print colored ["red"], "\tn.\tNext Page", "\n";
		print colored ["red"], "\tp.\tPrevious Page", "\n";
		print colored ["red"], "\te.\tExit/Quit", "\n";
		print "\n";
		print colored ["cyan"], "\tAnswer[1-40,n,p,e]:", "";
		$out = <>;
		chomp($out);
		$p = user($out,$p,$p1,$p2);
	}	
}


page(\@pgd,\@pgc);
