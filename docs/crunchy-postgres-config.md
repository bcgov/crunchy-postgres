# Crunchy postgres helm chart

## Config

| Parameter                         | Description                         | Default                                                                            |
| --------------------------------- | ----------------------------------- | ---------------------------------------------------------------------------------- |
| `fullnameOverride`                | Replace the generated name          | `crunchy-postgres`                                                                 |
| `deployer.serviceAccount.enabled` | Enable the deployer service account | `false`                                                                            |
| `crunchyImage`                    | crunchy-postgres image              | `artifacts.developer.gov.bc.ca/bcgov-docker-local/crunchy-postgres:centos8-14.1-0` |
| `postgresVersion`                 | Postgresql version                  | `14`                                                                               |

### Networking:

| Parameter                             | Description                                                                          | Default |
| ------------------------------------- | ------------------------------------------------------------------------------------ | ------- |
| `networking.networkPolicy.enabled`    | Network policy to allow traffic from outside the namespace                           | `false` |
| `networking.podNetworkPolicy.enabled` | Pod network policy to allow pods to accept traffic from other pods in this namespace | `false` |
| `networking.route.enabled`            | Enable the route                                                                     | `false` |
| `networking.route.host`               |                                                                                      | ``      |
| `networking.networkPolicy.enabled`    |                                                                                      | `false` |

### User Interface pgAdmin 4

