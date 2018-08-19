include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-web-mesh-vpn-wireguard
PKG_VERSION:=1
PKG_RELEASE:=1

include ../gluon.mk

define Package/gluon-web-mesh-vpn-wireguard
  TITLE:=gluon-web module to configure wireguard if there ever is a configuration to be made
  DEPENDS:=+gluon-web-admin +gluon-mesh-vpn-wireguard
endef

$(eval $(call BuildPackageGluon,gluon-web-mesh-vpn-wireguard))
