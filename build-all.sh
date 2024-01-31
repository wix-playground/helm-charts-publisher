#!/bin/bash
 
./build-generic.sh "kuberos" "https://github.com/helm/charts.git" "stable/kuberos"
./build-generic.sh "kubernetes-dashboard-proxy" "https://github.com/wix-playground/helm-charts-publisher.git" "charts/kubernetes-dashboard-proxy"
./build-generic.sh "cluster-autoscaler" "https://github.com/kubernetes/autoscaler.git" "charts/cluster-autoscaler-chart"
./build-generic.sh "consulv3" "https://github.com/hashicorp/consul-helm.git" ""
./build-generic.sh "heapster" "https://github.com/helm/charts.git" "stable/heapster"
./build-generic.sh "aws-alb-ingress-controller" "https://github.com/helm/charts.git" "incubator/aws-alb-ingress-controller"
./build-generic.sh "kube2iam" "https://github.com/jtblin/kube2iam.git" "charts/kube2iam"
./build-generic.sh "metrics-server" "https://github.com/helm/charts.git" "stable/metrics-server"
