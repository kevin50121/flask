#!/bin/bash

#Shell: For Building backend ECS-Service with aws cli

# create ECS cluster
aws ecs create-cluster --cluster-name kevin_onboardingtasks_flask

# create ecs instance for kevin_onboardingtasks_flask (Launch an Instance and use ecsInstanceRole & user-data.txt)
aws ec2 run-instances --image-id ami-04e47a1e7ce1d448a --count 1 \
--instance-type t2.micro --key-name kevin_test \
--user-data file:///Users/kevinwang/Desktop/awscli/User-data.txt \
--subnet-id subnet-fdd98abb  \
--security-group-ids sg-bc40ddd9 \
--iam-instance-profile Name=ecsInstanceRole \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ECS Instance - EC2ContainerService-kevin-flask}]'

# Create a alb for ECS cluster kevin_onboardingtasks
Arn_LoadbalancerArn=`aws elbv2 create-load-balancer --name ALB-Onboardingtasks-flask \
--subnets subnet-fdd98abb subnet-2b0fad5c --security-groups sg-bc40ddd9 \
| jq -r '.LoadBalancers[].LoadBalancerArn'`

echo $Arn_LoadbalancerArn

#Create target group for ALB-Onboardingtasks
Arn_TargetGroups=`aws elbv2 create-target-group --name TG-onboardingtasks --protocol HTTP --port 80 \
--vpc-id vpc-0f62be6a | jq -r '.TargetGroups[].TargetGroupArn'`

echo $Arn_TargetGroups

#Create listener for ALB-Onboardingtasks (forwarding http traffic) 
aws elbv2 create-listener \
--load-balancer-arn $Arn_LoadbalancerArn \
--protocol HTTP \
--port 80 \
--default-actions Type=forward,TargetGroupArn=$Arn_TargetGroups \

#Create listener for ALB -Onboardingtasks (forwarding https traffic)
#aws elbv2 create-listener --load-balancer-arn loadbalancer-arn \
#--protocol HTTPS --port 443  \
#--certificates CertificateArn=certificate-arn \
#--default-actions Type=forward,TargetGroupArn=targetgroup-arn

#Create task definition for ECS -register (port mapping:none?)
aws ecs register-task-definition --cli-input-json file:///Users/kevinwang/Desktop/awscli/Taskdef.json

#Create Service for ECS-clusters 

aws ecs create-service --service-name kevin_onboardingtasks_flask --cluster kevin_onboardingtasks_flask \
 --task-definition kevin_onboardingtasks_flask \
 --desired-count 1 \
 --load-balancers \
 \[\{\"targetGroupArn\":\"$Arn_TargetGroups\",\"containerName\":\"kevin_onboardingtasks_flask\",\"containerPort\":5000\}\] \
 --role ecsServiceRole

#Create new revision for your task ,and update your service
#aws ecs update-service --cluster kevin_onboardingtasks_flask --service kevin_onboardingtasks_flask --task-definition kevin_onboardingtasks_flask:7
#List task that is running
#aws ecs list-tasks --service kevin_onboardingtasks










