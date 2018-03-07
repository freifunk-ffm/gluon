#!/bin/sh
# Copyright 2018 Vincent Wiemann <vincent.wiemann@ironai.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2
# as published by the Free Software Foundation
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

CTR=/proc/net/nat46/control


[ -n "$INCLUDE_ONLY" ] || {
  . /lib/functions.sh
  . ../netifd-proto.sh
  init_proto "$@"
}


proto_xlat464plat_init_config() {
  proto_config_add_bool "debug"
  proto_config_add_string "local_v4"
  proto_config_add_string "local_v6"
  proto_config_add_string "nat66addr"
  proto_config_add_string "tunlink"
  proto_config_add_string "zone"
  proto_config_add_string "zone6"
  available=1
  no_device=1
}


proto_xlat464plat_setup() {
  local config="$1"

  local plat_cfg="config ${config}"
  local debug
  local local_v4
  local local_v6
  local nat66addr
  local tunlink
  local zone
  local zone6

  config_load network
  config_get_bool	debug		"${config}" "debug" 0
  config_get		local_v4	"${config}" "local_v4"
  config_get		local_v6	"${config}" "local_v6"
  config_get		nat66addr	"${config}" "nat66addr"
  config_get		tunlink		"${config}" "tunlink"
  config_get		zone		"${config}" "zone"
  config_get		zone6		"${config}" "zone6"

  nat66addr="${nat66addr:-fddd:c:1a4c:1a4c:1a4c:1a4c:c000:8}"
  local_v4="${local_v4:-0.0.0.0/0}"
  local_v6="${local_v6:-64:ff9b::/96}"
  tunlink="${tunlink:-wan}"
  zone="${zone:-wan}"
  zone6="${zone6:-lan}"


  ( proto_add_host_dependency "$config" "${local_v4%%/*}" "${tunlink}" )

  if [ ${debug} -ne 0 ]; then
    plat_cfg="${plat_cfg} debug 1"
  fi

  plat_cfg="${plat_cfg} local.style RFC6052 local.v6 ${local_v6} local.v4 ${local_v4}"
  plat_cfg="${plat_cfg} remote.style NONE remote.v4 192.0.0.8/32 remote.v6 ${nat66addr}/128"

  echo "add ${config}" > ${CTR}
  echo "${plat_cfg}" > ${CTR}


  proto_init_update "${config}" 1

  proto_add_ipv6_address "${local_v6%%:/*}c000:1" "128"
  proto_add_ipv6_route "${local_v6%%/*}" "${local_v6##*/}"
  proto_add_ipv4_route "192.0.0.8" "32"

	proto_add_data
	[ "$zone" != "-" ] && json_add_string zone "$zone"

	json_add_array firewall
		# this fw3 IPv6 SNAT rule is broken
		json_add_object ""
			json_add_string type nat
			json_add_string target SNAT
			json_add_string family ipv6
			json_add_string snat_ip "${nat66addr}"
		json_close_object

	  if [ "$zone" != "-" ]; then
	  	json_add_object ""
	  		json_add_string type rule
	  		json_add_string family inet
	  		json_add_string proto all
	  		json_add_string direction in
			json_add_string dest "$zone"
			json_add_string src "$zone"
	  		json_add_string src_ip 192.0.0.8
	  		json_add_string target ACCEPT
	  	json_close_object
	  fi

	  if [ "$zone6" != "-" ]; then
		# deny access to 192.168.0.0/16
	  	json_add_object ""
	  		json_add_string type rule
	  		json_add_string family ipv6
	  		json_add_string proto all
	  		json_add_string direction out
			json_add_string dest "$zone"
			json_add_string src "${zone6}"
	  		json_add_string dest_ip "${local_v6%%:/*}c0a8::/112"
	  		json_add_string target DROP
	  	json_close_object
		# deny access to 172.16.0.0/12
		json_add_object ""
	  		json_add_string type rule
	  		json_add_string family ipv6
	  		json_add_string proto all
	  		json_add_string direction out
			json_add_string dest "$zone"
			json_add_string src "${zone6}"
	  		json_add_string dest_ip "${local_v6%%:/*}ac10::/108"
	  		json_add_string target DROP
	  	json_close_object
		# deny access to 10.0.0.0/8
	  	json_add_object ""
	  		json_add_string type rule
	  		json_add_string family ipv6
	  		json_add_string proto all
	  		json_add_string direction out
			json_add_string dest "$zone"
			json_add_string src "${zone6}"
	  		json_add_string dest_ip "${local_v6%%:/*}a00::/104"
	  		json_add_string target DROP
	  	json_close_object
		# allow access to everything else
	  	json_add_object ""
	  		json_add_string type rule
	  		json_add_string family ipv6
	  		json_add_string proto all
	  		json_add_string direction out
			json_add_string dest "$zone"
			json_add_string src "${zone6}"
	  		json_add_string dest_ip "${local_v6}"
	  		json_add_string target ACCEPT
	  	json_close_object
	  fi
	json_close_array

	proto_close_data

  proto_send_update "${config}"
}


proto_xlat464plat_teardown() {
  local config="$1"
  echo "del ${config}" > ${CTR}
}


[ -n "$INCLUDE_ONLY" ] || {
  add_protocol xlat464plat
}

