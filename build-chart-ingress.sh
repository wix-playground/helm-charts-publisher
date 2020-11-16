mkdir build-ingress
mkdir prevdata

git clone https://github.com/helm/charts.git
aws s3 cp s3://helm-repo.sphera.tools/heapster prevdata --recursive || true
cd charts/incubator/aws-alb-ingress-controller/ && /tmp/helm/helm package ./ && cd -
mv charts/incubator/aws-alb-ingress-controller/*.tgz build-ingress/

if test -f prevdata/index.yaml
then
    echo 'Merging with previous data'
    mv prevdata/*.tgz build-heapster/ || true
    /tmp/helm/helm repo index build-ingress/ --merge prevdata/index.yaml --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/aws-alb-ingress-controller
else
    echo 'No previous charts to merge'
    /tmp/helm/helm repo index build-ingress/ --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/aws-alb-ingress-controller
fi
rm -rf prevdata
rm -rf charts