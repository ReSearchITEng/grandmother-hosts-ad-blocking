# grandmother of all ad-blocking hosts files :)
# How to Use:
curl -sL "https://github.com/ReSearchITEng/grandmother-hosts-ad-blocking/blob/master/hosts.blocked0?raw=true" >hosts.blocked0

One may want to take a look at the blk.conf file which is to be used for dnsmasq servers

# What it contains:
* grandmother-hosts-ad-blocking - Collection of hosts files from many locations:
* hosts.eladkarako.com
* winhelp2002.mvps.org
* adaway.org/hosts.txt
* someonewhocares.org/hosts/zero/hosts
* pgl.yoyo.org/adservers
* hosts-file.net/ad_servers.txt
* hosts-file.net/download/hosts.txt
* hostsfile.mine.nu/Hosts
* adblock.mahakala.is/hosts

#Notes
* Tested and it works fine with dnsmasq on Raspberry Pi1
* Tested and NOT working (probably due to size??) on Asus N RT 16 (could be coz it's too old??) -> Merlin to be asked...
