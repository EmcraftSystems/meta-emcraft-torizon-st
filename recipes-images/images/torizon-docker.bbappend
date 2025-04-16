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
