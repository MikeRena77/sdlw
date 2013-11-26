/*****************************************************************************
*
*  NAME        :  $Workfile:   GetServer.cmd  $
*                 $Revision:   1.0  $
*                 $Date:   05 Aug 2002 09:24:10  $
*
* DESCRIPTION : Script to return software development server name.
*               It looks up the environment variable SOFTWARE_DEVELOPMENT_SERVER
*               to obtain the server name. If the environment variable is not
*               set then it defaults to WDSWDEVL.
*
*  MODIFICATION/REV HISTORY :
*
* $Log:   P:/vcs/cm/GetServer.cmdv  $
*  
*     Rev 1.0   05 Aug 2002 09:24:10   CraigL
*  Initial revision.
*  
*
*****************************************************************************/

serverName = VALUE('SOFTWARE_DEVELOPMENT_SERVER',,'ENVIRONMENT')
IF serverName == "" THEN
    serverName = "WDSWDEVL"
RETURN serverName
