# Maker

The project that build the [Phalcon Box](https://github.com/phalcon/box) development environment.

This build configuration installs and configures Ubuntu using
[Ansible](http://docs.ansible.com/intro_installation.html), and then generates two
[Vagrant Box](https://www.vagrantup.com/docs/boxes.html) files, for:

  - VirtualBox
  - VMware

**Current Ubuntu version used**: 16.04.3

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build the
Vagrant Box file:

  - [Packer](http://www.packer.io/) >= 1.0.0
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/) (if you want to build the VirtualBox box)
  - [VMware Fusion](http://www.vmware.com/products/fusion/) (or Workstation - if you want to build the VMware box)

## Usage

Make sure all the required software (listed above) is installed, then cd to the directory containing this README.md
file, and run:

```bash
packer build ubuntu1604.json
```

You may need to update your BIOS to enable [virtualization](https://en.wikipedia.org/wiki/X86_virtualization)
with `AMD-V`, `Intel VT-x` or `VIA VT`.

After a few minutes, Packer should tell you the box was generated successfully.

If you want to only build a Box for one of the supported virtualization platforms (e.g. only build the VMware box),
add `--only=vmware-iso` to the `packer build` command:

```bash
packer build --only=vmware-iso ubuntu1604.json
```

## Testing built boxes

There's an included [Vagrantfile](https://github.com/phalcon/maker/blob/master/Vagrantfile) that allows quick testing of
the built Vagrant Boxes. From this same directory, run one of the following commands after building the boxes:

```bash
# For VMware Fusion:
vagrant up vmware --provider=vmware_fusion

# For VirtualBox:
vagrant up virtualbox --provider=virtualbox
```

## License

Maker is open source software licensed under the MIT License. See the LICENSE file for more.
