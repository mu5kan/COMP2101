get-ciminstance win32_networkadapterconfiguration| where ipenabled -eq true |
ft -autosize index, ipaddress, description, ipsubnet, dnsdomain, dnsserversearchorder
