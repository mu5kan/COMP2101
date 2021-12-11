get-ciminstance win32_networkadapterconfiguration| where ipenabled -eq true |
ft -autosize description, index, ipaddress, ipsubnet, dnsdomain, dnsserversearchorder
