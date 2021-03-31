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
* Change stdcheck and netchecker, s.th. they both use the same script-base for the common functions.
* Option redirect for websites

# Known Bugs / Why something does not work correctly
* If the ports are shown as "tcpwrapped", they will not be seen as http-ports.
* TLS-Scan via testssl does not try different start_tls modes
* Currently problems with ips that are up and exists but cannot be called due to problems like bad signature of tls-certificate.
