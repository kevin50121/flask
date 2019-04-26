#createelb
Arn_LoadbalancerArn=`aws elbv2 create-load-balancer --name ALB-Onboardingtasks-flask \
--subnets subnet-fdd98abb subnet-2b0fad5c --security-groups sg-bc40ddd9 \
| jq -r '.LoadBalancers[].LoadBalancerArn'`

#output 

    "LoadBalancers": [
        {
            "LoadBalancerArn": "arn:aws:elasticloadbalancing:ap-southeast-1:990090895087:loadbalancer/app/ALB-Onboardingtasks-flask/605266fb96b29e60",
            "DNSName": "ALB-Onboardingtasks-flask-1983663005.ap-southeast-1.elb.amazonaws.com",
            "CanonicalHostedZoneId": "Z1LMS91P8CMLE5",
            "CreatedTime": "2019-04-23T10:44:13.680Z",
            "LoadBalancerName": "ALB-Onboardingtasks-flask",
            "Scheme": "internet-facing",
            "VpcId": "vpc-0f62be6a",
            "State": {
                "Code": "provisioning"
            },
            "Type": "application",
            "AvailabilityZones": [
                {
                    "ZoneName": "ap-southeast-1a",
                    "SubnetId": "subnet-2b0fad5c"
                },
                {
                    "ZoneName": "ap-southeast-1c",
                    "SubnetId": "subnet-fdd98abb"
                }
            ],
            "SecurityGroups": [
                "sg-bc40ddd9"
            ],
            "IpAddressType": "ipv4"
        }
    ]
}

#Create TargetGroup

aws elbv2 create-target-group --name TG-onboardingtasks --protocol HTTP --port 80 \
--vpc-id vpc-0f62be6a | jq -r '.TargetGroups[].TargetGroupArn'

#output
{
    "TargetGroups": [
        {
            "TargetGroupArn": "arn:aws:elasticloadbalancing:ap-southeast-1:990090895087:targetgroup/TG-onboardingtasks/3039d19bcd035187",
            "TargetGroupName": "TG-onboardingtasks",
            "Protocol": "HTTP",
            "Port": 80,
            "VpcId": "vpc-0f62be6a",
            "HealthCheckProtocol": "HTTP",
            "HealthCheckPort": "traffic-port",
            "HealthCheckEnabled": true,
            "HealthCheckIntervalSeconds": 30,
            "HealthCheckTimeoutSeconds": 5,
            "HealthyThresholdCount": 5,
            "UnhealthyThresholdCount": 2,
            "HealthCheckPath": "/",
            "Matcher": {
                "HttpCode": "200"
            },
            "TargetType": "instance"
        }
    ]
}


