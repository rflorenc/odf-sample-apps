#!/usr/bin/env bash

noobaa_namespace=openshift-storage
logfile=/tmp/noobaa_uninstall.log

oc patch bucketstore -n ${noobaa_namespace} --type=merge -p '{"metadata":{"finalizers":null}}' noobaa-default-bucket-store;
oc patch bucketclass -n ${noobaa_namespace} --type=merge -p '{"metadata":{"finalizers":null}}' noobaa-default-bucket-class;
oc patch noobaa -n ${noobaa_namespace} --type=merge -p '{"metadata":{"finalizers":null}}' noobaa;
oc -n ${noobaa_namespace} patch storagecluster --type=merge -p '{"metadata":{"finalizers":null}}' ocs-storagecluster;

for resource in cephblockpoolusers cephblockpool cephcluster cephfilesystem storagecluster storagesystem;
do
  oc -n ${noobaa_namespace} patch $resource --type=merge -p '{"metadata":{"finalizers":null}}' ocs-storagecluster-${resource};
done

for pvc in `oc get pvc -o jsonpath='{.items[*].metadata.name}' -n ${noobaa_namespace}`;
do
  oc patch pvc -n ${noobaa_namespace} --type=merge -p '{"metadata":{"finalizers":null}}' $pvc;
done

for pod in `oc get pods -o jsonpath='{.items[*].metadata.name}' -n ${noobaa_namespace}`;
do
	oc patch pod -n ${noobaa_namespace} --type=merge -p '{"metadata":{"finalizers":null}}' $pod;
	oc delete pod noobaa-db-pg-0 --force --grace-period=0;
done

echo rm -v ${logfile}
rm -v ${logfile}

echo noobaa uninstall --cleanup=true -n ${noobaa_namespace}
noobaa uninstall --cleanup=true -n ${noobaa_namespace} >> ${logfile} 2>&1
