### How to run

# P.s1: Make sure you have terraform installed and it is in your $PATH

# P.s2: Run it will coast money at your aws account, it is your risk and your money, not my fault if you didn't read this.

# P.s3: Do whatever you want
```
./run.sh
```

## To tun cloudera cluster
```
kubectl create -f eks_templates/service_test.yml
kubectl create -f eks_templates/pod_test.yml
```
