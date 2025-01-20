FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# if fw_env.config file is provided, it will be installed into ${sysconfigdir}
# - see u-boot.inc file
SRC_URI:append = " \
    file://uboot.txt.env \
"