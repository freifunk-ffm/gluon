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


proto_xlat464clat_init_config() {
  proto_config_add_string "zone"
  proto_config_add_string "zone4"
  proto_config_add_string "local_style"
  proto_config_add_string "local_v4"
  proto_config_add_string "local_v6"
  proto_config_add_string "local_ea_len"
  proto_config_add_string "local_psid"
  proto_config_add_boolean "local_fmr_flag"
  proto_config_add_string "remote_style"
  proto_config_add_string "remote_v4"
  proto_config_add_string "remote_v6"
  proto_config_add_string "remote_ea_len"
  proto_config_add_string "remote_psid"
  proto_config_add_string "ip4table"
  proto_config_add_boolean "debug"
  available=1
  no_device=1
}


proto_xlat464clat_setup() {
  local config="$1"
  local clat_cfg="config ${config}"
  local local_style
  local local_v4
  local local_v6
  local local_ea_len
  local local_psid
  local local_fmr
  local remote_style
  local remote_v4
  local remote_v6
  local remote_ea_len
  local remote_psid
  local zone
  local zone4
  local ip4table


  config_load network

  config_get		ip4table	"${config}" "ip4table"
  config_get		zone		"${config}" "zone"
  config_get		zone4		"${config}" "zone4"
  config_get_bool	debug		"${config}" "debug" 0
  config_get		local_style	"${config}" "local_style"
  config_get		local_v4	"${config}" "local_v4"
  config_get		local_v6	"${config}" "local_v6"
  config_get		local_ea_len	"${config}" "local_ea_len"
  config_get		local_psid	"${config}" "local_psid_offset"
  config_get_bool	local_fmr	"${config}" "local_fmr_flag" 0
  config_get		remote_style	"${config}" "remote_style"
  config_get		remote_v4	"${config}" "remote_v4"
  config_get		remote_v6	"${config}" "remote_v6"
  config_get		remote_ea_len	"${config}" "remote_ea_len"
  config_get		remote_psid	"${config}" "remote_psid_offset"


  zone="${zone:-wan}"
  zone4="${zone4:-lan}"
  local_v6="${local_v6:-fd00:13:37:13:37::/96}"
  remote_v4="${remote_v4:-0.0.0.0/0}"

  [ $debug -ne 0 ] && clat_cfg="$clat_cfg debug 1"
  [ ${local_fmr} -ne 0 ] && clat_cfg="$clat_cfg local.fmr-flag 1"

  clat_cfg="${clat_cfg} local.style ${local_style:-RFC6052} local.v4 ${local_v4:-192.168.1.0/24} local.v6 ${local_v6}"
  clat_cfg="${clat_cfg} local.ea-len ${local_ea_len:-0} local.psid-offset ${local_psid:-0}"
  clat_cfg="${clat_cfg} remote.style ${remote_style:-RFC6052} remote.v4 ${remote_v4} remote.v6 ${remote_v6:-64:ff9b::/96}"
  clat_cfg="${clat_cfg} remote.ea-len ${remote_ea_len:-0} remote.psid-offset ${remote_psid:-0}"

  # create nat46 interface
  echo "add ${config}" > ${CTR}

  # configure nat46
  echo "${clat_cfg}" > ${CTR}

  [ "${ip4table}" ] && ip -4 rule add from ${local_v4} lookup ${ip4table}

  proto_init_update "${config}" 1

	  # add routes
	  case "${local_v6}" in
	    *:*/*)
	      proto_add_ipv6_route "${local_v6%%/*}" "${local_v6##*/}"
	    ;;
	    *:*)
	      proto_add_ipv6_route "${local_v6%%/*}" "128"
	    ;;
	  esac

	  case "${remote_v4}" in
	    *.*/*)
	      proto_add_ipv4_route "${remote_v4%%/*}" "${remote_v4##*/}" "" "" 2048
	    ;;
	    *.*)
	      proto_add_ipv4_route "${remote_v4%%/*}" "32" "" "" 2048
	    ;;
	  esac

	proto_add_data
	[ "${zone}" != "-" ] && json_add_string zone "${zone}"

	json_add_array firewall
	  # if forwarding within "zone" and between zone<->zone4 is allowed you can set zone = "-"
	  if [ "${zone}" != "-" ]; then
	  	json_add_object ""
	  		json_add_string type rule
	  		json_add_string family inet6
	  		json_add_string proto all
	  		json_add_string direction in
			json_add_string dest "${zone}"
			json_add_string src "${zone}"
	  		json_add_string src_ip "$local_v6"
	  		json_add_string target ACCEPT
	  	json_close_object
		# if a forwarding between zone and zone4 exists (e.g. lan<->wan) you can set zone4 = "-"
	  	if [ "${zone4}" != "-" ]; then
		  	json_add_object ""
		  		json_add_string type rule
		  		json_add_string family inet
		  		json_add_string proto all
		  		json_add_string direction out
				json_add_string dest "${zone}"
				[ "$remote_v4" != "0.0.0.0/0" ] && json_add_string dest_ip "$remote_v4"
				json_add_string src "${zone4}"
		  		json_add_string src_ip "$local_v4"
		  		json_add_string target ACCEPT
		  	json_close_object
	  	fi
	  fi

	json_close_array

	proto_close_data

  proto_send_update "$config"
}


proto_xlat464clat_teardown() {
  local config="$1"
  echo "del ${config}" > ${CTR}
}


[ -n "$INCLUDE_ONLY" ] || {
  add_protocol xlat464clat
}

