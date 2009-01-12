Ragobot Robot Software Readme
------------------------------
Ragobot robot software is written in TinyOS. Following are the software requirements to build Ragobot robot software.

Software Requirements
---------------------
1. You should TinyOS installed on your machine. You can download the installation files from http://webs.cs.berkeley.edu/tos/download.html


Step to download and build ragobot software
--------------------------------------------

1. Set following CVS environment variables.
% export CVSROOT=:ext:<login>@128.97.93.46:/Volumes/Vol1/neslcvs/CVS
% export CVS_RSH=ssh

2. Checkout the ragobots/robot/sw/ragobot directory from NESL CVS to $TOSROOT/contrib by executing following command. $TOSDIR is environment variable set by TinyOS installation. It points to TinyOS home directory,
  cvs co -d $TOSROOT/contrib ragobots/robot/sw/code 
  
  Note: you can download ragobots/robot/sw/ragobot folder anywhere on your machine, but downloading it in $TOSROOT/contrib makes all TinyOS related code at one place.

3. Go to $TOSROOT/contrib/ragobot/apps/Ragobot and run following command.
	make mica2
	
   You should be able to build the code without any error.
   
4. To program the code to mica2 run following command
	make mica2 install
	
You are all set to run Ragobot. Hook up your mote on Ragobot platform and Ragobot is ready to fight. :-).

