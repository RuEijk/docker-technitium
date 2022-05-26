# Docker-Technitium-DNS
This repo contains a Dockerfile for building an Alpine based Technitium Docker image.

## Building the image
In the Dockerfile, set the value of ``TECHNITIUM_VERSION`` to the version of Technitium you whish to install. See [this page](https://download.technitium.com/dns/archive/) for a list of available archived releases. Please note that releases older than 8.0 are not supported. Alternatively, set ``TECHNITIUM_VERSION`` to the string ``latest`` (which is the default) if you want to install the latest available release.

## Running the container
Configuration data are stored in ``/etc/dns/config/``. You probably want to map this directory to a persistent volume or folder on the host machine. Additionally, you need to expose the ports on which you want to offer DNS services and the web based management interface. The exact ports you need to expose depend on your setup, but probably include port 53 (udp) for normal DNS and 5380 (tcp) for the management interface.

As an example, you can use the following command to launch the container: ``docker run -d --name technitium -p 53:53/udp -p 5380:5380 -v /path/to/config/data/:/etc/dns/config/ <image_name>:<tag>``. Note that this command exposes port ``53`` and ``5380`` on each available network interface of your server, which might have security implications.
