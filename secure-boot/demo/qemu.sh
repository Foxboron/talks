#!/bin/bash

if [ -n "$1" ]; then
	qemu-system-x86_64 -no-reboot -boot order=c,menu=on,splash-time=65535,strict=on \
					   -kernel "$1" -append "root=/dev/sda rw console=ttyS0,115200 ignore_loglevel" \
					   -drive file=fat:rw:shared \
					   -machine type=q35,smm=on,accel=kvm -netdev user,id=net0,hostfwd=tcp::10022-:22 \
					   -device virtio-net-pci,netdev=net0 -nic user,model=virtio-net-pci \
					   -fsdev local,id=test_dev,path=./shared,security_model=none \
					   -device virtio-9p-pci,fsdev=test_dev,mount_tag=shared \
					   -global driver=cfi.pflash01,property=secure,value=on \
					   -global ICH9-LPC.disable_s3=1 \
					   -drive if=pflash,format=raw,unit=0,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.secboot.fd,readonly \
					   -drive if=pflash,format=raw,unit=1,file=OVMF_VARS.fd \
					   -m 8G -smp 2 -enable-kvm -cpu host -device virtio-scsi-pci,id=scsi \
					   -drive format=qcow2,if=none,id=hd0,file=./tmp/rootfs.cow -device scsi-hd,drive=hd0
					exit 1
fi


qemu-system-x86_64 -no-reboot -boot order=c,menu=on,splash-time=65535,strict=on \
				   -drive file=fat:rw:shared \
				   -machine type=q35,smm=on,accel=kvm -netdev user,id=net0,hostfwd=tcp::10022-:22 \
				   -device virtio-net-pci,netdev=net0 -nic user,model=virtio-net-pci \
				   -fsdev local,id=test_dev,path=./shared,security_model=none \
				   -device virtio-9p-pci,fsdev=test_dev,mount_tag=shared \
				   -global driver=cfi.pflash01,property=secure,value=on \
				   -global ICH9-LPC.disable_s3=1 \
				   -drive if=pflash,format=raw,unit=0,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.secboot.fd,readonly \
				   -drive if=pflash,format=raw,unit=1,file=OVMF_VARS.fd \
				   -m 8G -smp 2 -enable-kvm -cpu host -device virtio-scsi-pci,id=scsi \
				   -drive format=qcow2,if=none,id=hd0,file=./tmp/rootfs.cow -device scsi-hd,drive=hd0
