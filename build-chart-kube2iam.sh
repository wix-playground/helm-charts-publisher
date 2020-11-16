mkdir build-kube2iam
mkdir prevdata

git clone https://github.com/jtblin/kube2iam.git
aws s3 cp s3://helm-repo.sphera.tools/kube2iam prevdata --recursive || true
cd kube2iam/charts/kube2iam/ && /tmp/helm/helm package ./ && cd -
mv kube2iam/charts/kube2iam/*.tgz build-kube2iam/

if test -f prevdata/index.yaml
then
    echo 'Merging with previous data'
    mv prevdata/*.tgz build-kube2iam/ || true
    /tmp/helm/helm repo index build-kube2iam/ --merge prevdata/index.yaml --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/kube2iam
else
    echo 'No previous charts to merge'
    /tmp/helm/helm repo index build-kube2iam/ --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/kube2iam
fi
rm -rf prevdata
rm -rf charts