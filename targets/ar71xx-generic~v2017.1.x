ATH10K_PACKAGES=
ATH10K_PACKAGES_QCA9887=

if [ "$GLUON_ATH10K_MESH" = '11s' ]; then
	ATH10K_PACKAGES='-kmod-ath10k kmod-ath10k-ct'
fi
if [ "$GLUON_ATH10K_MESH" = 'ibss' ]; then
	ATH10K_PACKAGES='-kmod-ath10k kmod-ath10k-ct -ath10k-firmware-qca988x ath10k-firmware-qca988x-ct'
	ATH10K_PACKAGES_QCA9887='-kmod-ath10k kmod-ath10k-ct -ath10k-firmware-qca9887 ath10k-firmware-qca9887-ct'
fi


# 8devices

device 8devices-carambola2-board carambola2
factory


# ALFA NETWORK

device alfa-network-hornet-ub hornet-ub HORNETUB
alias alfa-network-ap121
alias alfa-network-ap121u

device alfa-network-tube2h tube2h-8M TUBE2H8M
device alfa-network-n2-n5 alfa-nx ALFANX


# Allnet

device allnet-all0315n all0315n ALL0315N
factory


# Buffalo

device buffalo-wzr-hp-g300nh wzr-hp-g300nh WZRHPG300NH
device buffalo-wzr-hp-g300nh2 wzr-hp-g300nh2 WZRHPG300NH2
device buffalo-wzr-hp-g450h wzr-hp-g450h WZRHPG450H


device buffalo-wzr-hp-ag300h wzr-hp-ag300h WZRHPAG300H
sysupgrade
device buffalo-wzr-600dhp wzr-600dhp WZR600DHP
sysupgrade
sysupgrade_image buffalo-wzr-hp-ag300h-wzr-600dhp wzr-hp-ag300h-squashfs-sysupgrade .bin


# D-Link

device d-link-dir-505-rev-a1 dir-505-a1 DIR505A1
alias d-link-dir-505-rev-a2

device d-link-dir-825-rev-b1 dir-825-b1 DIR825B1
factory


# GL Innovations

device gl-inet-6408a-v1 gl-inet-6408A-v1
device gl-inet-6416a-v1 gl-inet-6416A-v1

device gl-ar150 gl-ar150
factory
device gl-ar300m gl-ar300m
factory


# Linksys by Cisco

device linksys-wrt160nl wrt160nl WRT160NL


# Meraki

# BROKEN: MAC address uniqueness issues
if [ "$BROKEN" ]; then
device meraki-mr12 mr12
alias meraki-mr62
factory

device meraki-mr16 mr16
alias meraki-mr66
factory
fi


# Netgear

device netgear-wndr3700 wndr3700
factory .img

device netgear-wndr3700v2 wndr3700v2
factory .img

device netgear-wndr3800 wndr3800
factory .img

device netgear-wndrmacv2 wndrmacv2
factory .img

if [ "$BROKEN" ]; then
device netgear-wndrmac wndrmac # BROKEN: untested
factory .img

device netgear-wnr2200 wnr2200 WNR2200 # BROKEN: untested
factory .img
fi


# Onion

device onion-omega onion-omega


# OpenMesh

if [ "$ATH10K_PACKAGES" ]; then
device openmesh-mr1750 mr1750 MR1750
alias openmesh-mr1750v2
packages $ATH10K_PACKAGES
fi

device openmesh-mr600 mr600 MR600
alias openmesh-mr600v2

device openmesh-mr900 mr900 MR900
alias openmesh-mr900v2

device openmesh-om2p om2p OM2P
alias openmesh-om2pv2
alias openmesh-om2p-hs
alias openmesh-om2p-hsv2
alias openmesh-om2p-hsv3
alias openmesh-om2p-lc

device openmesh-om5p om5p OM5P
alias openmesh-om5p-an

if [ "$ATH10K_PACKAGES" ]; then
device openmesh-om5p-ac om5pac OM5PAC
alias openmesh-om5p-acv2
packages $ATH10K_PACKAGES
fi


# TP-Link

device tp-link-cpe210-v1.0 cpe210-220
alias tp-link-cpe210-v1.1
alias tp-link-cpe220-v1.1

