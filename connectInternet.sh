#Usage: sh connectInternet.sh. First line :connect internet. Second line : disconnect internet
#wget -q --user-agent="User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0" --header='Accept-Encoding: gzip, deflate' --header='Connection: keep-alive' --header='Content-Type: application/x-www-form-urlencoded' --header='Accept-Language: en-US,en;q=0.5' --header='Content-Length: 94' --header='Upgrade-Insecure-Requests: 1' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Referer: http://192.168.255.243/0.htm' --post-data="DDDDD=yuanhjcq&upass=c3af791ede2d4f6d6a7d99a6baf75db7123456781&R1=0&R2=1&para=00&0MKKey=123456" http://192.168.255.243/0.htm -O -

#wget -q --user-agent="User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0" --header='Accept-Encoding: gzip, deflate' --header='Connection: keep-alive' --header='Content-Type: application/x-www-form-urlencoded' --header='Accept-Language: en-US,en;q=0.5' --header='Content-Length: 94' --header='Upgrade-Insecure-Requests: 1' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'  --header='Referer: http://192.168.255.243/0.htm' http://192.168.255.243/F.htm -O -
cat genelist |while read gene
	do 
	
	wget -q   --user-agent='User-Agent: Mozilla/5.0(Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.6)' \
		--header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
		--header='Accept-Language: en-us' \
		--header='Connection: keep-alive' \
		--header='Upgrade-Insecure-Requests: 1' \
  		--header='Accept-Charset: GB2312,utf-8;q=0.7,*;q=0.7' \
		--header='Referer: https://portal.biobase-international.com/cgi-bin/portal/login.cgi' \
		--post-data="login=swgenetics&password=SWgenetics@)!%26&signin=Sign in"  \
		--save-cookies=cookie --keep-session-cookies \
		https://portal.biobase-international.com/cgi-bin/portal/login.cgi -O - >/dev/null


	tmplist=`wget -q  --user-agent='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0' \
		--header='Host: portal.biobase-international.com' \
		--header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
		--header='Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3' \
		--header='Referer: https://portal.biobase-international.com/hgmd/pro/genesearch.php' \
		--header='Connection: keep-alive' \
		--header='Upgrade-Insecure-Requests: 1' \
		--header='Cache-Control: max-age=0' \
		--load-cookies=cookie --keep-session-cookies \
		https://portal.biobase-international.com/hgmd/pro/gene.php?gene=$gene -O - |grep -E "(refcore)|(gene_id)"|perl -npe "s/.*refcore\' value=\'//;s/.*gene_id\' value=\'//"|perl -npe "s/\'.*//"|sed -n '2p;3p'|perl -npe "s/\n/ /"|perl -npe "s/$/\n/"
	if [ "$tmplist" = "" ] 
	then {
		wget -q --user-agent="User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0" --header='Accept-Encoding: gzip, deflate' --header='Connection: keep-alive' --header='Content-Type: application/x-www-form-urlencoded' --header='Accept-Language: en-US,en;q=0.5' --header='Content-Length: 94' --header='Upgrade-Insecure-Requests: 1' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Referer: http://192.168.255.243/0.htm' --post-data="DDDDD=yuanhjcq&upass=c3af791ede2d4f6d6a7d99a6baf75db7123456781&R1=0&R2=1&para=00&0MKKey=123456" http://192.168.255.243/0.htm -O - >/dev/null
	}	
	fi
	refcore=`echo $tmplist |cut -d' ' -f1`
	gene_id=`echo $tmplist |cut -d' ' -f2`
	echo "$tmplist"
	echo -n "$gene:" >> HGMD/HGMDAccession
	wget -q  --user-agent='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0' \
		--header='Host: portal.biobase-international.com' \
		--header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
		--header='Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3' \
		--header='Referer: https://portal.biobase-international.com/hgmd/pro/gene.php' \
		--header='Connection: keep-alive' \
		--header='Upgrade-Insecure-Requests: 1' \
		--header='Cache-Control: max-age=0' \
		--load-cookies=cookie --keep-session-cookies \
		--post-data="gene=${gene}&inclsnp=N&base=Z&refcore=${refcore}&sort=location&gene_id=${gene_id}&database=Get all mutations"  \
		https://portal.biobase-international.com/hgmd/pro/all.php -O - |grep "<input type='hidden' name='acc' value='"|perl -npe "s/.*<input type=\'hidden\' name=\'acc\' value=\'//;s/\'.*//" |while read acc
		do 
			echo -n "$acc," >>HGMD/HGMDAccession
			wget -q  --user-agent='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0' \
				--header='Host: portal.biobase-international.com' \
				--header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
				--header='Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3' \
				--header='Referer: https://portal.biobase-international.com/hgmd/pro/gene.php' \
				--header='Connection: keep-alive' \
				--header='Upgrade-Insecure-Requests: 1' \
				--header='Cache-Control: max-age=0' \
				--load-cookies=cookie --keep-session-cookies \
				https://portal.biobase-international.com/hgmd/pro/mut.php?acc=$acc -O HGMD/$acc
				if [ "$acc" = "" ] 
				then {
					wget -q --user-agent="User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:54.0) Gecko/20100101 Firefox/54.0" --header='Accept-Encoding: gzip, deflate' --header='Connection: keep-alive' --header='Content-Type: application/x-www-form-urlencoded' --header='Accept-Language: en-US,en;q=0.5' --header='Content-Length: 94' --header='Upgrade-Insecure-Requests: 1' --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' --header='Referer: http://192.168.255.243/0.htm' --post-data="DDDDD=yuanhjcq&upass=c3af791ede2d4f6d6a7d99a6baf75db7123456781&R1=0&R2=1&para=00&0MKKey=123456" http://192.168.255.243/0.htm -O - >/dev/null
				}	
				fi	
				echo $gene $acc
		done
		echo  "" >>HGMD/HGMDAccession
	done



