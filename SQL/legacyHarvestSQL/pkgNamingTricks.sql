Yes, it is possible to display multiple numbering sequences.  ie:

CR-%N('FM099999')-%N('FM0099')

Will create packages of the type:

CR-000001-0001
CR-000002-0002

Not that useful, but it gets better when you put the date in with it:

CR-%N('FM099999')-%D('DDMONYYYY')

You get:

CR-000001-11MAR2002
CR-000002-11MAR2002

Quickly you can see exactly which packages were created on which dates!
