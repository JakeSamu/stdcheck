# Download

Due to the nature of git submodules, please clone with
* git clone --recursive https://www.github.com/jakesamu/stdcheck

# Update

this repository with:
* git submodule update --recursive --init --remote

Even with that it might sometimes not work ... still need to learn more about submodules.

# Dependencies

To install every dependency use:
* ./stdcheck --install

This tool is written on and for kali linux. It should work on debian based systems too.

# ToDo

* Rename stdcheck-web and stdcheck-network to web-checker and net-stdchecker respectively.
* Better and more user-input forwarding to both submodules.
* ?update.sh?
* Add to install.sh the check, that every submodule exists

# Known Bugs
* If the ports are shown as "tcpwrapped", they will not be seen as http-ports.
