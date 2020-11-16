mkdir build-heapster
mkdir prevdata

git clone https://github.com/helm/charts.git
aws s3 cp s3://helm-repo.sphera.tools/heapster prevdata --recursive || true
cd charts/stable/heapster && /tmp/helm/helm package ./ && cd -
mv charts/stable/heapster/*.tgz build-heapster/

if test -f prevdata/index.yaml
then
    echo 'Merging with previous data'
    mv prevdata/*.tgz build-heapster/ || true
    /tmp/helm/helm repo index build/ --merge prevdata/index.yaml --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/heapster
else
    echo 'No previous charts to merge'
    /tmp/helm/helm repo index build/ --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/heapster
fi
rm -rf prevdata
rm -rf charts