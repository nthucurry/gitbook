# Oracle Parameter
## Job
- job_queue_processes

## RAM
- sga_target: 指定 SGA 大小
    - sga_target=8G (autotuning)
    - sga_target=0
- pga_aggregate_target: 指定 PGA 大小
    - pga = sga * 20%
    - pga_aggregate_target=8G (autotuning)

# ERP Parameter
- FND_CONCURRENT_PROCESSES
    - Lists information about managers
    - Useful for determining UNIX and Oracle process is associated with managers
    - Identifies logfiles associated with managers
- FND_CONCURRENT_REQUESTS
    - Primary jobs submission table
    - Queried by the managers
    - Jobs are inserted into this table
    - Table can grow rather large thus affecting performance
    - Cleanup scripts available with the Applications
- FND_CONCURRENT_QUEUES
- FND_CONCURRENT_PROGRAMS
    - Stores information about concurrent programs
    - Each row includes a name and description of the concurrent program
    - Each row also includes the execution methods for the program (EXECUTION_METHOD_CODE), the argument method (ARGUMENT_METHOD_CODE), and whether the program is constrained (QUEUE_METHOD_CODE).