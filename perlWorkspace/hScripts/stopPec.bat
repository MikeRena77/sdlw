net stop "BOBJCentralMS"
net stop "BOBJCrystalReportApplicationServer"
net stop "BOBJCrystalReportsCacheServer"
net stop "BOBJCrystalReportspageserver"
net stop "BOBJCS"
net stop "BOBJDesktopIntelligenceCacheServer"
net stop "BOBJDesktopIntelligenceReportServer"
net stop "BOBJDestinationServer"
net stop "BOBJEventServer"
net stop "BOBJInputFileServer"
net stop "BOBJJobServer_DesktopIntelligence"
net stop "BOBJJobServer_Report"
net stop "BOBJMySQL"
net stop "BOBJOutputFileServer"
net stop "BOBJProcessServer"
net stop "BOBJProgramServer"
net stop "BOBJTomcat"
net stop "BOBJWebiServer"
net stop "BOBJWIRS"
net stop "Harvest Agent Service"

echo All services touching PEC should now be stopped
echo If the installation of the new PEC is successful
echo Plan to finish with a reboot
echo REBOOTING will be the simplest method of insuring
echo that all services that should be started do get started
echo The service "handles" used here are not the same as the
echo names displayed in Windows Services, so restarting all of these
echo is not a simple matter
