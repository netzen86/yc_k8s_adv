# yc_k8s_adv
For Yandex cloud k8s advanced course


## for init enviroment

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_ZONE=$(yc config get compute-default-zone)

export TF_VAR_folder_id=$YC_FOLDER_ID
export TF_VAR_default_zone=$YC_ZONE
```

## init tf backend

`terraform init -backend-config=backend.conf`