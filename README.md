# Matomo

Installs the web analytics application [Matomo](https://matomo.com).

## TL;DR;

```sh
helm install stable/matomo
```

## Introduction

This chart bootstraps a [Matomo](https://matomo.org) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```sh
helm install --name my-release stable/matomo
```

The command deploys `matomo` on the Kubernetes cluster in the default configuration.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```sh
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters and their default values.

| Parameter                  | Description                                      | Default                               |
|----------------------------|--------------------------------------------------|---------------------------------------|
| `replicas`                 | Number of nodes                                  | `1`                                   |
| `persistence.enabled`      | Enable persistence using PVC                     | `true`                                |
| `persistence.storageClass` | PVC Storage Class for Matomo volume              | `nil` (uses alpha storage annotation) |
| `persistence.accessMode`   | PVC Access Mode for Matomo volume                | `ReadWriteOnce`                       |
| `persistence.size`         | PVC Storage Request for Matomo volume            | `10Gi`                                |
| `persistence.path`         | Path to mount the volume at, to use other images | `/var/www/html`                       |
| `matomo.install`           | Enable the installation wizard                   | `false`                               |
| `matomo.secret`            | Secret with the credentials for Matomo           | ``                                    |

For more information please refer to the [Matomo](https://matomo.org/docs/) documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```sh
helm install --name my-release \
  --set "phpFpm.scrapeUri=tcp://myphp-fpm:9000/status" \
    stable/matomo
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```sh
helm install --name my-release -f ./values.yaml stable/matomo
```

## Credentials

Copy the `.example.env` in the repository, filling in with your credentials:

```sh
cp ./.example.env ./.env
vi .env
```

Then deploy the secret with

```sh
eval "`sed 's/^/export /g' ./.env`" && cat ./config/secret.generator.yaml | envsubst | kubectl apply -f -
```
