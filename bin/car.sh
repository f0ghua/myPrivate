#!/bin/sh

curl -s \
    -H "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.3) Gecko/20100423 Ubuntu/10.04 (lucid) Firefox/3.6.3" \
    -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
    -H "Content-Type: text/x-gwt-rpc; charset=utf-8" \
    -H "X-GWT-Permutation: 7F91078EBD6F92A71F93401706FA4309" \
    -H "X-GWT-Module-Base: http://58.210.126.206:9091/QueryVD/queryvd/" \
    -d '7|0|9|http://58.210.126.206:9091/QueryVD/queryvd/|5262F91C7EB710ACCA6AC7167DFEDE1F|com.cgs.client.GreetingService|queryVehicleResult|java.lang.String/2004016611| |02|EA1H13|LFPM4ACC091A92402|1|2|3|4|4|5|5|5|5|6|7|8|9|' \
    --referer "http://58.210.126.206:9091/QueryVD/" \
    http://58.210.126.206:9091/QueryVD/queryvd/greet \
    | iconv -f utf8 -t gb2312
echo ""