Important: This requires [PGO v5.1.0](https://access.crunchydata.com/documentation/postgres-operator/v5/releases/5.1.0/)

It needs a route to be set as well as networkPolicy to be enabled to allow ingress to the interface
Port forwarding is enabled with userInterface and is required to access the dashboard at `<route.host>:5050`

| Parameter                                                        | Description               | Default                                                                           |
| ---------------------------------------------------------------- | ------------------------- | --------------------------------------------------------------------------------- |
| `userInterface.enabled`                                          | Enable the user interface | `false`                                                                           |
| `userInterface.pgAdmin.image`                                    | pgAdmin 4 image           | ` artifacts.developer.gov.bc.ca/bcgov-docker-local/crunchy-pgadmin4:ubi8-4.30-10` |
| `userInterface.dataVolumeClaimSpec.accessModes`                  |                           | `ReadWriteOnce`                                                                   |
| `userInterface.dataVolumeClaimSpec.accessModes.requests.storage` |                           | `256Mi`                                                                           |

### PG Monitor

| Parameter                   | Description               | Default                                                                                   |
| --------------------------- | ------------------------- | ----------------------------------------------------------------------------------------- |
| `pgmonitor.enabled`         | Enable PG Monitor         | `false`                                                                                   |
| `pgmonitor.exporter.image`  | PG Monitor exporter image | `artifacts.developer.gov.bc.ca/bcgov-docker-local/crunchy-postgres-exporter:ubi8-5.0.4-0` |
| `pgmonitor.requests.cpu`    | CPU requests              | `1m`                                                                                      |
| `pgmonitor.requests.memory` | Mmory requests            | `64Mi`                                                                                    |
| `pgmonitor.limits.cpu`      | CPU limits                | `50m`                                                                                     |
| `pgmonitor.limits.memory`   | Memory limits             | `128Mi`                                                                                   |

### Instances

| Parameter                                            | Description                        | Default                   |
| ---------------------------------------------------- | ---------------------------------- | ------------------------- |
| `instances.name`                                     | Instance name                      | `ha` (high availability ) |
| `instances.replicas`                                 | Number of replicas in stateful set | `3`                       |
| `instances.dataVolumeClaimSpec.storage`              | Stateful set PVC size              | `256Mi`                   |
| `instances.requests.cpu`                             | CPU requests                       | `1m`                      |
| `instances.requests.memory`                          | Memory requests                    | `256Mi`                   |
| `instances.limits.cpu`                               | CPU limits                         | `50m`                     |
| `instances.limits.memory`                            | Memory limits                      | `512Mi`                   |
| `instances.sidecars.replicaCertCopy.requests.cpu`    | CPU requests                       | `1m`                      |
| `instances.sidecars.replicaCertCopy.requests.memory` | Memory requests                    | `32Mi`                    |
| `instances.sidecars.replicaCertCopy.limits.cpu`      | CPU limits                         | `50m`                     |
| `instances.sidecars.replicaCertCopy.limits.memory`   | Memory limits                      | `64Mi`                    |

### pgBackRest

| Parameter                                | Description                                  | Default                                                                              |
| ---------------------------------------- | -------------------------------------------- | ------------------------------------------------------------------------------------ |
| `pgbackrest.image`                       | pgBackrest image                             | `artifacts.developer.gov.bc.ca/bcgov-docker-local/crunchy-pgbackrest:centos8-2.36-0` |
| `pgbackrest.retention`                   | Retention count or time                      | `30`                                                                                 |
| `pgbackrest.retentionFullType`           | Type of retention, accepts 'count' or 'time' | `count`                                                                              |
| `pgbackrest.repos.schedules.full`        | Schedule for full backups                    | ` 0 8 * * *`                                                                         |
| `pgbackrest.repos.schedules.incremental` | Schedule for incremental backups             | `0 0,4,12,16,20 * * *`                                                               |
| `pgbackrest.repos.volume.accessModes`    | Volume access modes                          | `"ReadWriteOnce"`                                                                    |
| `pgbackrest.repos.s3.enabled`            | Enable S3 backups                            | `false`                                                                              |
| `pgbackrest.repos.s3.bucket`             | S3 bucket                                    |                                                                                      |
| `pgbackrest.repos.s3.endpoint`           | pS3 endpoint                                 |                                                                                      |
| `pgbackrest.repos.s3.region`             | S3 region                                    |                                                                                      |

#### pgBackrest cloud object storage backups

Important: This requires [PGO v5.0.5](https://access.crunchydata.com/documentation/postgres-operator/v5/releases/5.0.5/)

| Parameter                          | Description          | Default |
| ---------------------------------- | -------------------- | ------- |
| `pgbackrest.repos.s3.enabled`      | Enable S3 backups    | `false` |
| `pgbackrest.repos.s3.bucket`       | S3 bucket            |         |
| `pgbackrest.repos.s3.endpoint`     | S3 endpoint          |         |
| `pgbackrest.repos.s3.region`       | S3 region            |         |
| `pgbackrest.repos.gcs.enabled`     | Enable GCS backups   | `false` |
| `pgbackrest.repos.gcs.bucket`      | GCS bucket           |         |
| `pgbackrest.repos.azure.enabled`   | Enable Azure backups | `false` |
| `pgbackrest.repos.azure.container` | Azure container      |         |

### Patroni

| Parameter                                              | Description                        | Default                       |
| ------------------------------------------------------ | ---------------------------------- | ----------------------------- |
| `patroni.postgresql.pg_hba`                            | pg_hba access policy configuration | `host all all 0.0.0.0/0 md5"` |
| `patroni.postgresql.parameters.shared_buffers`         | shared buffers                     | `16MB`                        |
| `patroni.postgresql.parameters.wal_buffers`            | wal buffers                        | `-1`                          |
| `patroni.postgresql.parameters.min_wal_size`           | Minimum wal size                   | `32MB`                        |
| `patroni.postgresql.parameters.max_wal_size`           | Maximum wal size                   | `128MB`                       |
| `patroni.postgresql.parameters.max_slot_wal_keep_size` | Max wal keep size                  | `256MB`                       |

### Proxy

| Parameter                         | Description        | Default                                                                             |
| --------------------------------- | ------------------ | ----------------------------------------------------------------------------------- |
| `proxy.pgBouncer.image`           | pgBouncer image    | `artifacts.developer.gov.bc.ca/bcgov-docker-local/crunchy-pgbouncer:centos8-1.16-0` |
| `proxy.pgBouncer.replicas`        | pgBouncer replicas | `2`                                                                                 |
| `proxy.pgBouncer.requests.cpu`    | CPU requests       | `2m`                                                                                |
| `proxy.pgBouncer.requests.memory` | Memory requests    | `16Mi`                                                                              |
| `proxy.pgBouncer.limits.memory`   | CPU limits         | `50m`                                                                               |
| `proxy.pgBouncer.limits.memory`   | Memory limits      | `32Mi`                                                                              |
