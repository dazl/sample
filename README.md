## Sample web service setup

The terraform code in this sample project will provision the basics:

 - auto scaling group (ASG)
 - load balancer (ELB)
 - servers with the latest ubuntu and nodejs and the user accounts
 - a sample DynamoDB table.

Searching the project for the string "myproject" and "TODO" shows where customization is required.

### Assumptions

 - compute: AWS EC2
 - OS: ubuntu
 - app servers: nodejs
 - persistence layer: DynamoDB for data, S3 for object storage
 - load balancing: AWS ELB
 - DNS: Route 53
 - provisioning tool: terraform
 - logging: cloudwatch logs (alternatives: third party such as loggly, sumologic, papertrail; or in house graylog cluster)
 - ssh access: each developer's public key is added to the machine at boot time via userdata. Each user has its own sudo-capable account, no credentials are shared.
 - health status: datadog and cloudwatch
 - tracing, optimization: AWS X-Ray

#### Using the latest packages:
 - Terraform is able to picke the latest Ububtu Xenial AMI
 - user-data updates the packages and installs the latest libraries
 - the ASG (auto scaling group) can be set to change the number of running instances daily with the side effect that packages will stay up to date. The specific strategy will depend on the needs. Simple example: once per day the number of instances can be doubled and then brought back to the previous number, this will effectively keep all packages updated.

#### Automation strategy:
 - terraform lets us provision our infrastructure in code. when a new service needs to be set up, an existing one can be cloned and modified as needed. Using variables for items such as service name, environment, instance count, etc. makes this process even faster.
 - When an existing service's infrastructure needs to be modified, terraform helps with change management.
 - terraform providers are available for many resources, including most of AWS resources (in our case: EC2 instances, ELB, ASG, DynamoDB tables, route 53 records) as well as other types of resources (relevant to this project: datadog monitors)

#### Further work that could be done in terraform includes:

 - add autoscaling policies
 - datadog monitors and alerts
 - switch to external ELB
 - switch to ALB for better integration with WAF
 - add dns zone and attach dns record to load balancer
 - add loggly configuration

#### Further work

 - caching layer: CDN such as cloudfront or fastly or server side such as redis and dynamodb accelerator (DAX)
