# social-media-backend
A social media backend hosted by AWS

# testing
## api gateway & lambda function

## cognito
### Goal: verify that user registration and authentication work
### Steps:
1. Use the AWS CLI to sign up a test user:
```bash
aws cognito-idp sign-up \
  --client-id i7eseetenrnh7g23u4mns8kkp \
  --username testuser@example.com \
  --password TestPassword123!
```
2. Confirm the user via the AWS Console or CLI.
3. Use the AWS CLI to authenticate:
```bash
aws cognito-idp initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id i7eseetenrnh7g23u4mns8kkp \
  --auth-parameters USERNAME=testuser@example.com,PASSWORD=TestPassword123!
```