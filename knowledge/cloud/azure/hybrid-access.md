- [Learn about Conditional Access and Intune](#learn-about-conditional-access-and-intune)
- [Ways to use Conditional Access with Intune](#ways-to-use-conditional-access-with-intune)
    - [Device-based Conditional Access](#device-based-conditional-access)
    - [App-based Conditional Access](#app-based-conditional-access)
- [Windows Information Protection (WIP)](#windows-information-protection-wip)

# [Learn about Conditional Access and Intune](https://docs.microsoft.com/en-us/mem/intune/protect/conditional-access)
Use Conditional Access with Microsoft Intune to control the devices and apps that can connect to your email and company resources. When integrated, you can gate access to keep your corporate data secure, while giving users an experience that allows them to do their best work from any device, and from any location.

# Ways to use Conditional Access with Intune
## Device-based Conditional Access
Intune and AAD work together to make sure only managed and compliant devices can access email, Microsoft 365 services, SaaS apps, and on-premises apps. Additionally, you can set a policy in AAD to enable only domain-joined computers or mobile devices that have enrolled (註冊) in Intune to access Microsoft 365 services. Including:
- Conditional Access based on network access control
- Conditional Access based on device risk
- Conditional Access for Windows PCs. Both corporate-owned and bring your own device (BYOD).
- Conditional Access for Exchange on-premises

## App-based Conditional Access
Intune and AAD work together to make sure only managed apps can access corporate e-mail or other Microsoft 365 services.

# [Windows Information Protection (WIP)](https://docs.microsoft.com/en-us/windows/security/information-protection/windows-information-protection/protect-enterprise-data-using-wip)
WIP is the mobile application management (MAM) mechanism on Windows 10. WIP gives you a new way to manage data policy enforcement for apps and documents on Windows 10 desktop operating systems, along with the ability to remove access to enterprise data from both enterprise and personal devices (after enrollment in an enterprise management solution, like Intune).
- Prerequisites
    - Windows 10, version 1607 or later
    - Microsoft Intune or Microsoft Endpoint Configuration Manager
- Benefits of WIP
    - Obvious separation between personal and corporate data, without requiring employees to switch environments or apps.
    - Additional data protection for existing line-of-business apps without a need to update the apps.
    - Ability to wipe corporate data from Intune MDM enrolled (註冊) devices while leaving personal data alone.
    - Use of audit reports for tracking issues and remedial actions.
- Why use WIP?
    - Change the way you think about data policy enforcement.
    - Manage your enterprise documents, apps, and encryption modes.
        - Copying or downloading enterprise data.
        - Using protected apps.
        - Managed apps and restrictions.
        - Deciding your level of data access.
        - Data encryption at rest.
        - Helping prevent accidental data disclosure to public spaces.
        - Helping prevent accidental data disclosure to removable media.
    - Remove access to enterprise data from enterprise-protected devices.