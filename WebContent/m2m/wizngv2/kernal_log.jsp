<html>
   <head>
      <meta http-equiv="pragma" content="no-cache">
      <link href="css/fontawesome.css" rel="stylesheet">
      <link href="css/solid.css" rel="stylesheet">
      <link href="css/v4-shims.css" rel="stylesheet">
      <link rel="stylesheet" type="text/css" href="css/style.css">
      <script type="text/javascript">
	  function loadDoc() {
	document.getElementById("text").scrollTop = document.getElementById("text").scrollHeight;
}

function saveTextAsFile(textToWrite, fileNameToSaveAs) {
	var textFileAsBlob = new Blob([textToWrite], {
		type: 'text/plain'
	});
	var downloadLink = document.createElement("a");
	downloadLink.download = fileNameToSaveAs;
	downloadLink.innerHTML = "Download File";
	if (window.webkitURL != null) {
		downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
	} else {
		downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
		downloadLink.onclick = destroyClickedElement;
		downloadLink.style.display = "none";
		document.body.appendChild(downloadLink);
	}
	downloadLink.click();
}
	  </script>
      <style></style>
   </head>
   <body onload="loadDoc();">
      <center>
         <div>
            <p class="style1" align="center">Kernel Log</p>
            <br>
         </div>
         <textarea id="text" name="text" align="center" cols="100" rows="25" style="font-size:12px" readonly="readonly" wrap="off">
