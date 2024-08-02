# test-aws-eks-cluster

Pre-requisites: 

1. Firstly, i have created the oidc provider for github to assume role for the AWS cloud authentication, in IAM, also attached the required policies to assume role on the github repo.

   <img width="1449" alt="image" src="https://github.com/user-attachments/assets/7dc54f26-df04-4dfc-9865-dd3741e4ea06">


   <img width="1449" alt="image" src="https://github.com/user-attachments/assets/68194e3a-d1a1-41ed-9d14-61336259919b">

3. In my pipeline, i have first added the oidc provider authentication check so that we can proceed with our pipeline build. 
4. Created the S3 bucket as the backend to store the terraform state file
5. Created the ECR repository to store the docker images, to be used later for application deployments in EKS. 
6. Setup the sonar project in the sonarcloud.io for code coverage. 
   Also configured custom Quality gate to meet the requested code coverage of 85%. Please find the screenshot below. 


![image](https://github.com/user-attachments/assets/13a29df6-5e94-4c5e-ac6f-2cd9cdd401a1)



Implementation:

In the EKS folder, i have added the terraform code for the eks cluster creation and alb ingress controller.

Once the terraform.yml file from repository .github/workflows is triggered, it will download the modules required and provision the EKS cluster and also the ALB ingress controller, with the required roles and policies. 


Note:  I was unable to create the ALB while provisioning the ALB ingress controller, while debugging, noticed that with the module used , i could see the below error. 



{"namespace":"default","error":"AccessDenied: User: arn:aws:sts::210613553230:assumed-role/aws-load-balancer-controller/1722548827773681707 is not authorized to perform: elasticloadbalancing:AddTags on resource: arn:aws:elasticloadbalancing:us-east-2:210613553230:targetgroup/k8s-default-echoserv-f19a4ba037/* because no identity-based policy allows the elasticloadbalancing:AddTags action\n\tstatus code: 403, request id: 4049cf19-5f0a-425f-af01-0944bef92e18"}


As per the error , it was not having the elasticloadbalancing:AddTags permissions attached to policy. 

I have then appended the  inline policy at the line number - https://github.com/ehteshamkhaja/test-aws-eks-cluster/blob/master/eks/helm-load-balancer-controller.tf#L16 to fix the issue. 


Once the policy is added, i was able to see the logs in the alb controller pod, with the target groups detected after the application deployment is completed ( dependency on ingress), from the separate repository maintained for app build and deploy. 



