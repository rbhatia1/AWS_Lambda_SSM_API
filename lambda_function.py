import boto3
import os
import json

region = 'us-east-1'
ec2 = boto3.resource('ec2')

def lambda_handler(event, context):
    KN = event["KN"]
    KV = event["KV"]
    search1 = ("[{'Name': 'tag:" + KN + "', 'Values': ['" + KV + "']}]")
    instances = ec2.instances.filter(Filters=eval(search1))
    RunningInstances = [instance.id for instance in instances]
    LRI = len(RunningInstances)
    if len(RunningInstances) > 0:
      print("Found " + str(LRI) + " instances with tag   " + KN + "   set to value   " + KV)
    else:
        print("None found")

    for i in RunningInstances:
        {
            print(i)
        }

    return json.dumps(RunningInstances, default=str)