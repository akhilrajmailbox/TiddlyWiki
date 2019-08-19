# TiddlyWiki


## Run the following command for creating your tiddlywiki server.
* -v is optional, it is for mounting the wiki data to the host
* LDAP_CONF=y, it is also optional, if you want the Ldap authentication for your wiki, add this environmental variable in docker run comamnd
then edit /etc/apache2/sites-available/ldap.conf with your LDAP data
restart your container
```
docker run -it -v /home/akhil/Desktop/wiki:/opt/TiddlyWiki --name wiki --hostname wiki -p 80:80 -e LDAP_CONF=y <<docker image>> /bin/bash
```
