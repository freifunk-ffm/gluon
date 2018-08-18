include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-mesh-vpn-wireguard
PKG_VERSION:=3

include ../gluon.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)

define Package/gluon-mesh-vpn-wireguard
  TITLE:=gluon-mesh-vpn-wireguard
  DEPENDS:=+gluon-core +ip +kmod-wireguard +wireguard-tools +kmod-udptunnel6 +kmod-ipt-hashlimit +netcat +micrond
endef

$(eval $(call BuildPackageGluon,gluon-mesh-vpn-wireguard))
