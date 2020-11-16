mkdir build
mkdir prevdata

git clone https://github.com/kubernetes/autoscaler.git
aws s3 cp s3://helm-repo.sphera.tools/cluster-autoscaller prevdata --recursive || true
cd autoscaler/charts/cluster-autoscaler-chart && /tmp/helm/helm package ./ && cd -
mv autoscaler/charts/cluster-autoscaler-chart/*.tgz build/
if test -f prevdata/index.yaml
then
    echo 'Merging with previous data'
    mv prevdata/*.tgz build/ || true
    /tmp/helm/helm repo index build/ --merge prevdata/index.yaml --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/cluster-autoscaller
else
    echo 'No previous charts to merge'
    /tmp/helm/helm repo index build/ --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/cluster-autoscaller
fi