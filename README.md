# Crunchy Postgres helm chart

A tested helm chart for Crunchy Postgres

## Charts

### Crunchy Postgres chart

A chart to deploy a high availability Crunchy Postgres cluster

#### Add chart to dependencies in your chart.yaml:

```
dependencies:
  - name: crunchy-postgres
    version: 0.5.0
    repository: https://bcgov.github.io/crunchy-postgres/
```

#### Values are located in the documentation here:

[Crunchy Postgres Documentation](charts/crunchy-postgres/README.md)

### Crunchy Postgres tools chart

A set of standard service accounts and networking templates that were needed to deploy a Crunchy Postgres cluster but are kept separate from the main Crunchy Postgres chart.

#### Add chart to dependencies in your chart.yaml:

```
dependencies:
  - name: crunchy-postgres-tools
    version: 0.3.0
    repository: https://bcgov.github.io/crunchy-postgres/
```

#### Values are located in the documentation here:

[Crunchy Postgres Tools Documentation](charts/tools/README.md)

## Release Process (WIP)

After you have made changes to a chart and are ready to release a new version you must bump the version in the `chart.yaml` file so the [chart releaser action](https://github.com/helm/chart-releaser-action) knows to publish a new version.

Once that is approved and merged you must tag and push the tag for the action to publish the release. The release workflow will automatically create a release for the updated chart as well as publish a separate release with an archive of the raw yaml files for those who don't want to use helm.

```
git checkout main
git tag -a crunchy-postgres-raw-yaml-v.0.2.0 -m "Release v0.2.0"
git push --tags
```

## Raw YAML files

An archive of the latest releases raw YAML files can be found in the [releases](https://github.com/bcgov/crunchy-postgres/releases) section. These are bundled together unlike the Helm charts which are released separately.

Alternatively you can save them with the [helm template](https://helm.sh/docs/helm/helm_template/) command:

`helm template --output-dir yaml charts/crunchy-postgres`

`helm template --output-dir yaml charts/tools`

## Contact Info

[#crunchydb on Rocket.Chat](https://chat.developer.gov.bc.ca/channel/crunchydb)

## Vendor Info

[PGO, the Postgres Operator from Crunchy Data](https://access.crunchydata.com/documentation/postgres-operator/v5/)

## Current Compatible Images

You are encouraged to use the `postgresVersion` and `postGISVersion` values in the values.yaml file to specify your chosen version information instead of using the `crunchyImage` value to specify a specific image.

Currently, the operator is on version 5.5.1, and the following values are valid for use with `postgresVersion` and `postGISVersion`, alongside their image tags:

-  `postgresVersion: 14` - `crunchy-postgres:ubi8-14.11-0`
- - `postGISVersion: 3.1` - `crunchy-postgres-gis:ubi8-14.11-3.1-0`
- - `postGISVersion: 3.2` - `crunchy-postgres-gis:ubi8-14.11-3.2-0`
- - `postGISVersion: 3.3` - `crunchy-postgres-gis:ubi8-14.11-3.3-0`
-  `postgresVersion: 15` - `crunchy-postgres:ubi8-15.6-0`
- - `postGISVersion: 3.3` - `crunchy-postgres-gis:ubi8-15.6-3.3-0`
-  `postgresVersion: 16` - `crunchy-postgres:ubi8-16.2-0`
- - `postGISVersion: 3.3` - `crunchy-postgres-gis:ubi8-16.2-3.3-0`
- - `postGISVersion: 3.4` - `crunchy-postgres-gis:ubi8-16.2-3.4-0`

Only the image name and tag were listed above for readability. The full URL is `artifacts.developer.gov.bc.ca/bcgov-docker-local/[image]:[tag]`
