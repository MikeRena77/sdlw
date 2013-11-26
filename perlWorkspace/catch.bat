@echo off
rem ***************************************************************************************
rem *Header: catch.bat, v1.0, 5/21/2008 07:55 mha                                                                           *
rem * Batch script used to capture packages as they are passed from the Harvest server
rem *
rem * This script writes the package names passed from the Harvest server script <omWebDllBld.sh>
rem *        to a temporary holding file <pkg> until the OpenMake processing has completed
rem *
rem * Usage: catch.bat [package]
rem *     where:
rem *         package = the specific work packages being handled for the build
rem *
rem * Original coding 5-21-2008
rem *    by Michael Andrews (MHA)
rem *    for AAFES HQ
rem *
rem * Version     Date        by    Change Description
rem *   1.0       5/21/2008   MHA   Initially written to handle passing package names in to OpenMake scripts
rem *   1.1        8/18/2008  MHA    Check for previous existence of the pkg file before beginning capture
rem *   1.2.1      8/27/2009  MHA    Guiffy 3-way merge test CAN IT BE MODIFIED IN IM
rem *
rem ***************************************************************************************
dir
set pkg=\hScripts\pkg
if exist %pkg% del %pkg%

echo %1 >> %pkg%