device tp-link-cpe510-v1.0 cpe510-520
alias tp-link-cpe510-v1.1
alias tp-link-cpe520-v1.1

device tp-link-wbs210-v1.20 wbs210
device tp-link-wbs510-v1.20 wbs510

device tp-link-tl-wr710n-v1 tl-wr710n-v1
device tp-link-tl-wr710n-v2.1 tl-wr710n-v2.1

device tp-link-tl-wr842n-nd-v1 tl-wr842n-v1
device tp-link-tl-wr842n-nd-v2 tl-wr842n-v2
device tp-link-tl-wr842n-nd-v3 tl-wr842n-v3

device tp-link-tl-wr1043n-nd-v1 tl-wr1043nd-v1
device tp-link-tl-wr1043n-nd-v2 tl-wr1043nd-v2
device tp-link-tl-wr1043n-nd-v3 tl-wr1043nd-v3
device tp-link-tl-wr1043n-nd-v4 tl-wr1043nd-v4

device tp-link-tl-wdr3500-v1 tl-wdr3500-v1
device tp-link-tl-wdr3600-v1 tl-wdr3600-v1
device tp-link-tl-wdr4300-v1 tl-wdr4300-v1

device tp-link-tl-wr2543n-nd-v1 tl-wr2543-v1

if [ "$ATH10K_PACKAGES" ]; then
device tp-link-archer-c5-v1 archer-c5-v1
packages $ATH10K_PACKAGES

device tp-link-archer-c7-v2 archer-c7-v2
packages $ATH10K_PACKAGES
factory -squashfs-factory${GLUON_REGION:+-${GLUON_REGION}} .bin

if [ "$BROKEN" ]; then
device tp-link-archer-c25-v1 archer-c25-v1 # instability with 5GHz mesh in some environments
packages $ATH10K_PACKAGES_QCA9887
fi

device tp-link-re450 re450
packages $ATH10K_PACKAGES
fi


# Ubiquiti

device ubiquiti-airgateway ubnt-air-gateway
alias ubiquiti-airgateway-lr

device ubiquiti-airgateway-pro ubnt-air-gateway-pro

device ubiquiti-airrouter ubnt-airrouter

device ubiquiti-bullet-m ubnt-bullet-m
alias ubiquiti-nanostation-loco-m2
alias ubiquiti-nanostation-loco-m5
alias ubiquiti-rocket-m2
alias ubiquiti-rocket-m5
alias ubiquiti-bullet-m2
alias ubiquiti-bullet-m5
alias ubiquiti-picostation-m2

device ubiquiti-nanostation-m ubnt-nano-m
alias ubiquiti-nanostation-m2
alias ubiquiti-nanostation-m5

device ubiquiti-loco-m-xw ubnt-loco-m-xw
alias ubiquiti-nanostation-loco-m2-xw
alias ubiquiti-nanostation-loco-m5-xw

device ubiquiti-nanostation-m-xw ubnt-nano-m-xw
alias ubiquiti-nanostation-m2-xw
alias ubiquiti-nanostation-m5-xw

device ubiquiti-rocket-m-xw ubnt-rocket-m-xw
alias ubiquiti-rocket-m2-xw
alias ubiquiti-rocket-m5-xw

device ubiquiti-rocket-m-ti ubnt-rocket-m-ti
alias ubiquiti-rocket-m2-ti
alias ubiquiti-rocket-m5-ti

device ubiquiti-unifi ubnt-unifi
alias ubiquiti-unifi-ap
alias ubiquiti-unifi-ap-lr

device ubiquiti-unifi-ap-pro ubnt-uap-pro
device ubiquiti-unifiap-outdoor ubnt-unifi-outdoor
device ubiquiti-unifiap-outdoor+ ubnt-unifi-outdoor-plus

if [ "$BROKEN" ]; then
device ubiquiti-ls-sr71 ubnt-ls-sr71 # BROKEN: Untested
fi

if [ "$ATH10K_PACKAGES" ]; then
device ubiquiti-unifi-ac-lite ubnt-unifiac-lite
packages $ATH10K_PACKAGES
factory

device ubiquiti-unifi-ac-pro ubnt-unifiac-pro
packages $ATH10K_PACKAGES
factory
fi


# Western Digital

device wd-my-net-n600 mynet-n600
device wd-my-net-n750 mynet-n750
