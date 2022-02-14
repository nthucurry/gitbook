# Oracle Database 11g: Administration Workshop I
## Ch1: Exploring the Oracle Database Architectur
- Memory region that contains data and control information for a server or background process is called:
    - [ ] Shared Pool
    - [x] PGA
    - [ ] Buffer Cache
    - [ ] User session data
- What is read into the Database Buffer Cache from the data files?
    - [ ] Rows
    - [ ] Changes
    - [x] Blocks
    - [ ] SQL
- The Process Monitor process (PMON):
    - [ ] Performs recovery at instance startup
    - [x] Performs process recovery when a user process fails
    - [ ] Automatically resolves all in-doubt transactions
    - [ ] Writes the redo log buffer to a redo log file
- ASM Files are accessed by which types of instances?
    - [ ] RDBMS Instances only
    - [ ] ASM Instances only
    - [x] Both RDBMS and ASM Instances

## Ch2: Installing your Oracle Software
- During Grid infrastructure setup it is a possible to:
    - [ ] Specify exact location of datafiles for ASM instance
    - [x] Create only one DISKGROUP
    - [ ] Specify size of SGA for ASM instance
    - [ ] Create several DISKGROUPS
- During Database software installation you can specify groups for:
    - [x] the osoper group
    - [ ] the osasm group
    - [x] the osdba group
    - [ ] the osadmin group

## Ch3: Creating an Oracle Database Using DBCA
- The parameter DB_BLOCK_SIZE is set for the lifetime of a database and cannot be changed. (True)

## Ch4: Managing the Database Instance
- Bigfile Tablespaces must have 1 file of at least 100 MB. (False)
- When using Oracle Restart, the server control utility (srvctl) must be used instead of SQL*Plus to start and stop a database instance. (False)
- Which data dictionary view can be used to find the names of all tables in the database?
    - [ ] USER_TABLES
    - [ ] ALL_TABLES
    - [x] DBA_TABLES
    - [ ] ANY_TABLES

## Ch5: Managing the ASM Instance
- Which parameter is required for an ASM instance?
    - [x] INSTANCE_TYPE
    - [ ] ASM_DISKGROUPS
    - [ ] LARGE_POOL_SIZE
    - [ ] None of the above

## Ch6: Configuring the Oracle Network Environment
- When using the shared server process architecture, the PGA is relocated into the SGA. (False)

## Ch7: Managing Database Storage Structures