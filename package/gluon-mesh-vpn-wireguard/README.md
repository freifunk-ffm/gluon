# gluon-mesh-vpn-wireguard

This package will allow wireguard [1] to be used in gluon.

[1] https://wireguard.io

## including servers via site.conf
This is similar to the batman-based mesh_vpn structure.

```
          mesh_vpn = {
                  mtu = 1374,

                  wireguard = {
                          configurable = '1',
                          enabled = '1',
                          groups = {
                                  backbone = {
                                          limit = '2', -- currently unused
                                          peers = {
                                                  gw02 = {
                                                          iface = 'wg-mesh-gw02',
                                                          enabled = '1',
                                                          PublicKey ='bog2DzyiC0Os7y1GloEw0afb8bLdZ9SzVQCd44Eock4=',
                                                          remote = 'gw02.babel.ffm.freifunk.net:40100',
                                                          broker = 'gw02.babel.ffm.freifunk.net:40101',
                                                  },
                                          },
                                  },
                          },
                  },
          },

```

## serverside actions
* The wireguard private key must be deployed, and the derived Public Key has to be in site.conf
* The wg-broker must be running on the server

## Things to do:

* config-mode advance : make server/peer configurable
* forbid freifunk tunnel inside freifunk (hopefully done in general, also need to forbid it if router has uplink on yellow which is accidental by itself)
* automatism for deactivating / activating if br-wan is active
