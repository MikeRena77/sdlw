use Win32::Clipboard;

tie $CLIP, 'Win32::Clipboard';

die "$0: Can't convert non-text content\n" if !tied($CLIP)->IsText;

# eliminate returns from the content
$CLIP =~ s/\r//g;
# eliminate leading spaces
$CLIP =~ s/^\s+//;
# retain blank lines
$CLIP =~ s/\n\s*?\n/\r/gm;
# collapse all other lines
$CLIP =~ s/\n\s+?(?=\S)/ /gm;
# restore blank lines
$CLIP =~ s/\r\s*/\r\n\r\n/g;

print STDERR "The text in the clipboard has been reflowed\n"; 

 
 