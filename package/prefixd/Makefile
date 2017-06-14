include $(TOPDIR)/rules.mk

PKG_NAME:=prefixd
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
PKG_BUILD_DEPENDS := respondd
# while respondd is not strictliy necessary at the moment, it will soon be
# because the shared prefix will be part of the respondd data.

include ../gluon.mk

define Package/prefixd
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=prefixd
  DEPENDS:=+gluon-mesh-babel +ip-tiny +uc
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/prefixd/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,prefixd))

