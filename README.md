# x86cncbuild
The scripe is auto build linux kernal+xenomai for linuxcnc

- install all nessary software
- build linux kernel
- build xenomai
- build linuxcnc


Recommended options:

* General setup
  --> Local version - append to kernel release: -xenomai-3.0.5
    --> Timers subsystem
          --> High Resolution Timer Support (Enable)
    * Xenomai/cobalt
      --> Sizes and static limits
          --> Number of registry slots (512 --> 4096)
        --> Size of system heap (Kb) (512 --> 4096)
        --> Size of private heap (Kb) (64 --> 256)
        --> Size of shared heap (Kb) (64 --> 256)
        --> Maximum number of POSIX timers per process (128 --> 512)
      --> Drivers
          --> RTnet
                  --> RTnet, TCP/IP socket interface (Enable)
                --> Drivers
                                --> New intel(R) PRO/1000 PCIe (Enable)
                    --> Realtek 8169 (Enable)
                    --> Loopback (Enable)
            --> Add-Ons
                        --> Real-Time Capturing Support (Enable)
    * Power management and ACPI options
      --> CPU Frequency scaling
            --> CPU Frequency scaling (Disable)
      --> ACPI (Advanced Configuration and Power Interface) Support
            --> Processor (Disable)
      --> CPU Idle
            --> CPU idle PM support (Disable)
    * Pocessor type and features
      --> Enable maximum number of SMP processors and NUMA nodes (Disable)
      // Ref : http://xenomai.org/pipermail/xenomai/2017-September/037718.html
      --> Processor family
            --> Core 2/newer Xeon (if "cat /proc/cpuinfo | grep family" returns 6, set as Generic otherwise)
              // Xenomai will issue a warning about CONFIG_MIGRATION, disable those in this order
              --> Transparent Hugepage Support (Disable)
      --> Allow for memory compaction (Disable)
      --> Contiguous Memory Allocation (Disable)
      --> Allow for memory compaction
          --> Page Migration (Disable)
    * Device Drivers
      --> Staging drivers
            --> Unisys SPAR driver support
                     --> Unisys visorbus driver (Disable)
