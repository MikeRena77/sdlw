#!/bin/sh

# This script will be used to autodemote packages from one state 
# through another to the destination state
# Called as a post-link UDP to a Demote Process.
# This is used to bypass a state and remove the versions from the view.
# If there are multiple states that need to be bypassed, this script
# will need to be post-linked to the Demote Process in each of those states.

# The command line is /opt/harvest/scripts/autohdp.sh "[broker]" "[project]" "[nextstate]" ["package"]

# Written by: Warren McCall
# Date: February 6, 2002

broker="$1"
env="$2"
nextstate="$3"

# Shift to the [package] variable
shift 3

# If there are more than one package, loop for them all
while [ $#  -ge  1  ]
do
package="$1"
/opt/harvest/bin/hdp -b "$broker" -en "$env" -st "$nextstate" -usr harvest -pw harvest "$package"
shift
done

