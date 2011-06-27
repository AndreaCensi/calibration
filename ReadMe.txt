Supplemental material for "Simultaneous calibration of odometry and sensor parameters for mobile robots"
==========================================================================

This archive contains C++ source code for the calibration method described 
in the paper, plus the raw data and scripts to reproduce the experiments,
in the spirit of [reproducible research](http://reproducibleresearch.net/).

Please contact Andrea Censi (andrea at cds.caltech.edu) for any concern 
regarding installation and usage of this package.

An up-to-date version of this package can be found at the website:

 <http://purl.org/censi/2011/calibration>
  


Package contents
---------------------------------------------------------------------------

The following is an overview of the contents.

### Directory ``src/``

This directory contains the C++ source files for implementing the method.

The main executables created are:

* ``synchronizer``: Synchronizes laser data and odometry to obtain
  the tuple files (input to the algorithm).
  
* ``solver``: Given the tuple files, solves for the calibration parameters.
  This is the "meat" of the method.



### Directory ``scripts/``

This directory contains the data files and the scripts for running 
the experiments and visualizing the data. 

The main scripts are:

* ``scripts/run_all.sh``:  Runs the complete calibration procedure.
* ``scripts/script_variables.sh``: This file contains the
  environment variables, executable paths, and parameters common 
  to all the scripts. 

### Directory ``data/``

This directory contains the raw data logs. The raw logs are called
``lstraight``, ``l90``, ``lmov``; these correspond to the configurations 
A,B,C  in the paper. 

Inside each ``.tar.gz``, there are multiple experiments. See below for
a description of the data format.


### Directory ``reference-output/``

This directory contains the output of the synchronization
procedure and the results of calibration, as well as the 
intermediate results (in case one is not able to run the
scan matching software).

The intermediate result of the method is the creation of
"tuple files": the odometry and scan matching data is integrated
to obtain a series of tuples, each containing average wheel 
velocities and scan matching result for the interval.

For each configuration X:

* ``X.tuple``        are the complete tuples
* ``X_i.tuple``      are the tuples for the i-th subset
* ``X_results.json`` are the calibration results in JSON
* ``X_results.m``    ... and in Matlab format


Installation instructions
---------------------------------------------------------------------------

The installation process has been tried on Mac OS X (10.5-10.6) and various versions of Ubuntu. With perhaps a few modifications, the software should run on all flavors of Unix.

The first step is installing CSM. Please see the instructions at the website <http://purl.org/censi/2007/csm>.

The minimal steps are as follows:

    $ git clone git://github.com/AndreaCensi/csm.git
    $ cd csm
    $ cmake .
    $ make 
    $ make install
    
Remember to point ``PKG_CONFIG_PATH`` where you installed CSM. In the default case, this is ``/usr/local``:

    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/:$PKG_CONFIG_PATH
    
Compiling the calibration software does not require more dependencies than CSM itself (e.g., GSL). 

The installation is simple:

    $ cd src/
    $ cmake .
    $ make install
     

Execution instructions
---------------------------------------------------------------------------

In the directory ``scripts/`` there is a file ``run_all.sh`` that does the complete calibration process from the logged data.

    $ cd logs/
    $ ./run_all.sh
    
Note that it might take some time. It is normal to see a few scan matching
errors displayed; that is just bad data (synchronization issues between
odometry and laser.)

The script ``create_tuples.sh`` is called by ``run_all.sh`` and is the 
one responsible for processing the data with the scan matcher and running
the synchronization between scan matching and odometry. It creates 
"tuple files" which correspond to a series of what in the paper are called
"samples". Basically, the tuples correspond to the input of the algorithm.

Note that the ``reference-output/`` directory contains the generated tuple
files, so that the results can be reproduced even if the scan matcher
cannot be installed. 


Data formats
---------------------------------------------------------------------------

These are a few notes about the data formats used.

All logs and intermediate results are in the JSON format. See the website
<http://www.json.org/> for more information (including libraries for reading
the format easily for many different languages).

### Raw log files format

The raw log files have this format:

    {  "timestamp": [949, 943101], 
       "readings": [ ...],  
       "theta": [ ... ], 
       "right": 0, 
       "left": 0, 
       "leftTimestamp": [ 949, 940807], 
       "rightTimestamp": [ 949, 942685] }

where:

* ``readings`` is the array of range-finder readings.
* ``theta`` is the direction of each reading.
* ``left`` and ``right`` are the encoder readings, in ticks.
* ``timestamp`` is a two-shorts UNIX timestamp of when the laser data was taken; 
* ``leftTimestamp``, ``rightTimestamp`` are the timestamps for when the 
  the encoder data was taken.

(there are also other fields, not relevant for calibration)


### Tuples files format 

The *tuples files* are the result of running scan matching, and synchronization of scan matching and odometry data.  

The field ``T`` is the interval; the fields ``phi_r`` and ``phi_r`` are the average wheel velocities, and ``sm`` is the scan matching estimate.

    








<!-- Ignore this, it makes the HTML look nice -->
<style>
body { font-family: Georgia, Verdana, sans-serif;}
body { padding-left: 2em;}
body p, body ul { max-width: 35em;}
pre { margin-left: 2em; background-color: #bbf; border: solid 1px black;
	padding: 10px;}
	
code { padding: 3px; color: #008; font-size: 70%;}
/*pre code { background-color: #bbf;}
code { background-color: #ddf; }*/
p, pre { max-width: 40em; }

pre code { font-weight: normal; }
code { font-weight: bold; }

h1 { }
h2 { 
	
	
	border-bottom: solid 2px #b00; 
	margin-top: 2em;
	max-width: 35em;
	padding: 0.1em; margin-left: -1em;}
	
h3 { border-bottom: solid 2px #00b; 
    	max-width: 35em;}
</style>
