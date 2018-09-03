#!/bin/bash
# database_update.sh, Derek Edmond (Sept 2018)

display_usage() { 
     echo "Usage: "
     echo "     database_update.sh <directory with .sql scripts> <username for the DB> <DB host> <DB name> <DB password>"
}

# check arguments passed
if [  $# -le 4 ]; then
     echo "Error: not enough arguments" 
     display_usage
     exit 1
fi 

# set variables based on arguments passed in
script_dir=$1
db_user=$2
db_host=$3
db_name=$4
db_pswd=$5

# iterate over each script in script_dir
for s in $(ls $script_dir) ; do
     echo "---- $s ----"

     # get version from first 3 numbers at start of filename
     script_version_str=$(echo $s | cut -c1-3 | sed 's/[^0-9]*//g')
 
     # parse the version string to a number
     script_version=$(expr $script_version_str + 0)

     # query db to check version in versionTable
     db_version=`mysql -u $db_user -p$db_pswd -h $db_host $db_name -N -s -e "select version from versionTable"`
 
     if [ $db_version -lt $script_version ] ; then

          # execute script
          echo -e -n "executing script: $s... "
          if mysql < ${script_dir}/${s}; then
               echo "done"
          else
               # there was a problem with the script, exit script
               echo "script failed"
               exit 1
          fi

          # update versionTable with the new version applied
          mysql -u $db_user -p$db_pswd -h $db_host $db_name -e "update ecs.versionTable SET version='$script_version' where version ='$db_version'"
          echo "updated ecs.versionTable version: $db_version -> $script_version"
          
     else 
          echo -e "ignoring script: $s"
     fi
done
