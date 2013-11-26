@echo off
rem ***************************************************************************************
rem *   Filename:  massWebCheck.bat
rem *   Batch script used to perform FP Server command-line recalc and 
rem *       check on all of the webs running on HARDEV3
rem *
rem *   Build accomplished on HARDEV3 OpenMake Remote Build Server
rem *   The command line is just:
rem *       massWebCheck.bat
rem *   No variables are required to support this script
rem *
rem *   Written 4-02-2008
rem *   by Michael Andrews
rem *   for AAFES HQ
rem *
rem *   Version    Date       by   Change Description
rem *     1.0      4/02/2008  MHA  Script written for web check utility
rem *
rem ***************************************************************************************

set PATH=%PATH%;C:\Program Files\Common Files\Microsoft Shared\web server extensions\50\bin

owsadm.exe -o recalc -targetserver "http://hardev3:8088/_vti_bin/_vti_adm/fpadmdll.dll" -w "/" -p 8088
owsadm.exe -o recalc -targetserver "http://hardev3:8098/_vti_bin/_vti_adm/fpadmdll.dll" -w "/" -p 8098
owsadm.exe -o recalc -targetserver "http://hardev3:8080/_vti_bin/_vti_adm/fpadmdll.dll" -w "/" -p 8080
owsadm.exe -o check -targetserver "http://hardev3:8088/_vti_bin/_vti_adm/fpadmdll.dll" -w "/" -p 8088
owsadm.exe -o check -targetserver "http://hardev3:8098/_vti_bin/_vti_adm/fpadmdll.dll" -w "/" -p 8098
owsadm.exe -o check -targetserver "http://hardev3:8080/_vti_bin/_vti_adm/fpadmdll.dll" -w "/" -p 8080