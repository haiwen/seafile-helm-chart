# Seafile-Helm-Chart

This is a public repository for storing charts related to quick deployment of Seafile using ***Helm***.

## Deployment

### Preparation

- Create namespace

    ```
    kubectl create namespace seafile
    ```

- Create secret

    ```sh
    # for pro/cluster
    kubectl create secret generic seafile-secret --namespace seafile \
    --from-literal=JWT_PRIVATE_KEY='<required>' \
    --from-literal=SEAFILE_MYSQL_DB_PASSWORD='<required>' \
    --from-literal=INIT_SEAFILE_ADMIN_PASSWORD='<required>' \
    --from-literal=INIT_SEAFILE_MYSQL_ROOT_PASSWORD='<required>' \
    --from-literal=INIT_S3_SECRET_KEY=''  

    # for ce
    kubectl create secret generic seafile-secret --namespace seafile \
    --from-literal=JWT_PRIVATE_KEY='<required>' \
    --from-literal=SEAFILE_MYSQL_DB_PASSWORD='<required>' \
    --from-literal=INIT_SEAFILE_ADMIN_PASSWORD='<required>' \
    --from-literal=INIT_SEAFILE_MYSQL_ROOT_PASSWORD='<required>'  

    ```

    where `JWT_PRIVATE_KEY` can get from `pwgen -s 40 1`

## Install Seafile helm chart

- Copy and modify the `my-values.yaml` according to your configurations

    ```sh
    wget -O my-values.yaml https://haiwen.github.io/seafile-helm-chart/values/latest/cluster.yaml

    nano my-values.yaml
    ```

    The placeholder `<type of deployment>` can be `pro`, `ce` and `cluster`

>[!TIP]
>It is not necessary to use the `my-values.yaml` we provided (i.e., you can create an empty `my-values.yaml` and add required field, as others have defined default values in our chart), because it destroys the flexibility of deploying with Helm, but it contains some formats of how Seafile Helm Chart reads these configurations, as well as all the environment variables and secret variables that can be read directly.

- To install the chart use the following:

    ```sh
    helm repo add seafile https://haiwen.github.io/seafile-helm-chart/repo
    helm upgrade --install seafile seafile/<type of deployment>  --namespace seafile --create-namespace --values my-values.yaml
    ```

>[!TIP]
>- The default service type of Seafile is `LoadBalancer`, and `Nginx-ingress` is not integrated because it is [outdated](https://kubernetes.io/docs/concepts/services-networking/ingress/) in the new *Kubernetes* version, and new features are being added to the [Gateway API](https://kubernetes.io/docs/concepts/services-networking/gateway/). So you should specify *K8S load balancer* for *Seafile* or specify at least one external ip, that can be accessed from external networks.
>- After the first-time startup, you can remove all initial variables (i.e., `INIT_*`) and set `initMode` to `false`.

>[!NOTE]
>- For `pro` edition, you should modify the hostname of ***Memcached*** and ***Elasticsearch*** after first-time startup according to [here](https://manual.seafile.com/latest/setup/k8s_single_node/#start-seafile-server), then restart the instances by 
>   ```sh
>   kubectl delete pod seafile -n seafile
>   ```
>- For `cluster`, you should disable `initMode` (i.e., set to `false`) after first-time startup, then upgrade the chart:
>   ```sh
>   helm upgrade seafile seafile/cluster  --namespace seafile  --values my-values.yaml
>   ```

## Version Control

The version of *Seafile Helm Chart* is same as the major version of *Seafile*, i.e.:

- latest Seafile: 12.0.9
- latest Seafile Helm Chart: 12.0

By default, it will follow the latest Chart and the latest Seafile. If you want to use a different version of Seafile, you can use the following command to control the version:

```sh
helm upgrade --install seafile seafile/<type of deployment>  --namespace seafile --create-namespace --values my-values.yaml --version 12.0
```

and rollback to old version by:

```sh
helm rollback seafile -n seafile <revision>
```

## Uninstall Seafile Helm Chart

```sh
helm delete seafile --namespace seafile
```
