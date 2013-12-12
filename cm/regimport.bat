@echo off
reg import %1
if [%2]==[] goto end
cd /d e:\TFS_BuildOutPuts
icacls %2 /grant genpitfi01\502194519:F

\rmdir /s /q D:\TFS_Builds
rmdir /s /q D:\TFSBuild_Source\e
rmdir /s /q D:\TFSBuild_Source\Fusion6000
rmdir /s /q D:\TFSBuild_Source\Payment
rmdir /s /q D:\TFSBuild_Source\PetronasOPT
rmdir /s /q D:\TFSBuild_Source\Nucleus\Chevron-Dev
rmdir /s /q D:\TFSBuild_Source\Nucleus\Chevron-Release
rmdir /s /q D:\TFSBuild_Source\Nucleus\Dev-Heartland-600
rmdir /s /q D:\TFSBuild_Source\Nucleus\FD0800_Dev
rmdir /s /q D:\TFSBuild_Source\Nucleus\GenPOS_Fullup_ATX
rmdir /s /q D:\TFSBuild_Source\Nucleus\GenPOS_Fullup_OP1
rmdir /s /q D:\TFSBuild_Source\Nucleus\GenPOS_Fullup_OP2
rmdir /s /q D:\TFSBuild_Source\Nucleus\GenPOS_Fullup_SH
rmdir /s /q D:\TFSBuild_Source\Nucleus\GenPOS_Main
rmdir /s /q D:\TFSBuild_Source\Nucleus\GenPOS_NucLite
rmdir /s /q D:\TFSBuild_Source\Nucleus\GenPOS_NucLite_LPR1

:end
