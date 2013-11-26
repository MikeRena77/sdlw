
# sample tests changing current working directory of a script

print "<p> Current Dir is ";
print Win32::GetCwd();
print "<p>";

Win32::SetCwd("..");

print "<p> Current Dir is ";
print Win32::GetCwd();

# assumes that such a directory exists 
Win32::SetCwd("d:/INetSrv/i386");

print "<p> Current Dir is ";
print Win32::GetCwd();
