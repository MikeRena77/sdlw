      open (VERSIONLIST,"versionlist.log") or die "Can't open versionlist.log: $!\n";
   ITEM: while (<VERSIONLIST>)
   {
      next ITEM if /^$/;                     # skip blank lines
      next ITEM if /^-+/;  # skip empty projects
      next ITEM if /^I000/;          # skip count of returned items
      if /^*+/;
          ($F1, $right_side_version) = split (' ', $_, 2 );
          if $left_side_version == $right_side_version

      # skip all the builds of the binary (there are thousands)
      next ITEM if /^wsHRFacade.pdb$/;       # skip all the builds of the binary (there are thousands)
      chomp;                                 # remove the newline

      if (/^\$\/.*:$/)                       # project directory in form of $/project/subproj:
      {
         $project = $_;
         chop $project;                      # remove trailing :

