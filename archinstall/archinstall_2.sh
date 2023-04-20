#!/bin/bash
read -p "Do you want btrfs ? If no then it will format the drive in ext4. Answer in (yes/no). Dont use caps (YES/NO). TYPE THE FULL WORD. DONT TYPE (y/n/Y/N)!!!!!" sex

case "$sex" in
  yes|y|Y|YES)
    mkfs.btrfs /dev/sda3
    ;;
  no|n|N|NO)
    mkfs.ext4 /dev/sda3
    ;;
  *)
    echo "Invalid input. Please run the script again "
    exit 1
    ;;
esac


mkswap /dev/sda2
mkfs.fat -F 32 /dev/sda1
mount --mkdir /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2
pacman -Syyu reflector



pacstrap -K /mnt base linux-zen linux-firmware networkmanager vim nvim git reflector grub efibootmgr intel-ucode btrfs-progs e2fsprogs dosfstools exfatprogs exfat-utils terminus-font
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo "Now time to edit your locale. Vim will open /etc/locale.gen and uncomment the ``en_US.UTF-8 UTF-8`` and ``en_IN UTF-8`` locale."
sleep 14
vim /etc/locale.gen
echo "LANG=en_IN.UTF-8" >> /etc/locale.conf
echo "LC_TIME=en_IN.UTF-8" >> /etc/locale.conf
echo "archissexy" >> /etc/hostname
systemctl enable NetworkManager.service
echo "Now it is time TO SET YOUR ROOT PASSWORD BE VERY CAREFULL AND REMEMBER THE PASSWORD." 
sleep 6
passwd
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sleep 5
grub-mkconfig -o /boot/grub/grub.cfg
sleep 2
echo "ALL DONE!!!! LEZZZ GOOOOO BOIIISSS"

