#!/usr/bin/env perl

use FindBin qw($Bin);
use lib "$Bin/../lib";
use App::Ptyp;
use Tcl::pTk;
my $mw = MainWindow->new;
my $app = App::Ptyp->new(master => $mw);
$app->run;
