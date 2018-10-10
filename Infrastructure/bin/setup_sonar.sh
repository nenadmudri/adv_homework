#!/bin/bash
# Setup Sonarqube Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Sonarqube in project $GUID-sonarqube"

# Code to set up the SonarQube project.
# Ideally just calls a template
# oc new-app -f ../templates/sonarqube.yaml --param .....

# To be Implemented by Student

#oc new-app -f ./Infrastructure/templates/sonarqube-postgresql-template.yaml --param=SONARQUBE_IMAGE=docker.io/wkulhanek/sonarqube \
 # --param=SONARQUBE_VERSION=7.3 \
  #-n "${GUID}-sonarqube"

oc new-app -f ./Infrastructure/templates/postgres_sonarqube_template.yaml\
  --param POSTGRESQL_USERNAME=sonar\
  --param POSTGRESQL_PASSWORD=sonar\
  --param POSTGRESQL_DATABASE=sonar\
  --param POSTGRESQL_VOLUME=1Gi\
  --param GUID=$GUID\
  -n $GUID-sonarqube
  
oc policy add-role-to-user edit system:serviceaccount:$GUID-jenkins:jenkins -n $GUID-sonarqube
oc policy add-role-to-user edit system:serviceaccount:gpte-jenkins:jenkins -n $GUID-sonarqube

#oc process -f Infrastructure/templates/sonar-template.yaml -n ${GUID}-sonarqube -p GUID=${GUID} | oc create -n ${GUID}-sonarqube -f -

#oc project $GUID-sonarqube
# oc policy add-role-to-user edit system:serviceaccount:gpte-jenkins:jenkins -n $GUID-sonar

#oc new-app --template=postgresql-persistent --param POSTGRESQL_USER=sonar --param POSTGRESQL_PASSWORD=sonar --param POSTGRESQL_DATABASE=sonar --param VOLUME_CAPACITY=4Gi --labels=app=sonarqube_db

#oc new-app --docker-image=wkulhanek/sonarqube:6.7.4 --env=SONARQUBE_JDBC_USERNAME=sonar --env=SONARQUBE_JDBC_PASSWORD=sonar --env=SONARQUBE_JDBC_URL=jdbc:postgresql://postgresql/sonar --labels=app=sonarqube

#oc rollout pause dc sonarqube
#oc expose svc/sonarqube

#echo "apiVersion: v1
#kind: PersistentVolumeClaim
#metadata:
#  name: sonarqube-pvc
#spec:
 # accessModes:
  #- ReadWriteOnce
  #resources:
  #  requests:
  #    storage: 4Gi" | oc create -f -
    
#oc set volume dc/sonarqube --add --overwrite --name=sonarqube-volume-1 --mount-path=/opt/sonarqube/data/ --type persistentVolumeClaim --claim-name=sonarqube-pvc

#oc set resources dc/sonarqube --limits=memory=3Gi,cpu=2 --requests=memory=2Gi,cpu=1
#oc patch dc sonarqube --patch='{"spec": {"strategy": {"type" : "Recreate"}}}'

#oc set probe dc/sonarqube --liveness --failure-threshold 3 --initial-delay-seconds 40 -- echo ok
#oc set probe dc/sonarqube --readiness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:9000/about

#oc rollout resume dc sonarqube
