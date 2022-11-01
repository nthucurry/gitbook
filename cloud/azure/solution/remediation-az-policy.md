- 參考
    - [Prevent anonymous public read access to containers and blobs](https://docs.microsoft.com/en-us/azure/storage/blobs/anonymous-read-access-prevent)
    - [Remediate non-compliant resources with Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources)
- 設定 Azure Policy
    - Effect Type 設定 modify 或 deployIfNotExists
- 設定 Remediation
    ```json
    {
      "properties": {
        "displayName": "Storage account blob public access should be disallowed",
        "policyType": "Custom",
        "mode": "All",
        "description": "禁止 Public Access 存取 Storage Account Blob",
        "metadata": {
          "category": "客製化",
          "createdBy": "576b202c-9485-49bf-828e-7eb45c3072b2",
          "createdOn": "2022-06-15T06:51:51.7423189Z",
          "updatedBy": "576b202c-9485-49bf-828e-7eb45c3072b2",
          "updatedOn": "2022-06-17T03:29:03.8120475Z"
        },
        "parameters": {},
        "policyRule": {
          "if": {
            "allOf": [
              {
                "field": "type",
                "equals": "Microsoft.Storage/storageAccounts"
              },
              {
                "not": {
                  "field": "Microsoft.Storage/storageAccounts/allowBlobPublicAccess",
                  "equals": "false"
                }
              }
            ]
          },
          "then": {
            "effect": "modify",
            "details": {
              "roleDefinitionIds": [
                "/providers/microsoft.authorization/roleDefinitions/17d1049b-9a84-46fb-8f53-869881c3d3ab"
              ],
              "conflictEffect": "audit",
              "operations": [
                {
                  "condition": "[greaterOrEquals(requestContext().apiVersion, '2019-04-01')]",
                  "operation": "addOrReplace",
                  "field": "Microsoft.Storage/storageAccounts/allowBlobPublicAccess",
                  "value": false
                }
              ]
            }
          }
        }
      },
      "id": "/subscriptions/xxx/providers/Microsoft.Authorization/policyDefinitions/aea2301a-14a6-488f-9345-2c3c14cf1cf0",
      "type": "Microsoft.Authorization/policyDefinitions",
      "name": "aea2301a-14a6-488f-9345-2c3c14cf1cf0",
      "systemData": {
        "createdBy": "xxx@xxx.com",
        "createdByType": "User",
        "createdAt": "2022-06-15T06:51:51.7129257Z",
        "lastModifiedBy": "xxx@xxx.com",
        "lastModifiedByType": "User",
        "lastModifiedAt": "2022-06-17T03:29:03.7330174Z"
      }
    }
    ```