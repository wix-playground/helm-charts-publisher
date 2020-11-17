mkdir build-consul
mkdir prevdata

git clone https://github.com/hashicorp/consul-helm.git
aws s3 cp s3://helm-repo.sphera.tools/consulv3 prevdata --recursive || true
cd consul-helm && /tmp/helm/helm package ./ && cd ..
mv consul-helm/*.tgz build-consul/
if test -f prevdata/index.yaml
then
    echo 'Merging with previous data'
    mv prevdata/*.tgz build/ || true
    /tmp/helm/helm repo index build-consul/ --merge prevdata/index.yaml --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/consulv3
else
    echo 'No previous charts to merge'
    /tmp/helm/helm repo index build-consul/ --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/consulv3
fi

rm -rf prevdata
rm -rf consul-helm