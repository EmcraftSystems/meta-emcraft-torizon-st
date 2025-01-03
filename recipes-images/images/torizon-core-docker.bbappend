IMAGE_ROOTFS_MAXSIZE = "1650000"

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
