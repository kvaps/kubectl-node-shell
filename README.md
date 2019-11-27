# kubectl node-shell
*(formerly known as **kubectl-enter**)*

Start a root shell in the node's host OS running.

## Installation

```
curl -LO https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell
chmod +x ./kubectl-node_shell
sudo mv ./kubectl-node-shell /usr/local/bin/kubectl-node_shell
```

## Usage

```
kubectl node-shell <node>
```

*You need to be able to start privileged containers for that.*
