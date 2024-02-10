# Operational Documentation

# Backups

This CrunchyDB templates include two types of backup, the default one being a Volume based backup on `netapp-file-backup` volume class. Additionally, the template supports use of S3 as a secondary backup location. 

## S3 Backup

To use the S3 backup, assuming you are using AWS, you will need: 

1. An IAM user created, take note of the users key and key secret.
2. The IAM user to have access to the bucket to which the backup will be saved to.

Once you have the user ready, all you need to do is pass the appropriate values to the s3 definition under `values.yaml`. Note that for the endpoint you need use region specific endpoints, for example s3.ca-central-1.amazonaws.com.

Note: DO NOT commit your IAM user key or secret key to your repository, but replace it at deploy time through your pipeline. Alternatively, you can pre-create the secret on OpenShift and set `pgBackRest.s3.createSecret` to `false`, make sure you update `pgBackRest.s3.s3Secret` to match the name of your created secret.

### BC Gov Public Cloud Setup

If you are using the BC Gov AWS Public Cloud service, you'll need to perform the following steps to get your IAM user created:

1. Create a new entry under DynamoDB Table `BCGOV_IAM_USER_TABLE`
2. A few minutes you'll be able to see your user under IAM.
3. Grant the appropiate permission to your bucket(s), by assigning it a permission policy, you will want to grant the following `"Action": ["s3:*"], "Effect": "Allow"`
4. To get the Key and Key Secret, visit the Parameter Store from your console and find `/iam-users/<YOUR_USERNAME_HERE>_keys

