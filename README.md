# Crunchy Postgres helm chart

A tested helm chart for Crunchy Postgres

## Release Process (WIP)

After you have made changes to a chart and are ready to release a new version you must bump the version in the `chart.yaml` file so the [chart releaser action](https://github.com/helm/chart-releaser-action) knows to publish a new version.

Once that is approved and merged you must tag and push the tag for the action to publish the release. The release workflow will automatically create a release for the updated chart as well as publish a separate release with an archive of the raw yaml files for those who don't want to use helm.

```
git checkout main
git tag -a crunchy-postgres-raw-yaml-v.0.2.0 -m "Release v0.2.0"
git push --tags
```

## Raw YAML files

An archive of the latest releases raw YAML files can be found in the [releases](https://github.com/bcgov/crunchy-postgres/releases) section.

Alternatively you can save them with the [helm template](https://helm.sh/docs/helm/helm_template/) command:

`helm template -f charts/tools/values-repo.yaml --output-dir yaml charts/crunchy-postgres`
`helm template -f charts/tools/values-provision.yaml --output-dir yaml charts/tools`

## Contact Info

[#crunchydb on Rocket.Chat](https://chat.developer.gov.bc.ca/channel/crunchydb)

## Vendor Info

[PGO, the Postgres Operator from Crunchy Data](https://access.crunchydata.com/documentation/postgres-operator/v5/)

```

```
