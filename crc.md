---
title: Code Ready Containers
---

## On the remote host

```
cat /etc/redhat-release
Fedora release 29 (Twenty Nine)
```

#### Install packages

- [ ] Add this to the ansible build
```shell
sudo dnf install qemu-kvm libvirt NetworkManager tinyproxy
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
sudo systemctl start tinyproxy
```
####  Create a crcuser 
```
adduser crcuser
passwd crcuser
usermod -aG wheel crcuser
sudo passwd -d crcuser
```
```
# test if crcuser needs password
$ su crcuser
$ whoami
crcuser
```

####  Setup CodeReady Containers
```
su crcuser
# Goto https://cloud.redhat.com/openshift/install/crc/installer-provisioned
# download the CodeReady Containers archive 

wget https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz
tar -xvf crc-linux-amd64.tar.xz
crc setup

# the pull secret is also available on https://cloud.redhat.com/openshift/install/crc/installer-provisioned
# Copy and paste it when prompted by crc start
crc start
```

####  Save the login details
```
''eval $(crc oc-env) && oc login -u kubeadmin -p e4FEb-9dxdF-9N2wH-Dj7B8 https://api.crc.testing:6443' 
INFO Access the OpenShift web-console here: https://console-openshift-console.apps-crc.testing 
INFO Login to the console with user: kubeadmin, password: e4FEb-9dxdF-9N2wH-Dj7B8
```

####  Install oc client
```
# Go to https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux-4.2.2.tar.gz

tar -xvf openshift-client-linux-4.2.2.tar.gz
cp oc /usr/local/bin
```

####  Setup tinyproxy

Edit the `/etc/tinyproxy/tinyproxy.conf` file.
Comment out the `Allow 127.0.0.1` line as it allows only access from within the VM
Search for `ConnectPort` and add the following line:
```
ConnectPort 6443
```

Save the file and Start tinyproxy
```
systemctl start tinyproxy
```
  
   

## On the Laptop

####  Install oc client
```
# Go to https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/

wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux-4.1.13.tar.gz
tar -xvf openshift-client-linux-4.1.13.tar.gz
cp oc /usr/local/bin
```

####  BROWSER: Setup SSH tunneling to access OpenShift console from browser
Edit `/etc/hosts`
```
127.0.0.1 localhost console-openshift-console.apps-crc.testing oauth-openshift.apps-crc.testing
```

```
sudo ssh root@<REMOTE_HOST> -L 443:console-openshift-console.apps-crc.testing:443
```
Give laptop password first and then the remote system password.  
OpenShift console is available at `https://console-openshift-console.apps-crc.testing`


####  TERMINAL: Setup for oc client to work
```
# in a new terminal
export https_proxy=http://vm_ip:8888
```
```
# test api endpoint
curl -k https://api.crc.testing:6443
```
Now you can login using `oc` client tool
```
oc login -u kubeadmin -p e4FEb-9dxdF-9N2wH-Dj7B8 https://api.crc.testing:6443
```

####  To access routes
```
# get the route 
oc get routes
NAME     HOST/PORT                                  PATH   SERVICES           PORT   TERMINATION   WILDCARD
tekton   myservice-mynamespace.apps-crc.testing          tekton-dashboard   http                 None
```
Add the route to `/etc/hosts` file as given below.
```
127.0.0.1 localhost console-openshift-console.apps-crc.testing oauth-openshift.apps-crc.testing myservice-mynamespace.apps-crc.testing
```

SSH tunnel in a new terminal
```
sudo ssh root@<REMOTE_HOST> -L 80:myservice-mynamespace.apps-crc.testing:80
```
the UI is available at `https://myservice-mynamespace.apps-crc.testing`

