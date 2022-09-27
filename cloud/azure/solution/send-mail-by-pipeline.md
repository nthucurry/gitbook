# Reference
- [Azure DevOps and SendGrid Integration - Step by Step Guide](https://akhilsharma.work/azure-devops-and-sendgrid-integration-step-by-step-guide/)
- [如何從Azure DevOps Pipeline寄信給指定對象 - Send email notification in an Azure DevOps pipeline](https://andy51002000.blogspot.com/2019/11/azure-devops-pipeline.html)

# Sample Pipeline YAML (undone)
```yml
pool:
  name: Linux

- task: EmailReport@1
  inputs:
    sendMailConditionConfig: 'Always'
    subject: '[{environmentStatus}] {passPercentage} tests passed in $(Release.EnvironmentName) stage for $(Build.BuildNumber)'
    toAddress: 'fool@contoso.com'
    defaultDomain: 'contoso.com'
    groupTestResultsBy: 'run'
    includeCommits: true
    maxTestFailuresToShow: '15'
    includeOthersInTotal: false
    usePreviousEnvironment: false
```

# [Manage notifications for a team, project, or organization](https://learn.microsoft.com/en-us/azure/devops/notifications/manage-team-group-global-organization-notifications?view=azure-devops&tabs=new-account-enabled)
- Create an email subscription
- Manage global delivery settings