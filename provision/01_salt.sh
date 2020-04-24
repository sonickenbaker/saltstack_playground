#!/bin/bash
set -e
set +x

install_salt() {
    local -r role="$1"
    local -r salt_version="$2"
    local -r salt_master_addr="$3"

    echo "Installing Salt version: ${salt_version}"
    case "$role" in
        "master")
            echo "Installing Salt version: ${salt_version}"
            curl -L https://bootstrap.saltstack.com -o /tmp/saltstack_bootstrap.sh
            bash /tmp/saltstack_bootstrap.sh -M -X -F -P git v"${salt_version}"
            echo "Configuring salt-master"
            sed -i '/#auto_accept: False/c\auto_accept: True' /etc/salt/master
            echo "Configuring salt-minion"
            echo "master: $salt_master_addr" >> /etc/salt/minion
            service salt-master restart
            service salt-minion restart
        ;;
        "minion")
            curl -L https://bootstrap.saltstack.com -o /tmp/saltstack_bootstrap.sh
            bash /tmp/saltstack_bootstrap.sh -X -F -P git v"${salt_version}"
            echo "Configuring salt-minion"
            echo "master: $salt_master_addr" >> /etc/salt/minion
            service salt-minion restart
        ;;
        *) echo default
        ;;
    esac
}

install_salt "$@"