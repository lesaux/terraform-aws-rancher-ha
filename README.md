# Terraform rancher-ha servers and hosts deployment

## Requirements

- An existing keypair in AWS.


## Caveats

- Currently using self-signed ssl certs.
- Using http instead of https for rancher registration url.
- Authentication is not enabled in rancher. You will need to manually enable authentication after the deployment.
- Deployment takes a long time (around 20mins). Waiting for the cluster to be ready can take up to 12mins, and rebooting rancheros to set a hostname takes
a long time as well.
- I've noticed that once in a while, one of the rancher servers will not initialize properly. If that's the case cleanup docker containers running on that host and run the deployment command again.

```
ssh -A -t ubuntu@bastion.your.domain ssh rancher@rancher-server-#.your.domain docker rm -f $(docker ps -a -q)

ssh -A -t ubuntu@bastion.your.domain ssh rancher@rancher-server-#.your-domain sudo bash /var/lib/rancher/bin/rancher-ha-start.sh rancher/server
```

