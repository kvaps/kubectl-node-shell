# kubectl node-shell
*(formerly known as **kubectl-enter**)*

Start a root shell in the node's host OS running. Uses an alpine pod with nsenter for Linux nodes and a [HostProcess pod](https://kubernetes.io/docs/tasks/configure-pod-container/create-hostprocess-pod/) with PowerShell for Windows nodes.

![demo](https://gist.githubusercontent.com/kvaps/2e3d77975a844654ec297893e21a0829/raw/c778a8405ff8c686e4e807a97e9721b423e7208f/kubectl-node-shell.gif)

## Installation

using [krew](https://krew.sigs.k8s.io/):

Plugin can be installed from the official krew repository:

<pre>
kubectl krew install node-shell
</pre>

Or from our own krew repository:
<pre>
kubectl krew index add kvaps <a href="https://github.com/kvaps/krew-index">https://github.com/kvaps/krew-index</a>
kubectl krew install kvaps/node-shell
</pre>

or using curl:

```bash
curl -LO https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell
chmod +x ./kubectl-node_shell
sudo mv ./kubectl-node_shell /usr/local/bin/kubectl-node_shell
```

## Usage

```bash
# Get standard bash shell
kubectl node-shell <node>

# Use custom image for pod
kubectl node-shell <node> --image <image>

# Use X-mode (mount /host, and do not enter host namespace)
kubectl node-shell -x <node>

# Execute custom command
kubectl node-shell <node> -- echo 123

# Use stdin
cat /etc/passwd | kubectl node-shell <node> -- sh -c 'cat > /tmp/passwd'

# Run oneliner script
kubectl node-shell <node> -- sh -c 'cat /tmp/passwd; rm -f /tmp/passwd'
```

## X-mode

X-mode can be useful for debugging minimal systems that do not have a built-in shell (eg. Talos).  
Here's an example of how you can debug the network for a rootless kube-apiserver container without a filesystem:

```bash
kubectl node-shell -x <node>

# Download crictl
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz -O- | \
  tar -xzf- -C /usr/local/bin/

# Setup CRI endpoint
export CONTAINER_RUNTIME_ENDPOINT=unix:///host/run/containerd/containerd.sock

# Find your container
crictl ps | grep kube-apiserver
#3ff4626a9f10e       e7972205b6614       6 hours ago         Running             kube-apiserver         0                   215107b47bd7e       kube-apiserver-talos-rzq-nkg

# Find pid of the container
crictl inspect 3ff4626a9f10e | grep pid
#    "pid": 2152,
#            "pid": 1
#            "type": "pid"
#                "getpid",
#                "getppid",
#                "pidfd_open",
#                "pidfd_send_signal",
#                "waitpid",

# Go to network namespace of the pid, but keep mount namespace of the debug container
nsenter -t 2152 -n
```

*You need to be able to start privileged containers for that.*
