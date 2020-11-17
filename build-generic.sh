#!/bin/bash
CHART_NAME=$1
REPO=$2
INTERNAL_PATH=$3

HELM_EXECUTABLE=/tmp/helm/helm
#HELM_EXECUTABLE=helm
BUILD_FOLDER=build-$CHART_NAME

mkdir $BUILD_FOLDER
mkdir prevdata

git clone $REPO $CHART_NAME
aws s3 cp s3://helm-repo.sphera.tools/$CHART_NAME prevdata --recursive || true
cd $CHART_NAME/$INTERNAL_PATH && $HELM_EXECUTABLE package ./ && cd -
mv $CHART_NAME/$INTERNAL_PATH/*.tgz $BUILD_FOLDER/

if test -f prevdata/index.yaml
then
    echo 'Merging with previous data'
    mv prevdata/*.tgz $BUILD_FOLDER/ || true
    $HELM_EXECUTABLE repo index $BUILD_FOLDER/ --merge prevdata/index.yaml --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/$CHART_NAME
else
    echo 'No previous charts to merge'
    $HELM_EXECUTABLE repo index $BUILD_FOLDER/ --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/$CHART_NAME
fi
rm -rf prevdata
rm -rf $CHART_NAME