# Stateful application backup/restore (mysql)

* we are using a Deployment controller instead of a DeploymentConfig.
* we are adding a dummy database to the mysql pod.
* we are leveraging openshift-velero-plugin and a custom restic-restore-helper image.

The persistent case assumes the existence of the storageclass "example-nfs".

Modify the PersistentVolumeClaim: spec.storageClassName appropriately at `mysql-persistent/mysql-persistent-template.yaml`.

## Create stateful mysql Deployment:
```
oc create -f mysql-persistent/mysql-persistent-template.yaml
```

## Create a table in the database.
```
oc rsh -n mysql-persistent $mysql-pod

mysql -u root -p
<Enter>

create database menagerie;
use menagerie;
CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20), species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);

quit

# Reference:
https://dev.mysql.com/doc/refman/8.0/en/creating-tables.html

```
