#!/bin/sh
# Copyright 2016-2017 Christof Schulze <christof@christofschulze.com>
# Licensed to the public under the Apache License 2.0.

. /lib/functions.sh
. ../netifd-proto.sh
init_proto "$@"

proto_gluon_wireguard_init_config() {
  no_device=1
  available=1
  renew_handler=1
}

proto_gluon_wireguard_renew() {
  local config="$1"
  echo wireguard RENEW: $@
  # ifdump="$(ubus call network.interface dump)"
}

proto_gluon_wireguard_setup() {
  local config="$1"
  # ifname=$(ubus call network.interface dump | jsonfilter -e "@.interface[@.interface=\"$config\"]")
  ifname=$(uci get network.$config.ifname) # we need uci here because nodevice=1 means the device is not part of the ubus structure
  group=$(uci get wireguard.mesh_vpn.group)

  if [ $(uci get wireguard.mesh_vpn_backbone.enabled) == 1 ]; then
    ip link del $ifname
    ip link add dev $ifname type wireguard
    ip link set mtu $(uci get wireguard.mesh_vpn.mtu) dev $ifname
    ip link set multicast on dev $ifname

    group_peers=$(uci show wireguard|grep mesh_vpn_backbone_peer|grep =peer|cut -d"." -f2|cut -d= -f1)

    for i in $group_peers
    do
      if [ $ifname == $(uci get wireguard.$i.ifname) ]; then
	thispeer=$i
	break;
      fi
    done

    remoteport=$(/usr/bin/wg-broker $ifname)
    (
    flock -n 9
    if [[ $remoteport == "FULL" ]]; then
      echo wireguard server is not accepting additional connections. Closing this interface
      ip link del $ifname
      exit 1
    elif [[ $(wg show all latest-handshakes |wc -l) -ge $(uci get wireguard.mesh_vpn_backbone.peer_limit) ]]; then
      echo "not establishing another connection, we already have  $(uci get wireguard.mesh_vpn_backbone.peer_limit) connections."
      ip link del $ifname
      exit 1
    fi

    wg set $ifname private-key /lib/gluon/mesh-vpn/wireguard peer $(uci get wireguard.$thispeer.key) endpoint $(uci get wireguard.$thispeer.remote):$remoteport allowed-ips ::/0

    ip link set dev $ifname up

    proto_init_update $ifname 1
    proto_send_update "$config"
    ) 9>/var/lock/wireguard_proto.lock
  fi
}

proto_gluon_wireguard_teardown() {
  local config="$1"
  echo teardown config: $config
  ifname=$(uci get network.$config.ifname) # we need uci here because nodevice=1 means the device is not part of the ubus structure

  ip link del $ifname
}

[ -n "$INCLUDE_ONLY" ] || {
add_protocol gluon_wireguard
}

