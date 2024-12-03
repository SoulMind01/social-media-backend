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

## DynamoDB
### Steps:
1. Use a lambda function or the AWS CLI to write data to the table:
```bash
aws dynamodb put-item --table-name AppTable --item '{"id": {"S": "1"}, "message": {"S": "Test data"}}'
```
2. Query the table to confirm the data is stored:
```bash
aws dynamodb get-item --table-name AppTable --key '{"id": {"S": "1"}}'
```
## S3 bucket
### Steps:
1. Use the AWS CLI to upload a file:
```bash
echo "Hello, S3!" > test-file.txt
aws s3 cp test-file.txt s3://app-bucket-17i412eb/test-file.txt
```
2. List the files in the bucket to confirm the upload:
```bash
aws s3 ls s3://app-bucket-17i412eb/
```
## ElastiCache
### Steps:
1. Connect to the Redis cluster using a Redis client (e.g., redis-cli):
```bash
redis-cli -h app-cache.o649ed.0001.usw1.cache.amazonaws.com -p 6379
```
2. Set and retrieve a test key-value pair:
```bash
SET testKey "Hello, Redis!"
GET testKey
```

## CloudWatch
1. Get the endpoint for your API Gateway
2. Send a test request to the API Gateway, triggering the lambda function
```bash
aws lambda invoke --function-name AppFunction response.json
```