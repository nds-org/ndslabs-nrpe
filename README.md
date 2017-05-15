# Nagios Remote Plugin Executor (NRPE)
Resources to create a Docker image of the Nagios [NRPE](https://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details) used for [monitoring the Labs workbench infrastructure](https://opensource.ncsa.illinois.edu/confluence/display/NDS/NDS+Labs+Monitoring).

# Prerequisites
To build:
* Docker

To run:
* A remote machine's credentials: username / ssh key / hostname
* Kubernetes

# Build
The usual `docker build` command:
```bash
docker build -t ndslabs/nagios-nrpe:latest .
```

# Run
Modify `nagios-nrpe.yaml` to adjust **image** to point to your own, and then run:
```bash
kubectl create -f nagios-nrpe.yaml
```

NOTE: This will start a DaemonSet for the NRPE container, which will run a copy on each node in the cluster.

# Via Docker
```bash
docker run --privileged -v /:/mnt/ROOT --rm --name nrpe -p 5666:5666 ndslabs/nagios-nrpe
```

# Configure NAGIOS to include the cluster in its checks
Then, you'll need to SSH into your NAGIOS instance and add this cluster to the list of "servers":
```bash
sudo su -
cd /usr/local/nagios/etc/servers
cp cwtest.cfg yourcluster.cfg
# Modify yourcluster.cfg to your liking
cat /home/nagios/.ssh/id_rsa.pub
```

## Intracluster Configuration
Once NRPE is running and you've retrieved the public key for the `nagios` user, you will need to create a `nagios` user on your local node and add the SSH key from your NAGIOS monitor to `~/.ssh/authorized_keys`:
```bash
sudo useradd -m -d /home/nagios nagios
sudo passwd nagios (value doesn't matter)
sudo vi /home/nagios/.ssh/authorized_keys
# paste value from nagios id_rsa.pub
chmod 600 /home/nagios/.ssh/authorized_keys
```

NOTE: Make sure /home/nagios and home/nagios/.ssh are owned by nagios:nagios with correct permissions

# Testing Everything
1. From the NAGIOS server, confirm that you can SSH from the monitor to the target node without using a password:
```bash
sudo su - nagios
ssh nagios@yourserver
# Should SSH without password from nagios user to nagios user
```
2. Open browser to http://NAGIOS_MONITOR_HOSTNAME/nagios
3. Find your server. Service status should be pending. Wait until OK.
