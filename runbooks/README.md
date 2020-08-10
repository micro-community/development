# Runbooks

This document is a set of runbooks for various parts of the M3O system and should act as an operations manual for things like outages etc.

Table of Contents
=================

   * [Runbooks](#runbooks)
   * [Users](#users)
      * [Add new user to beta](#add-new-user-to-beta)
   * [Cockroach](#cockroach)
      * [Backups](#backups)
      * [Restore](#restore)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# Users
## Add new user to beta
Users need to have their email added to the "allow" list of the invite service. 
```
micro invite create --email="me@domwong.com"
```

# Cockroach

## Backups
Our Kubernetes cluster has a cron job which will dump Cockroach and push to S3 every hour. You can find the code for this [here](https://github.com/m3o/services/tree/master/cockroachdb/backup).

## Restore
If you need to restore Cockroach from a backup you can do this by running the Kubernetes pod defined [here](https://github.com/m3o/services/tree/master/cockroachdb/restore) on a fresh Cockroach cluster. When the pod runs, it will download the latest dump file from S3 and apply to the cluster. Once complete, don't forget to delete the pod.
1. `kubectl apply -f cockroach-restore.yaml`
2. `kubectl delete po cockroach-restore`

