Ragobot Server Installation and Execution
For CMVision:
Installation:
1. Install Imagemagick-6.1.0 Q8 windows
  -- don't build from source, downloading binaries is easier
  -- Set MAGICK_HOME to  directory where Imagemagick was installed.
  -- Add "localization\libwww\modules" to PATH variable

Execution:
1. Run SerialFwder
2. MoteComm
3. C++ program for CMVision

For GUI of Game:
1. Run SerialFwder
2. RagobotServer
3. RagobotClient


GUI Design:
ConnectionListener listens for connection from a client at port 6076.
An object of ConnectionHandler is created by connectionlistener for every client. Moteid's are assigned to clients in the sequence in which they connect to the server. Assignment begins from 2.