#Lab 3 Powershell network adapter description script.

get-ciminstance win32_networkadapterconfiguration | where-object ipenabled
	format-table Description,Index,ipaddress,ipsubnet,dnshostname,dnsdomain