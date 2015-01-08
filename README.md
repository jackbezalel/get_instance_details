osinfo
====================

osinfo

This tool will acquire important hardware and operating system details of an instance of Operating System, Virtual Machine, Appliance, Container or any other popular system that allows operation of programs.

Details could include hardware or virtual hardware attributes, as well as operating system or firmware attributes.

For now this tool will focus on Unix and Linux variants Operating Systems only.

Supported Platforms:

1. Solaris 8,9,10,11, including LDOMs and all kinds of Zones on all hardware types
2. Redhat Linux on all Hardware types

How to use osinfo.sh:

Login to the system as root
mount OSINFO tool directory via NFS
cd to the osinfo directory
./osinfo.sh

This tool will NOT show virtual network cards – it is aimed to point to physical devices only.
On Solaris zones it will not allow operation since it takes all its resources from the host machine.

Sample run on Solaris:

Vendor=SunOS
Major Version=5.11
ZONE global
Machine sol11svr OSINFO will be reported at /patches/machines/OSINFO/sol11svr/201501061915
CPU:        8
MEM: Memory size: 4096 Megabytes
DISK: 0. c0t5000CCA03C3BB5B4d0 <HITACHI-H106030SDSUN300G-A2B0-279.40GB>
DISK: 1. c0t5000CCA03C3BB8E0d0 <HITACHI-H106030SDSUN300G-A2B0-279.40GB>
DISK: 2. c0t6005076D02810005400000000000002Ed0 <IBM-2145-0000-1.00TB>
LAN: LINK                CLASS     MTU    STATE    OVER
LAN: net1                phys      1500   unknown  --
LAN: net4                phys      1500   up       --
LAN: net3                phys      1500   unknown  --
LAN: net0                phys      1500   up       --
LAN: net2                phys      1500   unknown  --
LAN: net6                phys      1500   up       --

