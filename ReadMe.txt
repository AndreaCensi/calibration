Package contents
----------------

An up-to-date version of this package can be found at the website

  http://purl.org/censi/2011/calibration


The following is an overview of the contents:

src/:

    This directory contains the C++ source files for implementing the method.

    The main executables created are:
    * synchronizer: Synchronizes laser data and odometry to obtain
                    the tuple files.
    * solver:Given the tuple files, solves for the calibration parameters
    
scripts/:

    This directory contains the data files and the scripts for running 
    the experiments and visualizing the data.

    scripts/run_all.sh:  Runs the calibration procedure.
    scripts/script_variables.sh: This file contains the environment variables,
        executable paths, and parameters common to all the scripts. 

data/:

    This directory contains the raw data logs. The raw logs are called
    "lstraight", "l90", "lmov" (corresponding to the configurations A,B,C 
    in the paper). 
    
    Inside each .tar.gz, there are multiple experiments. This is raw data,
    so the odometry and laser data are separated in multiple files 
    (see ).


reference-output/:

    This directory contains the output of the synchronization
    procedure and the results of calibration, as well as the 
    intermediate results (in case one is not able to run the
    scan matching software).
    
    The intermediate result of the method is the creation of
    "tuple files": the odometry and scan matching data is integrated
    to obtain a series of tuples, each containing average wheel 
    velocities and scan matching result for the interval.
    
    For each configuration X:
        "X.tuple"        are the complete tuples
        "X_i.tuple"      are the tuples for the i-th subset
        "X_results.json" are the calibration results in JSON
        "X_results.m"    ... and in Matlab format


Installation instructions
-------------------------

The installation process has been tried on Mac OS X (10.5-10.6) and various versions of Ubuntu. With perhaps a few modifications, the software should run on all flavors of Unix.

The first step is installing CSM. Please see the instructions at the website http://purl.org/censi/2007/csm.

The minimal steps are as follows:

    $ git clone git://github.com/AndreaCensi/csm.git
    $ cd csm
    $ cmake .
    $ make 
    $ make install
    
Remember to point PKG_CONFIG_PATH where you installed CSM. In the default case, this is /usr/local:

    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/:$PKG_CONFIG_PATH
    
Compiling the calibration software does not require more dependencies than CSM itself (e.g., GSL). 

The installation is simple:

    $ cd src/
    $ cmake .
    $ make install
     

Execution instructions
----------------------

In the directory "scripts/" there is a file "run_all.sh" that does the complete calibration process from the logged data.

    $ cd logs/
    $ ./run_all.sh
    
Note that it might take some time. It is normal to see a few scan matching
errors displayed; that is just bad data (synchronization issues between
odometry and laser.)


Data formats
------------

These are a few notes about the data formats used.


*Tuples files* are in the JSON format. The field ``T`` is the interval; the fields ``phi_r`` and ``phi_r`` are the average wheel velocities, and ``sm`` is the scan matching estimate.

    
    
