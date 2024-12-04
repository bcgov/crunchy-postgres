# Troubleshooting Crunchy PostgreSQL in OpenShift for BCGov

## Common Issues and Solutions

### 1. Stanza Not Created
- **External Backup(s3)**: Check the postgres cluster configuration and see if it is pointing to backup location of another cluster. Sometimes there is versioning enabled on buckets, so even if the bucket is deleted there could be older version which would not let the stanza be created.


### 2. Backup Failures
- **Backup Logs**:  Check the logs of the cronjobs, if it says error code 39, it could be due to either Memory limitations or storage limitations, check if the pgabckrest container within the statefulset is getting oomkilled, if not check if enough pvc available to the backup.

### 3. Accessing Database
- **Primary**: The primary pod cannot be accessed outside of the cluster, only `oc exec` commands can be executed against it. Or The commands can be executed by directly going to the pod terminal within openshift console.
- **Readonly**: The readonly replica can be accessed using service endpoint using `oc port-forward service/<replica_service_name>`.
- **Pgbouncer**: PG Bouncer is required to access the primary pod (read/write) from local machine by port forwarding to pgbouncer service. `oc port-forward service/<pgbouncer_service_name>`. Pgbouncer will only accept connection for non-superusers. if the app user is a superuser, create another non super user and provide access to the database, so that you can access it from PGadmin in local system.
Ex: 
``` yaml
  users:
    - name: app
      databases:
        - app
      options: "SUPERUSER CREATEDB CREATEROLE"
    - name: postgres
      databases:
        - postgres
        - app
    - name: appproxy # this user lets dev connect to postgres via pgbouncer from local system
      databases:
        - app
        - postgres
```

## Useful Commands

- **Get Pod Logs**: `oc logs <pod-name>`
- **Describe Cluster**: `oc describe PostgresCluster/<cluster-name>`


## Additional Resources

- [Crunchy PostgreSQL Documentation](https://access.crunchydata.com/documentation/)
- [OpenShift Documentation](https://docs.openshift.com/)
- [BCGov DevHub](https://developer.gov.bc.ca/)
