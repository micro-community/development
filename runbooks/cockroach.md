# Cockroach

## Backups
Our Kubernetes cluster has a cron job which will dump Cockroach and push to S3 every hour. You can find the code for this [here](https://github.com/m3o/services/tree/master/cockroachdb/backup).

## Restore
If you need to restore Cockroach from a backup you can do this by running the Kubernetes pod defined [here](https://github.com/m3o/services/tree/master/cockroachdb/restore) on a fresh Cockroach cluster. When the pod runs, it will download the latest dump file from S3 and apply to the cluster. Once complete, don't forget to delete the pod.
1. `kubectl apply -f cockroach-restore.yaml`
2. `kubectl delete po cockroach-restore`