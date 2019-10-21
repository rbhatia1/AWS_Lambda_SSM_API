#!usr/bin/bash

read -p "Enter Tag Name: " KN
read -p "Enter Tag Value: " KV

aws lambda create-function \
    --function-name "AutoTestV2" \
    --runtime "python3.7" \
    --role "arn:aws:iam::175587343124:role/rajiv-lambda-role" \
    --handler "lambda_function.lambda_handler" \
    --timeout 10 \
    --zip-file "fileb://lambda_function.zip" \
    --region "us-east-1"

aws ssm create-document \
    --content file://automation.yaml \
    --name "AutoSSMTestV2" \
    --document-type "Automation" \
    --document-format YAML

execution_id=$(aws ssm start-automation-execution --document-name AutoSSMTestV2 --parameters "KN=${KN},KV=${KV}" --output text)
# echo $execution_id
sleep 10
aws ssm get-automation-execution --automation-execution-id "$execution_id" --query "AutomationExecution.StepExecutions[0].Outputs" --output text
command_id=$(aws ssm get-automation-execution --automation-execution-id "$execution_id" --query "AutomationExecution.StepExecutions[1].Outputs.CommandId" --output text)
# echo $command_id
aws ssm list-command-invocations --command-id "$command_id" --details --query "CommandInvocations[].CommandPlugins[].{Output:Output}"
