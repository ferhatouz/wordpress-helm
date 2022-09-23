### This repo is used to deploy namespaces


# Usage: 

#### 1. Configure backend
```
bash setenv.sh
```

#### 2. Initialize terraform 
```
terraform  init 
```
#### 3. Create 
```
terraform apply    -var-file envs/dev.tfvars      
```