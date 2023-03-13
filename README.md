# Static application hosting automation.

* This repo contains IAC(using Terraform) codes for infrastructure for a static website hosted in AWS S3 and served using AWS Cloudfront CDN. A free SSL is setup for the CDN URL and http traffic will be redirected to https.

* static website hosting is setup using Terraform and it will provide a temporary URL for the static website.

* Terraform states are stored in S3 bucket and mention the correct bucket name in the main.tf

* Parameters related to this project is stored in the file "static-hosting-vars.tfvars". Review and modify the parameters if needed.

* connect the aws cli using the access key and secret access key, then initiate terraform and apply the changes.

### To initialize the project,

```
terraform init
```

### To validate the correctness of the server configuration,

```
terraform validate
```

### To plan or show the infra changes,

```
terraform plan -var-file=static-hosting-vars.tfvars
```

### To apply the infra changes,

```
terraform apply -var-file=static-hosting-vars.tfvars
```

### Terraform output will display the CDN domain name. Now point the domain to this CDN from the DNS.

```
terraform output
```

### To delete all resources created using this tool,

```
terraform destroy -var-file=static-hosting-vars.tfvars
```

# Future possible improvements.

* It is possible to set our own custom domain name for this static hosting. Domain name can be added as an alias in the cloudfront CDN and update the domain's DNS to point to the cloudfront.

* Free SSL can be registered in the ACM(AWS Certificate Manager) for the custom domain.

* DNS for the domain can be managed in the Route53 service.

* All the above mentioned points can be automated using the Terraform.

* As the S3 and CDN services are highly scalable, highly available and fast, it helps our application to support high traffic.
