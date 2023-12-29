# Tomcat

## Links

Documentation: https://medium.com/@pra4mesh/deploy-war-in-docker-tomcat-container-b52a3baea448

## Data

Add war file
```bash
mkdir temp
cd temp 
git clone https://github.com/efsavage/hello-world-war.git
cd ..
cp ./temp/hello-world-war/dist/hello-world.war ./input/root.war
```


## Run

### Start 
```bash
docker-compose up -d
```

### Debug
Connection
```bash
docker exec -it tomcat8-hello-world /bin/bash
```

Typical debug tools
```bash
apt update && apt install -y vim tree htop net-tools tcpdump
```

### Stop 
```bash
docker-compose down
```


## Configuration

TODO : Load config file