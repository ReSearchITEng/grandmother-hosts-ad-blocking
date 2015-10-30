#!/bin/sh
dir=/home/osmc
outlist=$dir/hosts.blocked.tmp
outlistFinal=$dir/hosts.blocked
tempoutlist=$dir/list.tmp
whitelist=$dir/whitelist.txt
echo "Getting ad list files quiet..."


getter(){
echo "Getter starts"
echo "" > $tempoutlist
echo "Getting hosts.eladkarako.com ..."
curl -s "https://raw.githubusercontent.com/eladkarako/hosts.eladkarako.com/master/hosts0.txt" | sed s/127.0.0.1/0.0.0.0/g | sed $'s/\r$//' | sed 's/  */\ /g' | grep -w ^0.0.0.0 | awk '{print $1 " " $2}' | sort -u  >> $tempoutlist 
echo "Getting winhelp2002.mvps.org ..."
wget -qO- "http://winhelp2002.mvps.org/hosts.txt"   | sed s/127.0.0.1/0.0.0.0/g | sed $'s/\r$//' | sed 's/  */\ /g' | grep -w ^0.0.0.0 | awk '{print $1 " " $2}' | sort -u >> $tempoutlist

echo "Getting adaway, someonewhocares, pgl.yoyo.org ..."
wget -qO- "http://adaway.org/hosts.txt"             | sed s/127.0.0.1/0.0.0.0/g | sed $'s/\r$//' | sed 's/  */\ /g' | grep -w ^0.0.0.0 | awk '{print $1 " " $2}' | sort -u >> $tempoutlist
wget -qO- "http://someonewhocares.org/hosts/zero/hosts" | sed s/127.0.0.1/0.0.0.0/g | sed $'s/\r$//' | sed 's/  */\ /g' | grep -w ^0.0.0.0 | awk '{print $1 " " $2}' | sort -u >> $tempoutlist
wget -qO- "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext&useip=0.0.0.0" \
| sed s/127.0.0.1/0.0.0.0/g | sed $'s/\r$//' | sed 's/  */\ /g' | grep -w ^0.0.0.0 | awk '{print $1 " " $2}' | sort -u >> $tempoutlist

echo "Getting hosts-file.net (ad&hosts) ..."
wget -qO- "http://hosts-file.net/ad_servers.txt"    | sed s/127.0.0.1/0.0.0.0/g | sed $'s/\r$//' | sed 's/  */\ /g' | grep -w ^0.0.0.0 | awk '{print $1 " " $2}' | sort -u >> $tempoutlist
wget -qO- "http://hosts-file.net/download/hosts.txt"| sed s/127.0.0.1/0.0.0.0/g | sed $'s/\r$//' | sed 's/  */\ /g' | grep -w ^0.0.0.0 | awk '{print $1 " " $2}' | sort -u >> $tempoutlist
echo "Getting hostsfile.mine.nu ..."
wget -qO- "http://hostsfile.mine.nu/Hosts"          | sed s/127.0.0.1/0.0.0.0/g | sed $'s/\r$//' | sed 's/  */\ /g' | grep -w ^0.0.0.0 | awk '{print $1 " " $2}' | sort -u >> $tempoutlist

echo "Getting Mother of All Ad Blocks list..."
wget -qO- "http://adblock.mahakala.is/hosts" --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0" \
| sed s/127.0.0.1/0.0.0.0/g | sed $'s/\r$//' | sed 's/  */\ /g' | grep -w ^0.0.0.0 | awk '{print $1 " " $2}' | sort -u >> $tempoutlist

}

whitelist_dos_finalizing(){
# remove whitelisted entries in tempblack and write final file, remove temp and tempblack files
echo "checking whitelist ($whitelist) as well as final sort uniq & dos2unix... "

if [[ -s $whitelist ]];then
	cat $tempoutlist | sort -u | fgrep -vf $whitelist > $outlist
else
	echo "WARNING: $whitelist not found, or it's zero size"
	cat $tempoutlist | sort -u > $outlist
fi
dos2unix $tempoutlist || true
if [[ -s $tempoutlist ]];then
	mv $outlist ${outlistFinal}0
	cat ${outlistFinal}0 | sed s/0.0.0.0/127.0.0.1/ >${outlistFinal}127
	#git_upload
else
	echo "something funky has happened and output file is zero; therefore nothing has been done"
fi
}

report(){
# Count how many domains/whitelists were added so it can be displayed to the user
numberOfAdsBlocked=$(cat $outlistFinal | wc -l | sed 's/^[ \t]*//')
echo "$numberOfAdsBlocked ad domains blocked."
}

cleanup(){
echo "Deleting temp file $tempoutlist ..."
rm $tempoutlist
}

restart_dns(){
sleep 1
echo "Restart dnsmasq..."
sudo systemctl restart dnsmasq
#service restart_dnsmasq
}

#############
###### MAIN #
#############
echo "" > $tempoutlist
getter
whitelist_dos_finalizing
report
#cleanup
restart_dns

sleep 1
echo "All done !!!"


