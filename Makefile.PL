#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME' => 'supercron',
    'VERSION_FROM' => 'bin/supercron',
    'PREREQ_PM' => {
        'Getopt::Long'           => '0',
        'Pod::Usage'             => '0',
        'XML::RPC'               => '0',
        'Time::Piece'            => '0',
        'Time::Local'            => '0',
        'Try::Tiny'              => '0',
        'Schedule::Cron::Events' => '0',
        'Data::Dumper'           => '0',
        'File::Spec'             => '0',
        'Cwd'                    => '0',
    },
    'EXE_FILES' => [
        'bin/supercron',
    ],
);
