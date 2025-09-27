_: {
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition for UEFI boot
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            # Swap partition - 4GB for 12GB RAM
            swap = {
              size = "4G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };

            # Root partition - remaining space
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "noatime"
                  "discard"
                ];
              };
            };
          };
        };
      };
    };
  };

  # Filesystem configurations
  fileSystems = {
    # Large tmpfs for better performance with 12GB RAM
    "/tmp" = {
      fsType = "tmpfs";
      options = ["size=2G" "nodev" "nosuid"];
    };

    # VirtioFS shared folder (Apple Virtualization)
    "/media/shared" = {
      fsType = "virtiofs";
      device = "share";
      options = ["rw" "nofail"];
    };
  };
}
