#!/bin/bash
A=$(tput sgr0)
export TERM=xterm

if [ "$(ls -A /etc/apache2/)" ]; then
echo " '/etc/apache2' found"
else
cp -r /root/apache2/. /etc/apache2
fi

if [ "$(ls -A /opt/TiddlyWiki/)" ]; then
echo " '/opt/TiddlyWiki' found"
else
cp -r /root/TiddlyWiki/. /opt/TiddlyWiki
fi


echo ""
 if [[ ! -f /etc/apache2/site-proxy-configured ]];then

echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"|      optional docker variable        | $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"|       1) LDAP_CONF                   | $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo ""
echo -e '\E[32m'"###################################### $A"
echo -e '\E[32m'"###           LDAP_CONF            ### $A"
echo -e '\E[32m'"###################################### $A"
echo -e '\E[33m'"You need to provide either 'Y' or 'y' for configure LDAP authentication $A"
echo ""
sleep 2

cat <<EOF> /etc/apache2/sites-available/ldap.conf
<VirtualHost *:80>
#        ServerName TiddlyWiki
        AllowEncodedSlashes on
        ProxyPass / http://localhost:8080/
        ProxyPassReverse / http://localhost:8080/
        ServerAdmin akhilrajmailbox@gmail.com

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

EOF
  if [[ $LDAP_CONF = [y,Y] ]];then
cat <<EOF>> /etc/apache2/sites-available/ldap.conf

<Location />
	AuthType Basic
	AuthBasicProvider ldap
	AuthName "Password protected. Enter your LDAP username and password."

	AuthLDAPURL "ldap://<<IP_ADDRESS>>:<<PORT>>/ou=users,dc=www,dc=example,dc=com?uid?sub"
	AuthLDAPBindDN "cn=<<readonly-user>>,ou=users,dc=www,dc=example,dc=com"
	AuthLDAPBindPassword "<<readonly-user-password>>"

        AuthLDAPGroupAttribute memberUid
        AuthLDAPGroupAttributeIsDN off

	#Require valid-user
	#Require ldap-user akhil user2
	Require ldap-group cn=<<any-group>>,ou=groups,dc=www,dc=example,dc=com
</Location>
EOF

  fi
touch /etc/apache2/site-proxy-configured
 fi

chown -R :www-data /etc/apache2
a2dissite *.conf
a2enmod authnz_ldap
a2enmod proxy
a2enmod proxy_http
a2ensite ldap.conf

nohup tiddlywiki /opt/TiddlyWiki --server 8080 "" "" "" "" "" 0.0.0.0 "" &
/etc/init.d/apache2 restart
tailf /root/start.sh
