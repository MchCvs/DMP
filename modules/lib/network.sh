#!/bin/bash

# ==================================================
# DMP - Domaine Q
# Réseau et Connectivité
# Version V1 - Observation essentielle
# ==================================================


collect_network_interfaces()
{
    ip link show
}


collect_network_ip()
{
    ip addr show
}


collect_network_gateway()
{
    ip route show default
}


collect_network_dns()
{
    cat /etc/resolv.conf
}


collect_network_status()
{
    ip link show
}


collect_network_internet()
{
    ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "INTERNET_OK"
    else
        echo "INTERNET_KO"
    fi
}

# ==================================================
# Normalisation réseau DMP V1
# ==================================================

get_network_active_interface()
{
    ip -o link show up |
    awk -F': ' '$2 != "lo" {print $2; exit}'
}


get_network_ipv4()
{
    local INTERFACE
    INTERFACE=$(get_network_active_interface)

    if [ -z "$INTERFACE" ]; then
        return 1
    fi

    ip -4 -o addr show dev "$INTERFACE" scope global |
    awk '{print $4; exit}'
}


get_network_ipv6()
{
    local INTERFACE
    INTERFACE=$(get_network_active_interface)

    if [ -z "$INTERFACE" ]; then
        return 1
    fi

    ip -6 -o addr show dev "$INTERFACE" scope global |
    awk '{print $4}'
}


get_network_gateway()
{
    ip route show default |
    awk '$1 == "default" {print $3; exit}'
}


get_network_dns()
{
    awk '
        $1 == "nameserver" {
            print $2
        }
    ' /etc/resolv.conf
}


get_network_internet_status()
{
    if ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
        echo "OK"
    else
        echo "KO"
    fi
}


get_network_local_status()
{
    local INTERFACE
    INTERFACE=$(get_network_active_interface)

    if [ -z "$INTERFACE" ]; then
        echo "KO"
        return
    fi

    if ip link show "$INTERFACE" |
        grep -q "state UP"; then
        echo "OK"
    else
        echo "KO"
    fi
}

# ==================================================
# Explication réseau DMP V1
# ==================================================

explain_network_status()
{
    local INTERFACE
    local IPV4
    local IPV6
    local GATEWAY
    local DNS
    local LOCAL_STATUS
    local INTERNET_STATUS

    INTERFACE=$(get_network_active_interface)
    IPV4=$(get_network_ipv4)
    IPV6=$(get_network_ipv6)
    GATEWAY=$(get_network_gateway)
    DNS=$(get_network_dns)
    LOCAL_STATUS=$(get_network_local_status)
    INTERNET_STATUS=$(get_network_internet_status)

    echo
    echo "=============================================="
    echo " État du réseau"
    echo "=============================================="
    echo

    if [ "$LOCAL_STATUS" = "OK" ]; then
        dmp_status_good \
            "Réseau local" \
            "Votre ordinateur est connecté au réseau local."
    else
        dmp_status_problem \
            "Réseau local" \
            "Aucune connexion réseau locale active n'est détectée."
    fi

    if [ -n "$INTERFACE" ]; then
        echo
        echo "Interface réseau active : $INTERFACE"
    fi

    if [ -n "$IPV4" ]; then
        dmp_status_good \
            "Adresse IPv4" \
            "Une adresse IPv4 est configurée."
        echo "  Adresse : $IPV4"
    else
        dmp_status_problem \
            "Adresse IPv4" \
            "Aucune adresse IPv4 active n'est détectée."
    fi

    if [ -n "$IPV6" ]; then
        dmp_status_good \
            "Adresse IPv6" \
            "Une connectivité IPv6 est configurée."
        echo "  Adresses :"
        while IFS= read -r ADDRESS; do
            [ -n "$ADDRESS" ] && echo "    $ADDRESS"
        done <<< "$IPV6"
    else
        echo
        echo "Adresse IPv6"
        echo "  Aucune adresse IPv6 globale n'est détectée."
    fi

    if [ -n "$GATEWAY" ]; then
        dmp_status_good \
            "Passerelle réseau" \
            "Une passerelle réseau est configurée."
        echo "  Passerelle : $GATEWAY"
    else
        dmp_status_problem \
            "Passerelle réseau" \
            "Aucune passerelle réseau n'est configurée."
    fi

    if [ -n "$DNS" ]; then
        dmp_status_good \
            "Serveurs DNS" \
            "Des serveurs DNS sont configurés."
        echo "  Serveurs :"
        while IFS= read -r SERVER; do
            [ -n "$SERVER" ] && echo "    $SERVER"
        done <<< "$DNS"
    else
        dmp_status_problem \
            "Serveurs DNS" \
            "Aucun serveur DNS n'est configuré."
    fi

    if [ "$INTERNET_STATUS" = "OK" ]; then
        dmp_status_good \
            "Accès Internet" \
            "L'accès Internet fonctionne actuellement."
    else
        dmp_status_problem \
            "Accès Internet" \
            "L'accès Internet n'est pas disponible actuellement."
    fi

    echo
    echo "Conclusion :"

    if [ "$LOCAL_STATUS" = "OK" ] &&
       [ -n "$GATEWAY" ] &&
       [ -n "$DNS" ] &&
       [ "$INTERNET_STATUS" = "OK" ]; then

        dmp_status_good \
            "État global du réseau" \
            "La connectivité réseau essentielle fonctionne actuellement."

    else

        dmp_status_problem \
            "État global du réseau" \
            "La connectivité réseau présente un élément nécessitant une analyse."

    fi
}

