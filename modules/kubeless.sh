#!/usr/bin/env bash

mkdir -p $HOME/bin/ && cd $HOME/bin/
echo "installing local kubeless binary"
export RELEASE=$(curl -s https://api.github.com/repos/kubeless/kubeless/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -s -L -o $HOME/bin/kubeless.zip https://github.com/kubeless/kubeless/releases/download/$RELEASE/kubeless_darwin-amd64.zip
unzip -o $HOME/bin/kubeless.zip
mv $HOME/bin/bundles/kubeless_darwin-amd64/kubeless $HOME/bin/
rm -f $HOME/bin/kubeless.zip
rm -rf $HOME/bin/bundles

echo "helm install kubeless in cluster"
helm init --kubeconfig=$HOME/.kube/docker --upgrade
helm --kubeconfig=$HOME/.kube/docker repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
helm --kubeconfig=$HOME/.kube/docker install --namespace kubeless incubator/kubeless