#!/bin/bash

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

chown -R sonarqube:sonarqube $SONARQUBE_HOME
exec gosu sonarqube \
  java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.log.level=$SONARQUBE_LOG_LEVEL \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.security.realm=LDAP \
  -Dsonar.authenticator.downcase=true \
  -Dldap.url="$LDAP_URL" \
  -Dldap.bindDn="$LDAP_BIND_DN" \
  -Dldap.bindPassword="$LDAP_PASSWORD" \
  -Dldap.user.baseDn="$LDAP_USER_BASE_DN" \
  -Dldap.user.request="$LDAP_USER_REQUEST" \
  -Dldap.followReferrals=false \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"
