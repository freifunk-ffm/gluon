include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-xlat464-clat
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include ../gluon.mk


define Package/gluon-xlat464-clat
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Support for using IPv4 over IPv6-only networks using xlat464
  DEPENDS:=+gluon-core +kmod-nat46
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/gluon-xlat464-clat/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) ./files/xlat464clat.sh $(1)/lib/netifd/proto/xlat464clat.sh
endef

define Package/gluon-xlat464-clat/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,gluon-xlat464-clat))

