IMAGE_ROOTFS_MAXSIZE = "2500000"

# NOTE: ignore OTA bootloader until the recipe is implemented
UBOOT_BINARY_OTA_IGNORE:stm32mp25-eval = "1"

IMAGE_FSTYPES:append:stm32mp25-eval = " teziimg"
TEZI_USE_BOOTFILES:stm32mp25-eval = "false"
UBOOT_BINARY_TEZI_EMMC:stm32mp25-eval = "fip/fip-stm32mp257f-ev1-optee-emmc.bin"
OFFSET_BOOTROM_PAYLOAD:stm32mp25-eval = "0"
TORADEX_PRODUCT_IDS:stm32mp25-eval = "0100"
UBOOT_ENV_TEZI_EMMC:stm32mp25-eval = ""

# NOTE: ignore OTA bootloader until the recipe is implemented
UBOOT_BINARY_OTA_IGNORE:stm32mp25-disco = "1"

IMAGE_FSTYPES:append:stm32mp25-disco = " teziimg"
TEZI_USE_BOOTFILES:stm32mp25-disco = "false"
UBOOT_BINARY_TEZI_EMMC:stm32mp25-disco = "fip/fip-stm32mp257f-dk-optee-emmc.bin"
OFFSET_BOOTROM_PAYLOAD:stm32mp25-disco = "0"
TORADEX_PRODUCT_IDS:stm32mp25-disco = "0100"
UBOOT_ENV_TEZI_EMMC:stm32mp25-disco = ""

# NOTE: ignore OTA bootloader until the recipe is implemented
UBOOT_BINARY_OTA_IGNORE:stm32mp15-disco = "1"

IMAGE_FSTYPES:append:stm32mp15-disco = " teziimg"
TEZI_USE_BOOTFILES:stm32mp15-disco = "false"
UBOOT_BINARY_TEZI_EMMC:stm32mp15-disco = "fip/fip-stm32mp157f-dk2-optee-sdcard.bin"
OFFSET_BOOTROM_PAYLOAD:stm32mp15-disco = "0"
TORADEX_PRODUCT_IDS:stm32mp15-disco = "0100"
UBOOT_ENV_TEZI_EMMC:stm32mp15-disco = ""

CORE_IMAGE_BASE_INSTALL:append:stm32mp2common = " \
    set-hostname \
"

def make_dtb_boot_files(d):
    # Generate IMAGE_BOOT_FILES entries for device tree files listed in
    # KERNEL_DEVICETREE.
    # Use only the basename for dtb files:
    alldtbs = d.getVar('KERNEL_DEVICETREE')


    # DTBs may be built out of kernel with devicetree.bbclass
    if not alldtbs:
        return ''

    def transform(dtb):
        if not (dtb.endswith('dtb') or dtb.endswith('dtbo')):
            # eg: whatever/bcm2708-rpi-b.dtb has:
            #     DEPLOYDIR file: bcm2708-rpi-b.dtb
            #     destination: bcm2708-rpi-b.dtb
            bb.error("KERNEL_DEVICETREE entry %s is not a .dtb or .dtbo file." % (dtb) )
        return os.path.basename(dtb)

    return ' '.join([transform(dtb) for dtb in alldtbs.split() if dtb])


def partImage2partConfig(d, config, fstype=None):
    """
    Convert PARTTIONS_IMAGES['config'] setting format to format expected to feed
    PARTITIONS_CONFIG[xxx].
    Manage <image_name> update respect to 'fstype' provided and apply the rootfs
    namming or standard partition image one.
        FROM: <image_name>,<partition_label>,<mountpoint>,<size>,<type>
        TO  : <binary_name>,<partition_label>,<size>,<type>
    """
    items = d.getVarFlag('PARTITIONS_IMAGES', config).split(',') or ""
    if len(items) != 5:
        bb.fatal('[partImage2partConfig] Wrong settings for PARTTIONS_IMAGES[%s] : %s' % (config, items))
    overrides = d.getVar('OVERRIDES')
    if items[2] == '' and 'openstlinuxcommon' not in overrides.split(':'):
        bin_suffix = '-${MACHINE}'
    else:
        bin_suffix = '-${DISTRO}-${MACHINE}'
    if fstype:
        bin_name = items[0] + bin_suffix + '.' + fstype
    else:
        bin_name = items[0] + bin_suffix
    # Set string for PARTITIONS_CONFIG item: <binary_name>,<partlabel>,<size>,<type>
    part_format = bin_name + ',' + items[1] + ',' + items[3] + ',' + items[4]
    return part_format
