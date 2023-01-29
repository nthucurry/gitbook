# Reference
- [TeslaFi](https://www.teslafi.com/signup.php)

# How to get bearer token ?
- Link your tesla account
    - https://www.teslafi.com/signup.php
        - https://auth.tesla.com/oauth2/v3/authorize?client_id=ownerapi&code_challenge=kVWrKnUEeuhJ9JBrPawV4xEes0uGj7RGpbVfp5DOOdI&code_challenge_method=S256&locale=en-US&prompt=login&redirect_uri=https%3A%2F%2Fauth.tesla.com%2Fvoid%2Fcallback&response_type=code&scope=openid+email+offline_access&state=iY5D8OjCqIThktiZVPXpiNZflyvHeObScHQYWwzI3G8
    - Get callback URL
        - https://auth.tesla.com/void/callback?locale=en-US&code=22f41b6a74e4d4080859dbaadf189e6ef2f3325fca2b0d4160f588d50eee&state=iY5D8OjCqIThktiZVPXpiNZflyvHeObScHQYWwzI3G8&issuer=https%3A%2F%2Fauth.tesla.com%2Foauth2%2Fv3
- Write down the code value
    - 22f41b6a74e4d4080859dbaadf189e6ef2f3325fca2b0d4160f588d50eee
- Exchange authorization code for bearer token
    - POST https://auth.tesla.com/oauth2/v3/token
    - Body
        ```
        grant_type:authorization_code
        client_id:ownerapi
        code:22f41b6a74e4d4080859dbaadf189e6ef2f3325fca2b0d4160f588d50eee
        code_verifier:6wLx~iNMvH-JzfDtGEBPgOxE2IeGQv2qRqoe3VekBlnhQcmGrI6UdLFrbmyrc.t_x.RFmHpAbPk4Okxy_XMpNsZTs2VJgFu-x1s4BvvLCp3IVcfCVHN4e6CSia5v-QWR
        redirect_uri:https://auth.tesla.com/void/callback
        ```
        - code_verifier
            - https://tonyxu-io.github.io/pkce-generator/
            - Code Verifier
                - 輸入 123
            - Press **Generate Code Challenge** (option)
            - Press **Generate Code Verifier**
            - Copy code_verifier value
    - Get result
```json
    {
        "access_token": "XXX",
        "refresh_token": "XXX",
        "id_token": "XXX",
        "expires_in": 28800,
        "state": "iY5D8OjCqIThktiZVPXpiNZflyvHeObScHQYWwzI3G8",
        "token_type": "Bearer"
    }
    ```
- [Refreshing an access token](https://tesla-api.timdorr.com/api-basics/authentication#refreshing-an-access-token)