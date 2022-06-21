# Azure Virtual Desktop
## [Create a host pool](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-azure-marketplace?tabs=azure-portal) (30min)
- Basics
    - Project details
        - Validation environment: **No**
    - Host pool type
        - Personal
            - Host pool type: **Personal**
            - Assignment type: **Automatic**
        - Pooled
            - Host pool type: **Pooled**
            - Load balancing algorithm: **Breadth-first** (廣度)
            - Max session limit: **5**
- Virtual Machines
    - Add Azure virtual machines: Yes
    - Name prefix: **t-wvd**
    - Availability options: **No infrastructure redundancy required**
    - Number of VMs: **3**
    - OS disk type: **Standard SSD**
    - Boot Diagnostics: **Disable**
- Network and security
    - Public inbound ports: **No**
- Domain to join
    - Select which directory you would like to join: **Azure Active Directory**
    - Enroll VM with Intune: **No**
- Virtual Machine Administrator account
    - Username
    - Password
    - Confirm password
- Workspace
    - Register desktop app group: **Yes**
    - To this workspace: **t-wvd-ws** (Create new)

## Manage app groups