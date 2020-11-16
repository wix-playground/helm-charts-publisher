mkdir build-kuberos
mkdir prevdata

git clone https://github.com/helm/charts.git
aws s3 cp s3://helm-repo.sphera.tools/kuberos prevdata --recursive || true
cd charts/stable/kuberos && /tmp/helm/helm package ./ && cd -
mv charts/stable/kuberos/*.tgz build-kuberos/

if test -f prevdata/index.yaml
then
    echo 'Merging with previous data'
    mv prevdata/*.tgz build-kuberos/ || true
    /tmp/helm/helm repo index build-kuberos/ --merge prevdata/index.yaml --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/kuberos
else
    echo 'No previous charts to merge'
    /tmp/helm/helm repo index build-kuberos/ --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/kuberos
fi
rm -rf prevdata
rm -rf charts