# Apex docker configuration

Docker compose file created from individual components which are configured using this guide:

<https://tm-apex.blogspot.com/2022/06/running-apex-in-docker-container.html>

### Requirements

Docker, Git.


### Usage:

1. clone repository
2. open a terminal with this directory as the working directory
3. create a connection string file for ORDS with 
   + for Windows
     - `"CONN_STRING=sys/1230123@database:1521/XEPDB1" | Out-File conn_string.txt -NoNewline`
   + for Linux
     - `echo 'CONN_STRING=sys/1230123@database:1521/XEPDB1'>conn_string.txt`
4. run docker compose with
   + `docker-compose up -d`
5. check apex installation progress with 
    + `docker exec -it ords tail -f /tmp/install_container.log`
