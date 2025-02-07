#!/bin/bash

LDAP_ADMIN="cn=admin,dc=example,dc=com"
LDAP_PASSWORD="***"
LDAP_BASE="dc=example,dc=com"
USER_OU="ou=People,${LDAP_BASE}"

get_input() {
    local prompt="$1"
    local var_name="$2"
    local value
    while :; do
        echo "$prompt"
        read value
        if [[ -z "$value" ]]; then
            echo "Ошибка: поле не может быть пустым."
        else
            eval "$var_name=\"$value\""
            break
        fi
    done
}

get_input "Введите идентификатор пользователя:" USER_UID
get_input "Введите полное имя пользователя:" USER_CN
get_input "Введите фамилию пользователя:" USER_SN
get_input "Введите ID пользователя:" USER_UID_NUMBER
get_input "Введите GID пользователя:" USER_GID_NUMBER
get_input "Введите имя каталога:" USER_HOME_FOLDER

echo "Введите пароль (будет скрыт):"
read  USER_PASSWORD
if [[ -z "$USER_PASSWORD" ]]; then
    echo "Ошибка: пароль не может быть пустым."
    exit 1
fi

USER_HOME="/home/$USER_HOME_FOLDER"
USER_SHELL="/bin/bash"
HASHED_PASSWORD=$(slappasswd -s "$USER_PASSWORD")

LDIF_FILE=$(mktemp)

cat <<EOF > "${LDIF_FILE}"
dn: uid=${USER_UID},${USER_OU}
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
cn: ${USER_CN}
sn: ${USER_SN}
uid: ${USER_UID}
uidNumber: ${USER_UID_NUMBER}
gidNumber: ${USER_GID_NUMBER}
homeDirectory: ${USER_HOME}
loginShell: ${USER_SHELL}
userPassword: ${HASHED_PASSWORD}
EOF

ldapadd -x -D "${LDAP_ADMIN}" -w "${LDAP_PASSWORD}" -f "${LDIF_FILE}"

if [ $? -eq 0 ]; then
    echo "Пользователь ${USER_UID} успешно добавлен в LDAP."
else
    echo "Ошибка при добавлении пользователя ${USER_UID}."
    exit 1
fi

rm -f "${LDIF_FILE}"
