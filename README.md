# Flocker client (flocker-cli(flocker-ca)) docker image builder
Resulted image is [owlab/flocker-ca](https://hub.docker.com/r/owlab/flocker-ca/).

# Usage

To see version of the flocker client.
```
# docker run -it owlab/flocker-ca --version
```

To make a cluster cert.
```
# docker run -it --rm -v $PWD:/flockercerts -e LOCAL_USER_ID:$(id -u) owlab/flocker-ca initialize first-cluster
```
Without the **-e LOCAL_USER_ID=$(id -u)** option, you will end up getting non-touchable files.
