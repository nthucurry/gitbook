# Azure Virtual Desktop
## [Create a host pool](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-azure-marketplace?tabs=azure-portal) (30min)
- Basics
    - Project details
        - Validation environment: **No**
    - Host pool type
        - Personal (persistent)
            - Host pool type: **Personal**
            - Assignment type: **Automatic**
        - Pooled (non-persistent)
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

## [Manage app groups](https://docs.microsoft.com/en-us/azure/virtual-desktop/manage-app-groups)

## Connect to Azure Virtual Desktop with the web client
- https://client.wvd.microsoft.com/arm/webclient/index.html

## [Deploy Azure AD-joined virtual machines in Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/deploy-azure-ad-joined-vm)
- Known limitations
    - Azure AD-joined VMs **don't currently support** external identities, such as AAD B2B and AAD B2C
- Assign user access to host pools
    - Assign your users the **Virtual Machine User Login** role so they can sign in to the VMs.
- Access Azure AD-joined VMs
    - Connect using the Windows Desktop client (略)
    - Connect using the other clients
        - you must add **targetisaadjoined:i:1** as a custom RDP property

## [Create an autoscale scaling plan for Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/autoscale-scaling-plan) (Preview)

## Enforce Azure Active Directory Multi-Factor Authentication for Azure Virtual Desktop using Conditional Access