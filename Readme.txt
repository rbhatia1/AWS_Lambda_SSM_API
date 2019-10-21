Author: Rajiv Bhatia
Email:  rajiv.bhatia@aog-llc.com
Date:   10/21/2019

The exercise ...:

Write a CloudFormation template or a command-line script that creates:

1. An AWS Lambda function that finds all instances based on a given pair of AWS tag key/values and prints the instances ids of the instances that are tagged with the given values to standard output.

2. An SSM Automation Document that:

  a. Accepts two parameters: tag key, tag value

  b. Invokes the Lambda function (Created in Step 1) using the tag key/value passed as the input to the automation document as input to the lambda function

  c. Invokes a Run Command that lists the contents of the root directory on all Linux instances for the tag key/value passed as the input to the automation document.

Response - I have created a cli based solution.  All required commands are run from automation.sh file.  This is a shell script that calls all necessary sub-commands to build required resources and execute SSM document.  If resources such as Lambda function and the SSM document already exist, you will receive an error building them which is normal.  Please see below a list of files, what they do, and order of execution.

1. automation.sh - This is a shell script that calls all necessary commands to build required resources and execute SSM document.  Here is the output:

λ sh automation.sh
Enter Tag Name: Name
Enter Tag Value: 1123

An error occurred (ResourceConflictException) when calling the CreateFunction operation: Function already exist: AutoTestV2

An error occurred (DocumentAlreadyExists) when calling the CreateDocument operation: Document with same name AutoSSMTestV2 already exists

OUTPUTPAYLOAD   {"Payload":"[\"i-0a5fb3aaa880cff9d\", \"i-0588964d11a3f8e8d\"]","StatusCode":200}
PAYLOAD [\"i-0a5fb3aaa880cff9d\", \"i-0588964d11a3f8e8d\"]
STATUSCODE      200
[
    {
        "Output": "bin\nboot\ncgroup\ndev\netc\nhome\nlib\nlib64\nlocal\nlost+found\nmedia\nmnt\nopt\nproc\nrajiv1122\nrajivDDDD\nroot\nrun\nsbin\nselinux\nsrv\nsys\ntmp\nusr\nvar\n"
    },
    {
        "Output": "bin\nboot\ndev\netc\nhome\nlib\nlib64\nlocal\nmedia\nmnt\nopt\nproc\nroot\nrun\nsbin\nsrv\nsys\ntmp\nusr\nvar\n"
    }
]

C:\Users\rb131\Documents\AWS certification\keypair\aws-lambda\rajiv\final\app2
λ

2. automation.yaml - This is the SSM automation document.  It invokes Lambda function called "AutoTestV2".

3. lambda_function.py - This code contains Lambda function logic.  It accepts two parameters called KN (instance tag name) and KV (value associated with a given tag name).  It fetches all instances matching the tag name : value pair and returns two pieces of data: 1) number of matching instances; 2) instance ids of matching instances.

4. lambda_function.zip - this is the zip file of lambda_function.py.  It is uploaded to an s3 bucket as well.

5. Rajiv_Test-dev-swagger-apigateway.yaml - This is the export of "swagger + api gateway extension" of Rest API.  This API accepts two parameters called KN (instance tag name) and KV (value associated with a given tag name).  It invokes the Lambda function called Rajiv_test.  This Lambda function accepts input values from the API and returns back number of matching instances and respective instance IDs.  To call the REST API, use the following url and pass KN and KV as input parameters.

https://4gmey2oxa7.execute-api.us-east-1.amazonaws.com/dev/check/test?KN=Name&KV=1123

Sample output:

{"Instances": ["i-0a5fb3aaa880cff9d", "i-0588964d11a3f8e8d"], "Number of matching instances found": "2"}

6. Rajiv_test-lambda.zip - This is the zip file of Python code that build Lambda function called "Rajiv_test".  Rest API calls this function to get instance id(s) matching tag:value pair.