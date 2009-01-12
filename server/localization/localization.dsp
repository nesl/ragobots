# Microsoft Developer Studio Project File - Name="localization" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=localization - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "localization.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "localization.mak" CFG="localization - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "localization - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "localization - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "localization - Win32 Release"

# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release\localization"
# PROP Intermediate_Dir "Release\localization"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
LIB32=link.exe -lib
MTL=midl.exe
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD CPP /nologo /MD /W3 /GX /Zi /O2 /I ".\\" /I "$(MAGICK_HOME)\include" /I "libwww\include" /I "libwww\include\w3c-libwww" /I "libwww\include\windows" /D "NDEBUG" /D "WIN32" /D "_CONSOLE" /D "_VISUALC_" /D "NeedFunctionPrototypes" /D "_DLL" /D "_MAGICKMOD_" /D "USE_METEOR" /U "WWW_WIN_DLL" /FR /FD /c
# ADD BASE RSC /l 0x409
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /machine:IX86
# ADD LINK32 CORE_RL_magick_.lib CORE_RL_Magick++_.lib X11.lib kernel32.lib user32.lib gdi32.lib odbc32.lib odbccp32.lib ole32.lib oleaut32.lib winmm.lib dxguid.lib wsock32.lib advapi32.lib wwwinit.lib wwwapp.lib wwwxml.lib wwwhtml.lib wwwtelnt.lib wwwnews.lib wwwhttp.lib wwwmime.lib wwwgophe.lib wwwftp.lib wwwfile.lib wwwdir.lib wwwcache.lib wwwstream.lib wwwmux.lib wwwtrans.lib wwwcore.lib wwwutils.lib pics.lib xmlparse.lib gnu_regex.lib xmltok.lib zlib.lib /nologo /subsystem:console /debug /machine:I386 /libpath:"$(MAGICK_HOME)\lib\\" /libpath:"$(MAGICK_HOME)\lib" /libpath:"libwww\lib"
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "localization - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "localization___Win32_Debug"
# PROP BASE Intermediate_Dir "localization___Win32_Debug"
# PROP BASE Ignore_Export_Lib 0
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Debug/localization"
# PROP Intermediate_Dir "Debug/localization"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
LIB32=link.exe -lib
MTL=midl.exe
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE CPP /nologo /MD /W3 /GX /Zi /O2 /I ".\\" /I "$(MAGICK_HOME)\include" /I "libwww\include" /I "libwww\include\w3c-libwww" /I "libwww\include\windows" /D "NDEBUG" /D "WIN32" /D "_CONSOLE" /D "_VISUALC_" /D "NeedFunctionPrototypes" /D "_DLL" /D "_MAGICKMOD_" /D "USE_METEOR" /U "WWW_WIN_DLL" /FR /FD /c
# ADD CPP /nologo /MD /W3 /GX /Zi /Od /I ".\\" /I "$(MAGICK_HOME)\include" /I "libwww\include" /I "libwww\include\w3c-libwww" /I "libwww\include\windows" /I "Sockets" /D "NDEBUG" /D "WIN32" /D "_CONSOLE" /D "_VISUALC_" /D "NeedFunctionPrototypes" /D "_DLL" /D "_MAGICKMOD_" /D "USE_METEOR" /U "WWW_WIN_DLL" /FR /FD /c
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 CORE_RL_magick_.lib CORE_RL_Magick++_.lib X11.lib kernel32.lib user32.lib gdi32.lib odbc32.lib odbccp32.lib ole32.lib oleaut32.lib winmm.lib dxguid.lib wsock32.lib advapi32.lib wwwinit.lib wwwapp.lib wwwxml.lib wwwhtml.lib wwwtelnt.lib wwwnews.lib wwwhttp.lib wwwmime.lib wwwgophe.lib wwwftp.lib wwwfile.lib wwwdir.lib wwwcache.lib wwwstream.lib wwwmux.lib wwwtrans.lib wwwcore.lib wwwutils.lib pics.lib xmlparse.lib gnu_regex.lib xmltok.lib zlib.lib /nologo /subsystem:console /debug /machine:I386 /libpath:"$(MAGICK_HOME)\lib\\" /libpath:"$(MAGICK_HOME)\lib" /libpath:"libwww\lib"
# SUBTRACT BASE LINK32 /pdb:none
# ADD LINK32 CORE_RL_magick_.lib CORE_RL_Magick++_.lib X11.lib kernel32.lib user32.lib gdi32.lib odbc32.lib odbccp32.lib ole32.lib oleaut32.lib winmm.lib dxguid.lib wsock32.lib advapi32.lib wwwinit.lib wwwapp.lib wwwxml.lib wwwhtml.lib wwwtelnt.lib wwwnews.lib wwwhttp.lib wwwmime.lib wwwgophe.lib wwwftp.lib wwwfile.lib wwwdir.lib wwwcache.lib wwwstream.lib wwwmux.lib wwwtrans.lib wwwcore.lib wwwutils.lib pics.lib xmlparse.lib gnu_regex.lib xmltok.lib zlib.lib /nologo /subsystem:console /debug /machine:I386 /libpath:"$(MAGICK_HOME)\lib\\" /libpath:"$(MAGICK_HOME)\lib" /libpath:"libwww\lib"
# SUBTRACT LINK32 /pdb:none

!ENDIF 

# Begin Target

# Name "localization - Win32 Release"
# Name "localization - Win32 Debug"
# Begin Group "src"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\ChangeFormat.cpp

!IF  "$(CFG)" == "localization - Win32 Release"

!ELSEIF  "$(CFG)" == "localization - Win32 Debug"

# SUBTRACT CPP /I "Sockets"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\chunk.c

!IF  "$(CFG)" == "localization - Win32 Release"

!ELSEIF  "$(CFG)" == "localization - Win32 Debug"

# SUBTRACT CPP /I "Sockets"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\CMvision.c

!IF  "$(CFG)" == "localization - Win32 Release"

!ELSEIF  "$(CFG)" == "localization - Win32 Debug"

# SUBTRACT CPP /I "Sockets"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\MoteCom.c
# End Source File
# Begin Source File

SOURCE=.\ProcessFrame.c

!IF  "$(CFG)" == "localization - Win32 Release"

!ELSEIF  "$(CFG)" == "localization - Win32 Debug"

# SUBTRACT CPP /I "Sockets"

!ENDIF 

# End Source File
# End Group
# Begin Group "include"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\chunk.h
# End Source File
# Begin Source File

SOURCE=.\CMVision.h
# End Source File
# Begin Source File

SOURCE=.\Main.h
# End Source File
# Begin Source File

SOURCE=.\MoteCom.h
# End Source File
# Begin Source File

SOURCE=.\ProcessFrame.h
# End Source File
# End Group
# End Target
# End Project
