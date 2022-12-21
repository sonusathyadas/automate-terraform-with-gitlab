
# Deploy AWS resources using Terraform and GitLab

## Prerequisites
  
- AWS Credentials (Access key id and secret access key)
- GitLab account

## Steps 
1) Login to the GitLab account using the GitLab account credentials. 
2) Create a new project by clicking on the `New Project` button. Choose blank project template and specify the project name as `AWS-Terraform-Deploy`, visibility level as `Public`. Uncheck the `Initialize project with README` option from the `Project configuration` section and create project.
3) Open the Terraform project folder in terminal and run the following commands to initialize git and push the code to GitLab repository.

    ```bash
    git init
    git add .
    git commit -m "initial commit"
    git add remote origin <GITLAB-REPO-URL>
    git push -u origin --all
    ```

4) After pushing the terraform project files to GitLab repository, you need to create the environment variables for storing AWS credentials. Click on the **Settings > CI/CD** and expand the **Variables** section. 
5) Click on the `Add Variable` button and add the variable **AWS_ACCESS_KEY_ID** with your AWS access key ID. Save the variable by clicking on `Add variable` button. Repeat the same step to add **AWS_SECRET_ACCESS_KEY** variable with the secret access key value. Add one more variable to define the `workspace` name. Specify the variable name as **TF_WORKSPACE_NAME** and set **prod** or **dev** as its value.

6) Switch to the project folder and add `.gitlab-ci.yml` file in the root folder and add the following code to it.
    
    ```yml
    stages:
      - validate
      - plan
      - apply
    image:
      name: hashicorp/terraform:light
      entrypoint:
        - '/usr/bin/env'
        - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
    before_script:
      - export AWS_ACCESS_KEY=${AWS_ACCESS_KEY_ID}
      - export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - export WORKSPACE_NAME=${TF_WORKSPACE_NAME}
      - rm -rf .terraform
      - terraform --version
      - terraform init
      - terraform workspace select ${WORKSPACE_NAME} || terraform workspace new ${WORKSPACE_NAME}
    validate:
      stage: validate
      script:
        - terraform validate
    plan:
      stage: plan
      script:
        - terraform plan --var-file "${WORKSPACE_NAME}.tfvars"
      dependencies:
        - validate
      artifacts:
        paths:
          - planfile
    apply:
      stage: apply
      script:
        - terraform apply --var-file "${WORKSPACE_NAME}.tfvars" --auto-approve
      dependencies:
        - plan
      when: manual
    ```

7) The above code defines 3 stages for the continues deployment - validate, plan and apply.
It uses the `hashicorp/terraform:light` image to build and run the workflow and set the terraform path.

8) The `before_script` section is used to read the GitLab environment variables for AWS credentials and pass to the image environemnt variables. Similarly, it read the Terraform workspace name and set the environment variable. It also initilize the Terraform providers and create or select the workspace based on the environment variable name. 

9) The `validate` stage validates the terraform workflow and the `plan` stage executes the `terraform plan` command with the corresponding `.tfvars` file based on the workspace name. 

10) The `apply` stage runs the `terraform apply` command with the `.tfvars` file based on the workspace name. The `when:manual` attribute is used to define stage execution as manual.

11) Run the following commands to update the push the new file changes to GitLab repository. After you push it will automatically trigger the CI/CD pipeline execution.
    ```bash
    git add .
    git commit -m "CI/CD updated"
    git push -u origin --all
    ```

12) Switch to the GitLab console in browser and select the **CI/CD > Pipelines** section. It will show the status of the pipeline execution. The `validate` and `plan` stages will automatically run and wait for the manual approval for the `apply` stage. Click on the `Apply` stage and click on the play button to run the stage.

13) After the workflow execution completes you will see the resources deployed in the AWS environment.