[    0.158387] AT91: Detected SoC: sama5d21, revision 2
[    0.159433] SCSI subsystem initialized
[    0.160051] usbcore: registered new interface driver usbfs
[    0.160173] usbcore: registered new interface driver hub
[    0.160354] usbcore: registered new device driver usb
[    0.178771] clocksource: Switched to clocksource timer@f800c000
[    0.181043] NET: Registered protocol family 2
[    0.182491] tcp_listen_portaddr_hash hash table entries: 512 (order: 0, 4096 bytes, linear)
[    0.182560] TCP established hash table entries: 2048 (order: 1, 8192 bytes, linear)
[    0.182625] TCP bind hash table entries: 2048 (order: 1, 8192 bytes, linear)
[    0.182685] TCP: Hash tables configured (established 2048 bind 2048)
[    0.182991] UDP hash table entries: 256 (order: 0, 4096 bytes, linear)
[    0.183051] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes, linear)
[    0.183550] NET: Registered protocol family 1
[    0.190455] workingset: timestamp_bits=30 max_order=16 bucket_order=0
[    0.307913] pinctrl-at91-pio4 fc038000.pinctrl: atmel pinctrl initialized
[    0.323848] brd: module loaded
[    0.335438] loop: module loaded
[    0.336928] atmel_usart_serial.0.auto: ttyS0 at MMIO 0xf801c000 (irq = 33, base_baud = 5187500) is a ATMEL_SERIAL
[    0.764670] printk: console [ttyS0] enabled
[    0.772267] atmel_usart_serial atmel_usart_serial.1.auto: Using FIFO (32 data)
[    0.779604] atmel_usart_serial.1.auto: ttyS1 at MMIO 0xf8034200 (irq = 170, base_baud = 5187500) is a ATMEL_SERIAL
[    0.793360] atmel_spi f8000000.spi: No TX DMA channel, DMA is disabled
[    0.799962] atmel_spi f8000000.spi: Atmel SPI Controller using PIO only
[    0.806618] atmel_spi f8000000.spi: Using FIFO (16 data)
[    0.819154] spi-nor spi0.0: found fm25q16, expected at25df321a
[    0.825089] spi-nor spi0.0: fm25q16 (2048 Kbytes)
[    0.832035] atmel_spi f8000000.spi: Atmel SPI Controller version 0x311 at 0xf8000000 (irq 27)
[    0.842251] libphy: Fixed MDIO Bus: probed
[    0.847336] DEBUG drivers/net/phy/dm8806.c:892 - dm8806_init()
[    0.853570] DEBUG drivers/net/phy/dm8806.c:808 - dm8806_probe()
[    0.859541] dm8806_switch_driver ahb:apb:dmsw8806: Couldn't find MII bus from handle
[    0.870504] macb f8008000.ethernet eth0: Cadence GEM rev 0x00020203 at 0xf8008000 irq 28 (00:22:85:aa:bb:dd)
[    0.881588] MACB_MDIO drivers/net/ethernet/cadence/macb_mdio.c:144 - macb_mdio_probe()
[    0.889973] libphy: macb_mii_bus: probed
[    0.907309] ####################### kdaemon_init #########################
[    0.907328] kdaemon major 251 
[    0.917800] WiZ_NG 2.0 initialised
[    0.921242] /proc/WiZ_NG/usbDebugs created
[    0.925271] /proc/WiZ_NG/modulePowerOn created
[    0.929743] /proc/WiZ_NG/modulePowerOff created
[    0.934206] /proc/WiZ_NG/moduleReset created
[    0.938456] /proc/WiZ_NG/productCode created
[    0.942748] /proc/WiZ_NG/simSelect created
[    0.946781] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.953317] ehci-atmel: EHCI Atmel driver
[    0.957743] atmel-ehci 500000.ehci: EHCI Host Controller
[    0.963206] atmel-ehci 500000.ehci: new USB bus registered, assigned bus number 1
[    0.973090] atmel-ehci 500000.ehci: irq 19, io mem 0x00500000
[    0.999890] atmel-ehci 500000.ehci: USB 2.0 started, EHCI 1.00
[    1.006118] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.04
[    1.014412] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.021604] usb usb1: Product: EHCI Host Controller
[    1.026417] usb usb1: Manufacturer: Linux 5.4.41-linux4sam-2020.04 ehci_hcd
[    1.033397] usb usb1: SerialNumber: 500000.ehci
[    1.039261] hub 1-0:1.0: USB hub found
[    1.043785] hub 1-0:1.0: 3 ports detected
[    1.049556] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.055735] ohci-platform: OHCI generic platform driver
[    1.061328] ohci-atmel: OHCI Atmel driver
[    1.066370] at91_ohci 400000.ohci: USB Host Controller
[    1.071701] at91_ohci 400000.ohci: new USB bus registered, assigned bus number 2
[    1.081392] at91_ohci 400000.ohci: irq 19, io mem 0x00400000
[    1.154370] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.04
[    1.162652] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.169858] usb usb2: Product: USB Host Controller
[    1.174573] usb usb2: Manufacturer: Linux 5.4.41-linux4sam-2020.04 ohci_hcd
[    1.181547] usb usb2: SerialNumber: at91
[    1.186819] hub 2-0:1.0: USB hub found
[    1.191343] hub 2-0:1.0: 2 ports detected
[    1.197897] usbcore: registered new interface driver cdc_acm
[    1.203635] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    1.211895] usbcore: registered new interface driver usb-storage
[    1.218124] usbcore: registered new interface driver usbserial_generic
[    1.224768] usbserial: USB Serial support registered for generic
[    1.230863] usbcore: registered new interface driver ftdi_sio
[    1.236596] usbserial: USB Serial support registered for FTDI USB Serial Device
[    1.244213] usbcore: registered new interface driver pl2303
[    1.249890] usbserial: USB Serial support registered for pl2303
[    1.255879] usbcore: registered new interface driver qcaux
[    1.261453] usbserial: USB Serial support registered for qcaux
[    1.267308] usbcore: registered new interface driver qcserial
[    1.273121] usbserial: USB Serial support registered for Qualcomm USB modem
[    1.280337] i2c /dev entries driver
[    1.284764] at91-reset f8048000.rstc: Starting after user reset
[    1.293040] sama5d4_wdt f8048040.watchdog: initialized (timeout = 16 sec, nowayout = 0)
[    1.302413] sdhci: Secure Digital Host Controller Interface driver
[    1.308521] sdhci: Copyright(c) Pierre Ossman
[    1.313235] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.365533] mmc0: SDHCI controller on b0000000.sdio-host [b0000000.sdio-host] using ADMA
[    1.374572] usbcore: registered new interface driver usbhid
[    1.380190] usbhid: USB HID core driver
[    1.387077] NET: Registered protocol family 10
[    1.400435] Segment Routing with IPv6
[    1.404210] NET: Registered protocol family 17
[    1.435064] at91_i2c fc028000.i2c: can't get DMA channel, continue without DMA support
[    1.443083] at91_i2c fc028000.i2c: Using FIFO (16 data)
[    1.448362] at91_i2c fc028000.i2c: recovery information incomplete
[    1.461374] rtc-ds1307 1-0068: registered as rtc0
[    1.466247] at91_i2c fc028000.i2c: AT91 i2c bus driver (hw version: 0x704).
[    1.473633] DEBUG drivers/net/phy/dm8806.c:808 - dm8806_probe()
[    1.479631] DEBUG vendor a46
[    1.482446] DEBUG product 8606
[    1.485478] ahb:apb:dmsw8806: Davicom DM8806 model PHY found.
[    1.493261] usb 1-2: new high-speed USB device number 2 using atmel-ehci
[    1.503299] rtc-ds1307 1-0068: setting system clock to 2000-01-01T00:00:11 UTC (946684811)
[    1.513862] atmel_usart_serial atmel_usart_serial.0.auto: using dma0chan0 for rx DMA transfers
[    1.524237] atmel_usart_serial atmel_usart_serial.0.auto: using dma0chan1 for tx DMA transfers
[    1.533595] Waiting for root device /dev/mmcblk0...
[    1.553781] mmc0: new high speed MMC card at address 0001
[    1.561636] mmcblk0: mmc0:0001 Q2J54A 3.59 GiB 
[    1.567143] mmcblk0boot0: mmc0:0001 Q2J54A partition 1 16.0 MiB
[    1.574195] mmcblk0boot1: mmc0:0001 Q2J54A partition 2 16.0 MiB
[    1.580572] mmcblk0rpmb: mmc0:0001 Q2J54A partition 3 512 KiB, chardev (250:0)
[    1.630297] EXT4-fs (mmcblk0): warning: mounting unchecked fs, running e2fsck is recommended
[    1.650085] random: fast init done
[    1.700528] usb 1-2: New USB device found, idVendor=0424, idProduct=9e00, bcdDevice= 3.00
[    1.708722] usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.717971] EXT4-fs (mmcblk0): mounted filesystem without journal. Opts: (null)
[    1.725566] VFS: Mounted root (ext4 filesystem) on device 179:0.
[    1.735466] Freeing unused kernel memory: 1024K
[    1.742688] Run /sbin/init as init process
[    1.884571] init: Console is alive
[    1.888461] init: - watchdog -
[    2.068369] kmodloader: loading kernel modules from /etc/modules-boot.d/*
[    2.096128] ehci-fsl: Freescale EHCI Host controller driver
[    2.109001] ehci-platform: EHCI generic platform driver
[    2.130056] kmodloader: done loading kernel modules from /etc/modules-boot.d/*
[    2.149221] init: - preinit -
[    2.624325] random: jshn: uninitialized urandom read (4 bytes read)
[    2.708757] random: jshn: uninitialized urandom read (4 bytes read)
[    2.768114] random: jshn: uninitialized urandom read (4 bytes read)
[    2.845750] macb f8008000.ethernet eth0: configuring for fixed/mii link mode
[    2.862699] macb f8008000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
[    2.887667] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    6.254093] mount_root: mounting /dev/root
[    6.260972] EXT4-fs (mmcblk0): re-mounted. Opts: (null)
[    6.270715] urandom-seed: Seeding with /etc/urandom.seed
[    6.359069] macb f8008000.ethernet eth0: Link is Down
[    6.394779] procd: - early -
[    6.397910] procd: - watchdog -
[    7.049129] procd: - watchdog -
[    7.052814] procd: - ubus -
[    7.081849] random: ubusd: uninitialized urandom read (4 bytes read)
[    7.111109] random: ubusd: uninitialized urandom read (4 bytes read)
[    7.118234] random: ubusd: uninitialized urandom read (4 bytes read)
[    7.126625] procd: - init -
[    8.102164] kmodloader: loading kernel modules from /etc/modules.d/*
[    8.140446] urngd: v1.0.2 started.
[    8.156340] NET: Registered protocol family 38
[    8.213393] NET: Registered protocol family 15
[    8.244798] Initializing XFRM netlink socket
[    8.509146] random: crng init done
[    8.512641] random: 4 urandom warning(s) missed due to ratelimiting
[    8.610623] usbcore: registered new interface driver cdc_wdm
[    8.714261] usbcore: registered new interface driver option
[    8.720124] usbserial: USB Serial support registered for GSM modem (1-port)
[    8.846464] xt_time: kernel timezone is -0000
[    8.861763] usbcore: registered new interface driver cdc_eem
[    8.882873] usbcore: registered new interface driver cdc_ether
[    8.903814] usbcore: registered new interface driver cdc_ncm
[    8.919164] usbcore: registered new interface driver cdc_subset
[    8.943001] usbcore: registered new interface driver dm9601
[    9.012049] PPP generic driver version 2.4.2
[    9.032372] NET: Registered protocol family 24
[    9.056592] usbcore: registered new interface driver qmi_wwan
[    9.082996] usbcore: registered new interface driver rndis_host
[    9.104186] smsc95xx v1.0.6
[    9.219128] smsc95xx 1-2:1.0 eth1: register 'smsc95xx' at usb-500000.ehci-2, smsc95xx USB 2.0 Ethernet, 00:22:85:11:22:33
[    9.230551] usbcore: registered new interface driver smsc95xx
[    9.337747] usbcore: registered new interface driver cdc_mbim
[    9.421716] kmodloader: done loading kernel modules from /etc/modules.d/*
[   10.620286] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   10.632255] EXT4-fs (mmcblk0): Remounting filesystem read-only
[   17.170591] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   17.230307] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   17.254271] Turn ON the MODULE .... 
[   17.799970] macb f8008000.ethernet eth0: configuring for fixed/mii link mode
[   17.816536] macb f8008000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
[   17.949398] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   18.490019] usb 1-1: new high-speed USB device number 3 using atmel-ehci
[   18.705219] usb 1-1: New USB device found, idVendor=1286, idProduct=812a, bcdDevice= 0.00
[   18.713475] usb 1-1: New USB device strings: Mfr=3, Product=2, SerialNumber=0
[   18.720618] usb 1-1: Product: WUKONG
[   18.724142] usb 1-1: Manufacturer: MARVELL
[   19.996200] usb 1-1: USB disconnect, device number 3
[   24.769819] usb 1-1: new high-speed USB device number 4 using atmel-ehci
[   24.970872] usb 1-1: New USB device found, idVendor=2c7c, idProduct=6026, bcdDevice= 3.18
[   24.979090] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   24.986153] usb 1-1: Product: Android
[   24.989862] usb 1-1: Manufacturer: Android
[   24.993911] usb 1-1: SerialNumber: 0000
[   25.006914] cdc_ether 1-1:1.0 usb0: register 'cdc_ether' at usb-500000.ehci-1, CDC Ethernet Device, 02:0c:29:a3:9b:6d
[   25.040251] option 1-1:1.2: GSM modem (1-port) converter detected
[   25.047128] usb 1-1: GSM modem (1-port) converter now attached to ttyUSB0
[   25.073727] option 1-1:1.3: GSM modem (1-port) converter detected
[   25.080744] usb 1-1: GSM modem (1-port) converter now attached to ttyUSB1
[   25.109846] option 1-1:1.4: GSM modem (1-port) converter detected
[   25.116762] usb 1-1: GSM modem (1-port) converter now attached to ttyUSB2
[   25.123813] 
[   25.123813] Quectel 4G USB Modem UP ... 
[   25.129231] Cannot find pid from user program ...
[   33.779799] ModuleStatus == 0 
[   33.782829] Turn ON the MODULE Completed.
[   33.939713] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   33.974542] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   34.000819] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   34.027117] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   34.429607] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   34.561613] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   34.693000] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   34.864400] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   35.130910] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   35.164768] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   41.219962] macb f8008000.ethernet eth0: Link is Down
[   46.641788] m2mconfig: uci configuration loaded
[   46.647493] m2mconfig: Configured M2M Activation 'OFF' Server 192.168.1.2:445 interval 1 timeout 10 interface any model WiZ_NG 
[   67.006003] macb f8008000.ethernet eth0: configuring for fixed/mii link mode
[   67.023299] macb f8008000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
[   67.050025] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   75.968753] EXT4-fs error: 10 callbacks suppressed
[   75.968782] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   86.053940] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[   96.135119] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  106.230665] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  106.869869] m2mconfig: uloop timeout
[  116.343026] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  126.423800] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  136.503166] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  146.583362] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  156.687798] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  166.768021] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  176.846341] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  186.926572] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  197.022863] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  207.148711] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  217.229174] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  227.311149] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  237.392003] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  247.472387] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  257.553159] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  267.634607] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  277.716052] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  287.796262] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  297.914059] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  307.993237] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  318.074190] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  328.153678] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  338.235437] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  348.317195] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  358.398181] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  368.478333] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  378.558065] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  379.005740] macb f8008000.ethernet eth0: Link is Down
[  388.638300] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  398.718054] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  408.798036] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  418.879058] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  428.960384] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  439.070595] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  449.151219] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  450.849796] K_SW_PRESS 
[  451.349345] PushButtonErrorFlag 
[  459.232083] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  469.313151] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  470.137613] macb f8008000.ethernet eth0: configuring for fixed/mii link mode
[  470.154878] macb f8008000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
[  470.210121] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  479.393171] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  489.473219] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  499.553227] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  509.633242] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  519.714132] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  529.795884] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  539.875876] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  550.006090] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  560.087895] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  570.166899] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  580.320394] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  590.422328] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  600.503185] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  610.583089] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  620.663932] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  630.742909] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  640.822987] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  649.756373] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[  650.940292] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  661.121480] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  671.202487] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  681.282908] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  691.394019] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  701.473683] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  711.553174] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  721.633308] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  731.713011] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  741.795561] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  751.876017] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  761.956312] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  772.037448] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  782.151201] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  792.326186] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  802.406744] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  812.486783] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  814.870475] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[  822.567588] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  832.647431] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  842.727234] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  852.807524] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  862.887295] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  872.980916] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  883.108481] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  893.189565] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  903.271679] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  903.787314] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[  913.366022] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  923.529649] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  933.611471] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  943.692299] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  953.773384] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  963.866397] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  974.153319] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  984.233366] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[  994.313743] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1004.393045] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1014.473167] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1024.556046] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1034.636594] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1044.716508] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1054.817990] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1064.950930] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1075.031959] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1085.112825] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1095.193437] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1105.275890] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1115.357884] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1125.438386] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1135.518447] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1145.599603] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1155.681174] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1165.762129] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1175.842524] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1185.939370] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1196.020027] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1206.101045] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1216.183250] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1226.263301] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1236.345633] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1246.426149] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1256.506455] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1266.586543] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1276.666076] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1286.745702] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1296.825833] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1306.905947] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1316.985739] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1327.072784] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1337.153299] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1347.271054] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1357.446045] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1367.526323] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1377.606575] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1387.686642] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1397.766993] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1407.847705] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1417.928154] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1428.008116] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1438.089112] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1448.170508] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1458.270576] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1468.351564] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1478.455638] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1488.535546] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1498.616021] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1508.696682] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1518.776610] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1528.856594] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1538.937145] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1549.033071] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1559.166034] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1569.246290] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1579.326262] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1589.406175] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1599.485919] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1609.566592] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1619.647041] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1629.726964] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1639.807460] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1649.969722] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1660.131674] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1670.257013] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1680.736234] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1690.868501] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1700.991209] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1711.316353] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1721.461403] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1731.718753] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1741.815241] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1752.038129] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1762.170145] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1772.407287] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1782.490761] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1792.622730] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1802.727100] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1812.886156] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1822.971705] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1833.108152] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1843.188104] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1853.268568] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1863.351876] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1873.585596] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1883.665239] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1893.746163] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1903.826378] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1913.920481] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1924.113248] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1934.193718] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1944.273499] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1954.353359] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1964.433406] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1974.513454] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1984.610961] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 1994.772558] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2004.921297] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2015.216118] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2025.296203] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2035.376145] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2045.456278] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2055.537132] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2065.617206] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2075.708076] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2085.885712] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2096.011255] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2106.268160] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2116.348441] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2126.429701] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2136.511049] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2146.593443] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2156.673722] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2166.790945] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2176.987008] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2187.110233] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2197.289971] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2207.541117] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2217.783091] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2227.863332] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2237.956319] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2248.088729] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2258.211601] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2268.430999] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2278.580515] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2288.706329] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2298.826093] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2308.918164] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2318.999408] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2329.139376] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2339.393286] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2349.530813] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2359.708843] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2369.801167] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2380.154008] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2390.233762] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2400.313512] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2410.397224] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2420.551737] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2430.798790] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2440.935364] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2451.202040] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2461.281109] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2471.383039] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2481.464364] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2491.544411] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2501.726448] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2511.893716] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2521.997510] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2532.213762] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2542.501821] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2552.649173] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2562.762206] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2572.843953] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2582.923593] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2593.085354] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2603.165217] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2613.245357] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2623.326441] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2633.429316] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2643.581181] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2653.745637] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2663.925516] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2673.586365] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2673.610006] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2673.622970] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2673.636869] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2673.649954] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2673.662694] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2673.676561] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2673.690025] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2673.702756] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2673.716617] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2684.390191] EXT4-fs error: 6 callbacks suppressed
[ 2684.390219] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2685.915597] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2685.938737] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2685.951469] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2685.965318] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2685.978292] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2685.991661] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2686.005074] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2686.018503] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2686.031955] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.659113] EXT4-fs error: 6 callbacks suppressed
[ 2692.659142] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.687198] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.700681] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.713377] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.726756] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.740138] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.752800] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.766599] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.780001] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2692.792756] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.528578] EXT4-fs error: 6 callbacks suppressed
[ 2699.528608] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.559083] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.590595] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.611321] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.630750] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.661098] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.681280] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.711826] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.724654] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2699.738537] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2704.610709] EXT4-fs error: 5 callbacks suppressed
[ 2704.610738] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2706.642454] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2706.680744] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2706.720175] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2706.760838] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2706.796816] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2706.830801] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2706.870560] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2706.909995] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2706.950949] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2713.946031] EXT4-fs error: 6 callbacks suppressed
[ 2713.946059] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2713.980932] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2714.010935] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2714.031351] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2714.060331] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2714.082259] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2714.120730] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2714.160574] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2714.185883] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2714.220776] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.067406] EXT4-fs error: 6 callbacks suppressed
[ 2721.067436] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.141074] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.209826] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.260809] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.299507] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.330871] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.370301] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.391350] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.411255] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2721.440909] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.152533] EXT4-fs error: 6 callbacks suppressed
[ 2728.152562] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.230876] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.300812] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.350779] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.390459] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.440859] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.490759] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.540778] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.570805] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2728.600679] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2734.880824] EXT4-fs error: 5 callbacks suppressed
[ 2734.880854] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2745.120719] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2755.278703] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2765.359977] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2775.441744] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2785.581489] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2795.827997] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2805.908180] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2815.988195] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2826.086949] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2826.620649] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2835.456591] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2836.241066] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2846.434397] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2856.514252] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2866.625540] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2866.954845] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2876.824796] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2886.905470] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2897.026745] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2897.552569] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2897.599514] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2897.695365] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2897.782220] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2897.841731] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2897.880839] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2897.920268] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2897.966332] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2898.040456] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm Nomus.cgi: deleted inode referenced: 516
[ 2907.445329] EXT4-fs error: 6 callbacks suppressed
[ 2907.445357] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2917.687641] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2928.078986] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2938.159420] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2948.243451] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2958.323864] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2968.434933] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2978.515007] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2988.594975] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 2998.674931] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3008.774665] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3018.863257] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3028.945394] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3039.025560] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3049.136430] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3059.325383] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3069.405311] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3079.513154] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3089.593480] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3099.675632] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3109.759394] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3120.003354] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3130.083244] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
[ 3140.163207] EXT4-fs error (device mmcblk0): ext4_lookup:1705: inode #98: comm uci: deleted inode referenced: 516
</textarea>
         <div>
            <form action="Nomus.cgi?cgi=KernelLog.cgi" method="post" onsubmit=""><button type="submit" id="Refresh" name="Refresh" class="button">Refresh &nbsp;<i class="fa fa-refresh" aria-hidden="true" style="display:inline;font-size:10px;color:white"></i></button><label class="button" style="font-size:13.5px;font-family: Arial, Helvetica, sans-serif;font-weight:bold;" onclick="saveTextAsFile(text.value,'kernel-WiZ_NG-01-January-2000.log')">Export Log &nbsp;<i class="fa fa-download" aria-hidden="true" style="display:inline;font-size:10px; color:white"></i></label></form>
         </div>
      </center>
   </body>
</html>