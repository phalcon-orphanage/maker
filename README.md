# DEPRECATED

Please note that this repository has been marked as deprecated. We will be deleting it from our organization at 31 August 2018.

We want to be able to offer our community with quality work, and we cannot simply maintain all the available repositories. If you feel that this repository should be kept you can talk to us in our discord server (https://phalcon.link/discord). You can also fork the repository if you wish to and/or archive it for your purposes.

For more see: https://blog.phalconphp.com/post/repository-reorganization

# Maker

The project that build the [Phalcon Box](https://github.com/phalcon/box) development environment.

This build configuration installs and configures Ubuntu using
[Ansible](http://docs.ansible.com/intro_installation.html), and then generates two
[Vagrant Box](https://www.vagrantup.com/docs/boxes.html) files, for:

  - VirtualBox
  - VMWare

Current Ubuntu version used: 16.04.3

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build the
Vagrant Box file:

  - [Rake](https://github.com/ruby/rake)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/) (if you want to build the VirtualBox box)
  - [VMware Fusion](http://www.vmware.com/products/fusion/) (or [Workstation](https://www.vmware.com/products/workstation.html) - if you want to build the VMware box)

## Usage

Make sure all the required software (listed above) is installed, then cd to the directory containing this README.md
file, and run:

```bash
rake build
```

**NOTE:** You may need to update your BIOS to enable [virtualization](https://en.wikipedia.org/wiki/X86_virtualization)
with `AMD-V`, `Intel VT-x` or `VIA VT`.

After a few minutes, Packer should tell you the box was generated successfully.

## License

Maker is open source software licensed under the MIT License. See the [LICENSE](https://github.com/phalcon/maker/blob/master/LICENSE) file for more.
