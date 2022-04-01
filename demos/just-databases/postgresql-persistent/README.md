# Stateful application backup/restore (PostgreSQL)

The persistent case assumes the existence of the storageclass "gp2" --
modify appropriately if this is incorrect for your cluster. This setup assumes you have KUBECONFIG properly configured.

## For installing missing modules
(for python3)
```
pip3 install kubernetes
pip3 install openshift
```

## Create stateful PostgreSQL deployment:
```
ansible-playbook postgres-install.yaml
```
Switch to postgresql-persistent namespace.
```
oc project postgresql-persistent
```


## For installing/deleting specific resources(Pods, Service, Deployment etc..)
Run the following command by replacing tags with suitable tag name as mentioned in yaml
```
ansible-playbook postgres-install.yaml --tags "tagname(s)"

```
## For logging into the postgres database
For host value to pass to psql, use the CLUSTER-IP of the service. To get that do

```
oc get svc
```
For logging in
user/pass=admin/password
```
oc rsh pgbench
oc exec -it pgbench bash
psql -U admin -W sampledb -h 172.30.87.66
```

## Populate a sample database
Login using the above commands to the database.
To create a table and populate data in it, run the following
```
sampledb=> CREATE TABLE TEMP(id INTEGER PRIMARY KEY, name VARCHAR(10));
sampledb=> INSERT INTO TEMP VALUES(1,'alex');
```
To check if the data was populated and table created, do
```
sampledb=> SELECT * FROM TEMP;
sampledb=> \dt
```
The output of the table should be like this
```
 id | name
----+------
  1 | alex

```

