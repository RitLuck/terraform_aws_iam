# AWS IAM Policy Using Terraform.

## First, create the Provider.tf

Since we're using AWS, we'll use the AWS provider. More info about the AWS Provider can be found [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).

```terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/mnt/c/Users/gluckhun/OneDrive/my_workspace/aws/f_p/credentials"]
  profile                  = "terraform_user"

}
```

## Terraform init
The ```terraform init``` command initializes the working directory containing Terraform configuration files. After running the command, a directory named '.terraform' will appear. 

## Resource file 
All of our resources will be defined in the 'main.tf' file. For this demonstration, we will only be creating a user named 'Linux', and we will be using the `aws_iam_user` resource to do so. The `aws_iam_access_key` provides an IAM access key. This is a set of credentials that allow API requests to be made as an IAM user.

```
resource "aws_iam_user" "demo_user"  {
    name ="Linux"
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.demo_user.name
}
```

## Output file
The `output.tf` file contains all the data that I want to be displayed when I run `terraform apply`.
```
output "secret_key" {
    value = aws_iam_access_key.key.secret
    sensitive = true
}

output "access_key" {
    value = aws_iam_access_key.key.id
}
```

## Policy
The `policy.tf` file contains the `aws_iam_user_policy` resource. Although I could have added this resource to my `main.tf` file, I chose to keep it separate.
This resource provides an IAM policy attached to a user. As per the policy created `ListAllMyBuckets`, the user will only be able to view all s3 buckets available.

```
# Start by defining the resource and then a uniquely identify name (iam)
# Name of the policy is Demo_Policy
# Add user to that policy

resource "aws_iam_user_policy" "iam" {
  name = "Demo_Policy"
  user = aws_iam_user.demo_user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListAllMyBuckets*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

```

## Run Code
To begin, run the command `terraform validate`. If no issues are found, you are ready to proceed. Next, execute `terraform plan` to preview the actions that Terraform will perform. Finally, once you have confirmed that everything is in order, run `terraform apply --auto-approve` to apply the changes.


## View results
After the provisioning process is complete, you can confirm that the user has been created by accessing the AWS console. Alternatively, you can use the CLI to navigate to the user's details.
To get started, open your terminal and enter the command `aws configure` to set up your AWS CLI credentials. You will find your AWS Access Key ID and AWS Secret Access Key in the file `terraform.tfstate`. To confirm that the user has access to view the S3 buckets, run the command `aws s3 ls` in your terminal