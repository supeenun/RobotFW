# Pabot

[![Build Status](https://travis-ci.org/mkorpela/pabot.svg?branch=master)](https://travis-ci.org/mkorpela/pabot)
[![Downloads](http://pepy.tech/badge/robotframework-pabot)](http://pepy.tech/project/robotframework-pabot)
[![Version](https://img.shields.io/pypi/v/robotframework-pabot.svg)](https://pypi.python.org/pypi/robotframework-pabot)

A parallel executor for [Robot Framework](http://www.robotframework.org) tests. With Pabot you can split one execution into multiple and save test execution time.

[![Pabot presentation at robocon.io 2018](http://img.youtube.com/vi/i0RV6SJSIn8/0.jpg)](https://youtu.be/i0RV6SJSIn8 "Pabot presentation at robocon.io 2018")

*My goal in creating this tool is to help you guys with big test sets. I've worked with a number of teams around the world that were doing test execution time optimisation before I created this tool. 
I saw similarities in how Robot Framework testing systems have been built and came up with a quite good solution for the basic parallelisation problem. I hope this tool brings you joy and speeds up your test execution! If you are interested in professional support, please contact me through email firstname.lastname(at)gmail.com!* - Mikko Korpela ( those are my firstname and lastname :D )

## Installation:

From PyPi:

     pip install -U robotframework-pabot

OR clone this repository and run:

     setup.py  install

## Things you should know

   - Pabot will split test execution from suite files and not from individual test level.
   - In general case you can't count on tests that haven't designed to be executed parallely to work out of the box when executing parallely. For example if the tests manipulate or use the same data, you might get yourself in trouble (one test suite logs in to the system while another logs the same session out etc.). PabotLib can help you solve these problems of concurrency. Also see [TRICKS](./TRICKS.md) for helpful tips.

## Contributing to the project

There are several ways you can help in improving this tool:

   - Report an issue or an improvement idea to the [issue tracker](https://github.com/mkorpela/pabot/issues)
   - Contribute by programming and making a pull request (easiest way is to work on an issue from the issue tracker)
   - You can buy me a cup of coffee :coffee: if you find this project useful. Send [ether](https://ethereum.org/) to address [0x721135918214c477ee8a7f5c8323c17aa965cc98](https://etherscan.io/address/0x721135918214c477ee8a7f5c8323c17aa965cc98) OR old money with [PayPal](https://paypal.me/mikkorpela)

## Command-line options

Supports all Robot Framework command line options and also following options (these must be before normal RF options):

--verbose     
  more output from the parallel execution

--command [ACTUAL COMMANDS TO START ROBOT EXECUTOR] --end-command    
  RF script for situations where pybot is not used directly

--processes   [NUMBER OF PROCESSES]          
  How many parallel executors to use (default max of 2 and cpu count)

--pabotlib          
  Start PabotLib remote server. This enables locking and resource distribution between parallel test executions.

--pabotlibhost   [HOSTNAME]          
  Host name of the PabotLib remote server (default is 127.0.0.1)
  If used with --pabotlib option, will change the host listen address of the created remote server (see https://github.com/robotframework/PythonRemoteServer)
  If used without the --pabotlib option, will connect to already running instance of the PabotLib remote server in the given host. The remote server can be also started and executed separately from pabot instances:
  
      python -m pabot.PabotLib <path_to_resourcefile> <host> <port>
      python -m pabot.PabotLib resource.txt 192.168.1.123 8271
  
  This enables sharing a resource with multiple Robot Framework instances.

--pabotlibport   [PORT]          
  Port number of the PabotLib remote server (default is 8270)
  See --pabotlibhost for more information

--resourcefile   [FILEPATH]          
  Indicator for a file that can contain shared variables for distributing resources. This needs to be used together with pabotlib option. Resource file syntax is same as Windows ini files. Where a section is a shared set of variables.

--argumentfile[INTEGER]   [FILEPATH]          
  Run same suites with multiple [argumentfile](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#argument-files) options.
  For example:

     --argumentfile1 arg1.txt --argumentfile2 arg2.txt

--suitesfrom   [FILEPATH TO OUTPUTXML]          
  Optionally read suites from output.xml file. Failed suites will run
  first and longer running ones will be executed before shorter ones.

Example usages:

     pabot test_directory
     pabot --exclude FOO directory_to_tests
     pabot --command java -jar robotframework.jar --end-command --include SMOKE tests
     pabot --processes 10 tests
     pabot --pabotlibhost 192.168.1.123 --pabotlibport 8271 --processes 10 tests
     pabot --pabotlib --pabotlibhost 192.168.1.111 --pabotlibport 8272 --processes 10 tests

### PabotLib

pabot.PabotLib provides keywords that will help communication and data sharing between the executor processes.
These can be helpful when you must ensure that only one of the processes uses some piece of data or operates on some part of the system under test at a time.

Docs are located at https://cdn.rawgit.com/mkorpela/pabot/master/PabotLib.html

### PabotLib example:

test.robot

      *** Settings ***
      Library    pabot.PabotLib
      
      *** Test Case ***
      Testing PabotLib
        Acquire Lock   MyLock
        Log   This part is critical section
        Release Lock   MyLock
        ${valuesetname}=    Acquire Value Set
        ${host}=   Get Value From Set   host
        ${username}=     Get Value From Set   username
        ${password}=     Get Value From Set   password
        Log   Do something with the values (for example access host with username and password)
        Release Value Set
        Log   After value set release others can obtain the variable values

valueset.dat

      [Server1]
      HOST=123.123.123.123
      USERNAME=user1
      PASSWORD=password1
      
      [Server2]
      HOST=121.121.121.121
      USERNAME=user2
      PASSWORD=password2
      

pabot call

      pabot --pabotlib --resourcefile valueset.dat test.robot

### Global variables

Pabot will insert following global variables to Robot Framework namespace. These are here to enable PabotLib functionality and for custom listeners etc. to get some information on the overall execution of pabot.

      PABOTLIBURI - this contains the URI for the running PabotLib server
      PABOTEXECUTIONPOOLID - this contains the pool id (an integer) for the current Robot Framework executor. This is helpful for example when visualizing the execution flow from your own listener.
 
