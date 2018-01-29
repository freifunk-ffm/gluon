include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-ddhcpd
PKG_VERSION:=1

include ../gluon.mk

define Package/gluon-ddhcpd
  TITLE:=Configure ddhcp for gluon
  DEPENDS:=+gluon-core +ddhcpd
endef

$(eval $(call BuildPackageGluon,gluon-ddhcpd))
