# Send Mail by SendGrid
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/azure/sendgrid-login-portal.png">
<br><img src="https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/cloud/azure/sendgrid-api-curl.png">

# Sample Code
```bash
export SENDGRID_API_KEY="SG.xxx"

curl --request POST \
    --url https://api.sendgrid.com/v3/mail/send \
    --header "Authorization: Bearer $SENDGRID_API_KEY" \
    --header 'Content-Type: application/json' \
    --data '{"personalizations": [{"to": [{"email": "test@gmail.com"}]}],"from": {"email": "test@o365.fcu.edu.tw"},"subject": "Sending with SendGrid is Fun","content": [{"type": "text/plain", "value": "and easy to do anywhere, even with cURL"}]}'
```