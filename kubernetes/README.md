# Kubernetes Deployment Scripts
There is a preparation script included that can simplify installation.
## Prepare script
Included is a "prepare" script. It was made solely to simplify mass deployment in test environments, and is not deemed safe.
Syntax:
```
curl -L "https://gitlab.giraf.cs.aau.dk/tools/deployment/raw/master/kubernetes/kubernetes_prepare.sh" -s -O && chmod +x kubernetes_prepare.sh && ./kubernetes_prepare.sh PASSWORD && cd /home/kubernetes
```
Replace PASSWORD to inject the password for the kubernetes user, if you remove the parameter then you'll be prompted to enter a password.
## Deployment
The deployment script itself needs some parameters. They can be entered using either
```--master=true``` or ```--master true```.
To setup the master node, use the following syntax:
```
./kubernetes_deploy.sh --master-ip=1.1.1.1 --master=true
```
As for the nodes:
```
./kubernetes_deploy.sh --master-ip=1.1.1.1 --master-token=d4e5f6 --master-hash=a1b2c3
```
Tokens and hashes are obviously a lot longer though
You can also use the port argument if relevant.