# Maker

The project that build the [Phalcon Box](https://github.com/phalcon/box) development environment.

**Current Ubuntu Version Used**: 16.04.2

This build configuration installs and configures Ubuntu 16.04 x86_64 using Ansible, and then generates two Vagrant box files, for:

  - VirtualBox
  - VMware

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build the Vagrant box file:

  - [Packer](http://www.packer.io/)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/) (if you want to build the VirtualBox box)
  - [VMware Fusion](http://www.vmware.com/products/fusion/) (or Workstation - if you want to build the VMware box)
  - [Ansible](http://docs.ansible.com/intro_installation.html)

## Usage

Make sure all the required software (listed above) is installed, then cd to the directory containing this README.md file, and run:

```bash
packer build ubuntu1604.json
```

After a few minutes, Packer should tell you the box was generated successfully.

If you want to only build a box for one of the supported virtualization platforms (e.g. only build the VMware box), add `--only=vmware-iso` to the `packer build` command:

```bash
 packer build --only=vmware-iso ubuntu1604.json
```

## Testing built boxes

There's an included Vagrantfile that allows quick testing of the built Vagrant boxes. From this same directory, run one of the following commands after building the boxes:

```bash
# For VMware Fusion:
vagrant up vmware --provider=vmware_fusion

# For VirtualBox:
vagrant up virtualbox --provider=virtualbox
```

## License

Maker is open source software licensed under the MIT License. See the LICENSE file for more.
