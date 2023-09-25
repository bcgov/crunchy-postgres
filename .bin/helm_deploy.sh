#!/bin/bash
set -euo pipefail

usage() {
    cat << EOF
$0 [OPTIONS]

Deploys the helm chart that contains secrets

A value file needs to be passed in with the information required by the templates.
(see the values.yaml file provided for an example)

The list of namespaces affected by the script is defined by the
"--project-prefixes" and "--project-suffixes" options (see below).
For instance, "--project-prefixes abc123,456qwe --project-suffixes dev,test"
would affect the following namespaces: abc123-dev, abc123-test, 456qwe-dev and 456qwe-test

Maintainer: Pierre Bastianelli <pierre.bastianelli@gov.bc.ca>
https://github.com/bcgov/cas-pipeline
https://github.com/bcgov/cas-pipeline/blob/master/lib/helm_deploy.sh

Options:

  -pp, --project-prefixes
    The comma-separated project prefixes where the secret will be added. e.g. "abc123,456qwe"
  -ps, --project-suffixes
    The comma-separated project suffixes where the secret will be added. Defaults to "tools,dev,test,prod"
  -c, --chart-directory
    The path to the directory containing the chart to install
  -n, --chart-name
    The name of the chart to install
  -v, --values-file
    The values file to use for the helm chart installation, see $(./helm/cas-provision/templates/values.yaml).
  --dry-run
    Calls the helm install script with the --dry-run option
  -h, --help
    Prints this message


EOF
}

# default options
dry_run=""
declare -a suffixes=("tools" "dev" "prod")

while [[ -n ${1+x} && "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -pp | --project-prefixes )
    shift
    IFS=',' read -r -a prefixes <<< "$1"
    ;;
  -ps | --project-suffixes )
    shift
    IFS=',' read -r -a suffixes <<< "$1"
    ;;
  -c | --chart-directory )
    shift
    chart_path=$1
    ;;
  -n | --chart-name )
    shift
    chart_name=$1
    ;;
  -v | --values-file )
    shift
    values_file=$1
    ;;
  --dry-run )
    dry_run="--dry-run"
    ;;
  -h | --help )
    usage
    exit 0
    ;;
esac; shift; done



for prefix in "${prefixes[@]}"; do
  for suffix in "${suffixes[@]}"; do

    namespace=$prefix-$suffix
    echo "Creating helm installation in $namespace namespace"
    helm upgrade --install --atomic -f "$values_file" -n "$namespace" $dry_run "$chart_name" "$chart_path" --set provisioner.namespace=$prefix-tools

  done
done

