include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-xlat464-plat
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include ../gluon.mk


define Package/gluon-xlat464-plat
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Support for sharing WAN IPv4 over IPv6-only networks using xlat464
  DEPENDS:=+gluon-core +kmod-nat46 +kmod-ipt-nat6
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/gluon-xlat464-plat/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) ./files/xlat464plat.sh $(1)/lib/netifd/proto/xlat464plat.sh
endef

define Package/gluon-xlat464-plat/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,gluon-xlat464-plat))

