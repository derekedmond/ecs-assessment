# ECS Assess`ment
The following use case is based on a real client request and a solution should be coded to automated this process.

- Use Case:
-- A database upgrade requires the execution of numbered scripts stored in a specified folder, e.g. SQL scripts such as 045.createtable.sql.
-- There may be gaps in the numbering and there isn't always a . (dot) after the number.
-- The database upgrade is based on looking up the current version in the database and comparing this number to the numbers in the script names.
-- If the version number from the db matches the highest number from the script then nothing is executed.
-- If the number from the db is lower than the highest number from the scripts, then all scripts that contain a higher number than the db will be executed against the database.
-- In addition, the database version table is updated after the install with the highest number.

- Requirements:
-- Supported Languages: Bash, Python2.7, PHP, Shell, Ruby, Powershell - No other languages will be accepted
-- The table where the version is stored is called 'versionTable', and the row with the version is 'version'. This table contains only one column with the actual version.
-- You will have to use a MySQL database
-- The information about the database and the directory will be passed through arguments, following this format: 
```
<directory with .sql scripts> <username for the DB> <DB host> <DB name> <DB password>
```

# Solution: database_update.sh
The solution is a Bash script that iterates over each of the scripts and compares the version in the filename to the version in the database.
```
Usage:
     database_update.sh <directory with .sql scripts> <username for the DB> <DB host> <DB name> <DB password>
```

# Demo 
The solution can be demonstarted using a Docker image that has been pushed to Docker Cloud: **derekedmond/ecs-assessment**. This image is based on CentOS 6 with a MySQL instance running and a user called 'admin' configured with a known password.

### Script Files
These demo script files have enough variety to satisfy all the variations described in the use case. 
```
039.createtable.sql
041.createtable.sql
043.createtable.sql
050.createtable.sql
051createtable.sql
073.createtable.sql
148.createtable.sql
991.createtable.sql
```

In the demo database the initial value of version is **44**.
 
Start the Docker instance containing the test database:
```
docker run -d -t --name ecs-assessment derekedmond/ecs-assessment:latest
```
To run the upgrade, execute the **database_update.sh** Bash script with the appropriate arguments:
```
docker exec -it ecs-assessment  /tmp/database_update.sh /tmp/scripts admin localhost ecs Pai8ooyaize6we1e
```

### Output:
Given the inital value of version is **44**, we expect scripts to be ignored that refer to earlier versions. As the upgrade progresses, we expect to see the version in the database be updated as per the names of the scripts. 
```
Dereks-Air:ecs-assessment derekedmond$ docker exec -it ecs-assessment /tmp/database_update.sh /tmp/scripts admin localhost ecs Pai8ooyaize6we1e
---- 039.createtable.sql ----
ignoring script: 039.createtable.sql
---- 041.createtable.sql ----
ignoring script: 041.createtable.sql
---- 043.createtable.sql ----
ignoring script: 043.createtable.sql
---- 050.createtable.sql ----
executing script: 050.createtable.sql... done
updated ecs.versionTable version: 44 -> 50
---- 051createtable.sql ----
executing script: 051createtable.sql... done
updated ecs.versionTable version: 50 -> 51
---- 073.createtable.sql ----
executing script: 073.createtable.sql... done
updated ecs.versionTable version: 51 -> 73
---- 148.createtable.sql ----
executing script: 148.createtable.sql... done
updated ecs.versionTable version: 73 -> 148
---- 991.createtable.sql ----
executing script: 991.createtable.sql... done
updated ecs.versionTable version: 148 -> 991
```
If the script is run on subsequent occasions, we expect all the scripts to be ignored as version has now reached **991**.
```
Dereks-Air:ecs-assessment derekedmond$ docker exec -it ecs-assessment /tmp/database_update.sh /tmp/scripts admin localhost ecs Pai8ooyaize6we1e
---- 039.createtable.sql ----
ignoring script: 039.createtable.sql
---- 041.createtable.sql ----
ignoring script: 041.createtable.sql
---- 043.createtable.sql ----
ignoring script: 043.createtable.sql
---- 050.createtable.sql ----
ignoring script: 050.createtable.sql
---- 051createtable.sql ----
ignoring script: 051createtable.sql
---- 073.createtable.sql ----
ignoring script: 073.createtable.sql
---- 148.createtable.sql ----
ignoring script: 148.createtable.sql
---- 991.createtable.sql ----
ignoring script: 991.createtable.sql
```

