include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-web-prefixd
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include ../gluon.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)


define Package/gluon-web-prefixd
  SECTION:=gluon
  CATEGORY:=Gluon
  DEPENDS:=+gluon-web-admin
  TITLE:=UI for activating the sharing of an IPv6 prefix in the mesh
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonBuildI18N,gluon-web-prefixd,i18n)
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/gluon-web-prefixd/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(call GluonInstallI18N,gluon-web-prefixd,$(1))
endef

$(eval $(call BuildPackage,gluon-web-prefixd))
