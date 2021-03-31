#!/bin/bash
# 
#�ű��ļ���: tc2
# 
############################################################################
#��TC(Traffic Control)���ADSL����ٶȼ��� Ver. 1.0 by KindGeorge 2004.12.27 #
############################################################################
# 
#�˽ű�����ʵ��ͨ�����������Ϣ�����http://lartc.org
# 
#tc+iptables+HTB+SFQ
#
#һ.ʲô��ADSL? ADSL��Asymmetric Digital Subscriber Loop���ǶԳ������û���·��
# 
#����򵥵Ļ��Ľ�,���ǲ������к����в��Եȴ���Ļ���ATM�ļ���.  ����,��
#����������һ��ADSL����������3200Kbit,����ֻ��320Kbit.����ͨ����bit��
#ʾ.
#
#1������3200K ��ζ��ʲô��
# 
#��Ϊ 1Byte=8Bit ,һ���ֽ���8��λ(bit)���,һ���ô�дB��ʾByte,Сдb��
#ʾBit.  ���� 3200K=3200Kbps=3200K bits/s=400K bytes/s.
# 
#2�� ����320K ��ζ��ʲô��
# 
# 320K=320Kbps=320K bits/s=40K bytes/s.
# 
#����˵,�������ܶ����������غ��ϴ��ٶ�,������·��û�κ����,�������
#ʱ��, ����ֻ��400K bytes/s,�ϴ�ֻ�����40K bytes/s���ϴ�����.
# 
#��Щ��������ֵ,����ʵ���ǲп��,��Զû����������ô��.����Ҳ�����,�ο�
#�ڲ����м�ʮ̨����һ��������.
#
#3.ADSL�ϴ��ٶȶ����ص�Ӱ��
# 
#(1)TCP/IPЭ��涨��ÿһ�����������Ҫ��acknowledgeѶϢ�Ļش���Ҳ����˵��
#��������ϣ���Ҫ��һ���յ����ϵ�ѶϢ�ظ������ܾ�������Ĵ����ٶȣ�����
#���Ƿ����´�����ʧ�����ϡ����еĴ���һ���־�������������Щ
#acknowledge(ȷ��)���ϵ������������ʱ�򣬾ͻ�Ӱ��acknowledge���ϵĴ���
#�ٶȣ�������Ӱ�쵽�����ٶȡ���ԷǶԳ����ֻ�·Ҳ����ADSL�������д���Զ
#С�����ش����������˵Ӱ����Ϊ���ԡ�
# 
#(2)����֤�������ϴ�����ʱ�������ٶȱ�Ϊԭ���ٶȵ�40������������.��Ϊ��
#���ļ�(����ftp �ϴ�,���ʼ�smtp),����ϴ�,һ���˵�ͨѶ���Ѿ�������adsl
#������򱥺�,��ô���е����ݰ�ֻ�а����Ƚ��ȳ���ԭ������ŶӺ͵ȴ�.���
#���Խ���Ϊʲô��������������ftp�����ļ�, ���ʹ��ʼ���ʱ��,�������ٱ�
#�ú�����ԭ��
#
#��.���ADSL�ٶ�֮��
# 
#1. Ϊ�����Щ�ٶ�����,���ǰ�����������adsl���ص�,�Ծ�����·�����ݽ���
#���й���ķ���.  �ѱ�����adsl modem�ϵ�ƿ��ת�Ƶ�����linux·������,��
#�԰Ѵ�����Ƶı�adsl modem�ϵ�Сһ��, �������ǾͿ��Է������tc�����Ծ�
#�������ݽ��з����Ϳ���.
# 
#���ǵ����������·�ϵĳ���һ��,�и��ٵ�,����С����,�󳵵�.��Ҫ���ٵ�
#syn,ack,icmp���߸��ٵ�,��Ҫ���������ftp-data,smtp���ߴ󳵵�,��������
#����������·.�������.
# 
#2. linux�µ�TC(Traffic Control)��������������.ֻҪ���Ƶõ�,һ��������
#�Ե�Ч��.
# 
#tc��iptables�������õļ����õĽ�Ϸ���.
# 
#�������ù������Ա���iptables�����ݰ����з���,��Ϊiptables��������
#�㻹����Ϊÿ���������ü�����. iptables��mangle����mark���ݰ�,��������
#�ˣ����ݰ�����һ���ض���FWMARK���ֵ(hanlde x fw)��������Ӧ���͸��ĸ�
#��( classid x : x),��prio������ֵ,������Щ��Ҫ����Ӧ������ͨ���ĸ�ͨ��.
# 
#����ѡ�����,cbq��htb�ǲ����ѡ��,����ʵ��,htb��Ϊ����,�������½ű���
#��htb������.
# 
#3. һ��ϵͳĬ�ϵ���fifo���Ƚ��ȳ�����,����˵���ݰ����������ȴ����ԭ
#��,�����һ��������ݰ���ǰ��,#��ô����İ�ֻ�ܵ�ǰ��ķ������ܽ���
#����,����������漴ʹ��һ��СС��ack��, ҲҪ�ȴ���,�����ϴ���Ӱ������
#��,�������кܴ�����ش���Ҳ����Ϊ��.
# 
#HTB(Hierarchical Token Bucket, �ֲ������Ͱ)
# 
#����ϸ��htb�ο� http://luxik.cdi.cz/~devik/qos/htb/
# 
#HTB����CBQһ�����������ǲ�������������ʱ�������Ρ�����һ�����������Ͱ
#����������ֻ�к��ٵĲ���.
# 
#���ķֲ�(Hierarchical)�ܹ��ܺõ���������һ�����������һ���̶����ʵ���
#·��ϣ���ָ�����ֲ�ͬ����;ʹ��,Ϊÿ����;���������ŵ��ʵ�ֶ����Ĵ�
#����á�
# 
#4. �ṹ��ͼ:
# 
#          |
#        __1:__
#       |      |
#  _ _ _1:1   1:2_ _ _ _ _ _ _ _ _
# | ~ ~ | ~ ~ ~ | ~ ~ | ~ ~ | ~ ~ |
#1:11  1:12   1:21   1:22  1:23  1:24
# 
#����˳����1:11 1:12 1:21 1:22 1:23 1:24
#
#--------------------------------------------------------------------------
#5.�������������,��ʼ�ű�
# 
#ͨ��adsl��pppoe����,�ĵõ�����ppp0,���Թ��������ϰ���ppp0
# 
#���ڲ�����˵��
# 
#(1)rate: ��һ���ౣ֤�õ��Ĵ���ֵ.����в�ֻһ����,�뱣֤���������ܺ�
#         ��С�ڻ���ڸ���.
# 
#(2)ceil: ceil��һ��������ܵõ��Ĵ���ֵ.
# 
#(3)prio: ������Ȩ������,��ֵԽ��,����ȨԽС.����Ƿ���ʣ�����,������
#         ֵС�Ļ�������ȡ��ʣ��Ŀ��еĴ���Ȩ.
# 
#����ÿ����Ҫ�������rate,Ҫ����ʵ��ʹ�ò��Եó����.
# 
#һ������ݵĻ�,������50%-80%���Ұ�,��ceil����鲻����85%,����ĳһ��
#�Ựռ�ù���Ĵ���.
# 
#rate�ɰ������������,
# 
#1:11 �Ǻ�С��������Ҫ�����ݰ�ͨ��,��ȻҪ�ֶ��.������Ҫʱ��ȫ��ռ��,��
#��һ�㲻���.���Ը�ȫ��.
# 
#1:12 �Ǻ���Ҫ�����ݵ�,�����,���ٸ�һ��,����Ҫʱ�����ٶ�һ��.
#rate �滮 1:2 = 1:21 + 1:22 + 1:23 + 1:24 һ��������50%-80%����
# 
#1:21 http,pop����õ���,Ϊ��̫������,�����¶���,���ǲ��ܸ���̫��,Ҳ
#����̫��.
# 
#1:22 �Ҵ����smtp��,���ȵ���1:21 �Է�����ĸ�������ռ�ô���
# 
#1:23 �Ҵ����ftp-data,��1:22һ��,�ܿ��ܴ����ϴ��ļ�,����rate���ܸ���̫
#��,����������ʣʱ���Ը���Щ,ceil���ô�Щ
# 
#1:24 ������νͨ��,����һ�㲻������ƽʱ��������Ҫ��ͨ����,��С��,��ֹ��
#Щ���ڷ���������������Ҫ����
# 
#���� uplink 320K,�����Ե�������ֵ
#

DEV="ppp0"
UPLINK=300
#����downlink 3200 k ���һ������,�Ա��ܹ��õ�����Ĳ�������
DOWNLINK=1500

echo "==================== Packetfilter and Traffic Control �������� By ���缼���� Ver. 1.0===================="

start_routing() {
echo -n "�������ÿ�ʼstart......"
#1.����һ�������У�û�н��з�������ݰ��������1:24��ȱʡ��:
tc qdisc add dev $DEV root handle 1: htb default 24
#1.1 ����һ����������������1: ����Ϊ$UPLINK k
tc class add dev $DEV parent 1: classid 1:1 htb rate ${UPLINK}kbit ceil ${UPLINK}kbit prio 0

#1.1.1 ��������1�½�����һҶ����,����һ���������Ȩ����.��Ҫ�����Ⱥ͸�
#      �ٵİ�������ͨ��,����SYN,ACK,ICMP��
tc class add dev $DEV parent 1:1 classid 1:11 htb rate $[$UPLINK]kbit ceil ${UPLINK}kbit prio 1
#1.1.2 ������1�½����ڶ�Ҷ���� ,����һ���θ�����Ȩ���ࡣ����������Ҫ��
#      crm����.
tc class add dev $DEV parent 1:1 classid 1:12 htb rate $[$UPLINK-150]kbit ceil ${UPLINK-50}kbit prio 2

#1.2 �ڸ����½����θ��� classid 1:2 ���˴θ��������ȫ������Ȩ��������
#    ��,�Է���Ҫ���ݶ���.
tc class add dev $DEV parent 1: classid 1:2 htb rate $[$UPLINK-150]kbit prio 3

#1.2.1 �ڴθ����½�����һҶ����,����������http,pop��.
tc class add dev $DEV parent 1:2 classid 1:21 htb rate 100kbit ceil $[$UPLINK-150]kbit prio 4

#1.2.2 �ڴθ����½����ڶ�Ҷ���ࡣ��Ҫ̫�ߵ��ٶ�,�Է�����ĸ�������ռ��
#      ����,����smtp��
tc class add dev $DEV parent 1:2 classid 1:22 htb rate 30kbit ceil $[$UPLINK-160]kbit prio 5

#1.2.3 �ڴθ����½�������Ҷ���ࡣ��Ҫ̫��Ĵ���,�Է����������ݶ�������,��
#      ��ftp-data��,
tc class add dev $DEV parent 1:2 classid 1:23 htb rate 15kbit ceil $[$UPLINK-170]kbit prio 6

#1.2.4 �ڴθ����½�������Ҷ���ࡣ����ν������ͨ��,����Ҫ̫��Ĵ���,�Է�
#      ����ν�������谭����.
tc class add dev $DEV parent 1:2 classid 1:24 htb rate 5kbit ceil $[$UPLINK-250]kbit prio 7

#��ÿ���������ٸ�������һ�����й涨,�����ƽ����(SFQ)������ĳ�����Ӳ�ͣ
#ռ�ô���,�Ա�֤�����ƽ����ƽʹ�ã�
# 
#SFQ(Stochastic Fairness Queueing�������ƽ����),SFQ�Ĺؼ�����"�Ự"(��
#����"��") ����Ҫ���һ��TCP�Ự����UDP�����������ֳ��൱��������FIFO��
#���У�ÿ�����ж�Ӧһ���Ự�����ݰ��ռ���ת�ķ�ʽ����, ÿ���Ự����˳
#��õ����ͻ��ᡣ���ַ�ʽ�ǳ���ƽ����֤��ÿһ���Ự������û�����Ự����
#û��SFQ֮���Ա���Ϊ"���"������Ϊ�����������Ϊÿһ���Ự����һ�����У�
#����ʹ��һ��ɢ���㷨�������еĻỰӳ�䵽���޵ļ���������ȥ������
#perturb�Ƕ��������������һ��ɢ���㷨��Ĭ��Ϊ10

tc qdisc add dev $DEV parent 1:11 handle 111: sfq perturb 5
tc qdisc add dev $DEV parent 1:12 handle 112: sfq perturb 5
tc qdisc add dev $DEV parent 1:21 handle 121: sfq perturb 10
tc qdisc add dev $DEV parent 1:22 handle 122: sfq perturb 10
tc qdisc add dev $DEV parent 1:23 handle 133: sfq perturb 10
tc qdisc add dev $DEV parent 1:24 handle 124: sfq perturb 10
echo "�������óɹ�.done."
echo -n "���ð����� Setting up Filters......"

#�������ù�����,handle ��iptables��mark��ֵ,�ñ�iptables ��mangle������
#mark�Ĳ�ͬ��ֵѡ��ͬ��ͨ��classid,��prio �ǹ����������ȼ���.
tc filter add dev $DEV parent 1:0 protocol ip prio 1 handle 1 fw classid 1:11
tc filter add dev $DEV parent 1:0 protocol ip prio 2 handle 2 fw classid 1:12
tc filter add dev $DEV parent 1:0 protocol ip prio 3 handle 3 fw classid 1:21
tc filter add dev $DEV parent 1:0 protocol ip prio 4 handle 4 fw classid 1:22
tc filter add dev $DEV parent 1:0 protocol ip prio 5 handle 5 fw classid 1:23
tc filter add dev $DEV parent 1:0 protocol ip prio 6 handle 6 fw classid 1:24
echo "���ù������ɹ�.done."



########## downlink ####################################################
# 
#6. ���е�����:
# 
#������ӵĹ���,����Ϊ��һЩ������������ش��ļ��Ķ˿ڽ��п���,��������
#����̫��,���¶���.����̫��ľ�ֱ��drop,�Ͳ����˷Ѻ�ռ�û���ʱ�������
#ȥ������.
# 
#(1).���������ʿ����ڴ��1000-1500k����,��Ϊ����ٶ��Ѿ��㹻����,�Ա�
#    �ܹ��õ�����Ĳ�����������

tc qdisc add dev $DEV handle ffff: ingress

tc filter add dev $DEV parent ffff: protocol ip prio 50 handle 8 fw police rate ${DOWNLINK}kbit burst 10k drop flowid :8
}
#(2).����ڲ������������Ǻܷ��Ļ�,�Ͳ��������ص�������,��#����������
#    �����м���.
# 
#(3).���Ҫ���κν������ݵ����ݽ������ٵĻ�,�������������:
# 
#tc filter add dev $DEV parent ffff: protocol ip prio 10 u32 match ip src 0.0.0.0/0 police rate ${DOWNLINK}kbit burst 10k drop flowid :1

###############################################################################################
#7. ��ʼ�����ݰ����ǣ���PREROUTING�������mangle����
start_mangle() {

echo -n "��ʼ�����ݰ�����......start mangle mark......"

#(1)�ѳ�ȥ�Ĳ�ͬ�����ݰ�(Ϊdport)��mark�ϱ��1--6.�����߲�ͬ��ͨ��
#(2)�ѽ��������ݰ�(Ϊsport)��mark�ϱ��8,�����ܵ����е�����,�����ٶ�̫�����Ӱ��ȫ��.
#(3)ÿ�������¸���return����˼�ǿ���ͨ��RETURN��������������еĹ���,�ӿ��˴����ٶ�
##����TOS�Ĵ���
#iptables -t mangle -A PREROUTING -m tos --tos Minimize-Delay -j MARK --set-mark 1
#iptables -t mangle -A PREROUTING -m tos --tos Minimize-Delay -j RETURN
#iptables -t mangle -A PREROUTING -m tos --tos Minimize-Cost -j MARK --set-mark 4
#iptables -t mangle -A PREROUTING -m tos --tos Minimize-Cost -j RETURN
#iptables -t mangle -A PREROUTING -m tos --tos Maximize-Throughput -j MARK --set-mark 5
#iptables -t mangle -A PREROUTING -m tos --tos Maximize-Throughput -j RETURN

##���tcp��ʼ����(Ҳ���Ǵ���SYN�����ݰ�)������Ȩ�Ƿǳ����ǵģ�
iptables -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags SYN,RST,ACK SYN -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -p tcp -m tcp --tcp-flags SYN,RST,ACK SYN -j RETURN

######icmp,��ping�����õķ�Ӧ,���ڵ�һ���.
iptables -t mangle -A PREROUTING -p icmp -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -p icmp -j RETURN

# small packets (probably just ACKs)����С��64��С��ͨ������Ҫ��Щ��,һ��������ȷ��tcp�����ӵ�,
#�����ܿ�Щ��ͨ����.Ҳ���԰�������������,��Ϊ�������и������ϸ�Ķ˿ڷ���.
#iptables -t mangle -A PREROUTING -p tcp -m length --length :64 -j MARK --set-mark 2
#iptables -t mangle -A PREROUTING -p tcp -m length --length :64 -j RETURN

#ftp�ŵ�2��,��Ϊһ����С��, ftp-data���ڵ�5��,��Ϊһ���Ǵ������ݵĴ���.
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport ftp -j MARK --set-mark 2
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport ftp -j RETURN
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport ftp-data -j MARK --set-mark 5
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport ftp-data -j RETURN
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport ftp -j MARK --set-mark 8
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport ftp -j RETURN
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport ftp-data -j MARK --set-mark 8
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport ftp-data -j RETURN
##���ssh���ݰ�������Ȩ�����ڵ�1��,Ҫ֪��ssh�ǽ���ʽ�ĺ���Ҫ��,���ݴ���Ŷ
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 22 -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 22 -j RETURN
#
##smtp�ʼ������ڵ�4��,��Ϊ��ʱ���˷��ͺܴ���ʼ�,Ϊ����������,������4����
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 25 -j MARK --set-mark 4
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 25 -j RETURN
#iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 25 -j MARK --set-mark 8
#iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 25 -j RETURN
## name-domain server�����ڵ�1��,�������Ӵ������������Ӳ��ܿ����ҵ���Ӧ�ĵ�ַ,����ٶȵ�һ��
iptables -t mangle -A PREROUTING -p udp -m udp --dport 53 -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -p udp -m udp --dport 53 -j RETURN
#
## http�����ڵ�3��,����õ�,������õ�,
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 80 -j MARK --set-mark 3
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 80 -j RETURN
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 80 -j MARK --set-mark 8
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 80 -j RETURN
##pop�ʼ������ڵ�3��
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 110 -j MARK --set-mark 3
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 110 -j RETURN
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 110 -j MARK --set-mark 8
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 110 -j RETURN
## https�����ڵ�3��
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 443 -j MARK --set-mark 3
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 443 -j RETURN
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 443 -j MARK --set-mark 8
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 443 -j RETURN
## Microsoft-SQL-Server�����ڵ�2��,��������Ϊ����Ҫ,һ��Ҫ��֤�ٶȵĺ����ȵ�.
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 1433 -j MARK --set-mark 2
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 1433 -j RETURN
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 1433 -j MARK --set-mark 8
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 1433 -j RETURN

## voip��, ���,����ͨ��Ҫ���ָ���,�Ų������.
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 1720 -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 1720 -j RETURN
iptables -t mangle -A PREROUTING -p udp -m udp --dport 1720 -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -p udp -m udp --dport 1720 -j RETURN

## vpn ,����voip��,ҲҪ�߸���·,�Ų������.
iptables -t mangle -A PREROUTING -p udp -m udp --dport 7707 -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -p udp -m udp --dport 7707 -j RETURN

## ���ڵ�1��,��Ϊ�Ҿ������������к���Ҫ,����.
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 7070 -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 7070 -j RETURN

## WWW caching service�����ڵ�3��
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 8080 -j MARK --set-mark 3
iptables -t mangle -A PREROUTING -p tcp -m tcp --dport 8080 -j RETURN
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 8080 -j MARK --set-mark 8
iptables -t mangle -A PREROUTING -p tcp -m tcp --sport 8080 -j RETURN

##��߱������ݰ�������Ȩ�����ڵ�1
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 22 -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -p tcp -m tcp --dport 22 -j RETURN

iptables -t mangle -A OUTPUT -p icmp -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -p icmp -j RETURN

#����small packets (probably just ACKs)
iptables -t mangle -A OUTPUT -p tcp -m length --length :64 -j MARK --set-mark 2
iptables -t mangle -A OUTPUT -p tcp -m length --length :64 -j RETURN

#(4). ��PREROUTING�������mangle������������������PREROUTING��
##Ҳ����˵ǰ��û�д����ǵ����ݰ�������1:24����
##ʵ�����ǲ���Ҫ�ģ���Ϊ1:24��ȱʡ�࣬����Ȼ���ϱ����Ϊ�˱����������õ�Э��һ�£���������
#���ܿ�������İ�������

iptables -t mangle -A PREROUTING -i $DEV -j MARK --set-mark 6
echo "������! mangle mark done!"
}
#-----------------------------------------------------------------------------------------------------

#8.ȡ��mangle����õ��Զ��庯��
stop_mangle() {

echo -n "ֹͣ���ݱ�� stop mangle table......"
( iptables -t mangle -F && echo "ok." ) || echo "error."
}

#9.ȡ�������õ�
stop_routing() {
echo -n "(ɾ�����ж���......)"
( tc qdisc del dev $DEV root && tc qdisc del dev $DEV ingress && echo "ok.ɾ���ɹ�!" ) || echo "error."
}

#10.��ʾ״̬
status() {
echo "1.show qdisc $DEV (��ʾ���ж���):----------------------------------------------"
tc -s qdisc show dev $DEV
echo "2.show class $DEV (��ʾ���з���):----------------------------------------------"
tc class show dev $DEV
echo "3. tc -s class show dev $DEV (��ʾ���ж��кͷ���������ϸ��Ϣ):------------------"
tc -s class show dev $DEV
echo "˵��:�����ܶ������д��� $UPLINK k."
echo "1. classid 1:11 ssh��dns���ʹ���SYN��ǵ����ݰ��������������Ȩ������������� "
echo "2. classid 1:12 ��Ҫ����,���ǽϸ�����Ȩ���ࡣ"
echo "3. classid 1:21 web,pop ���� "
echo "4. classid 1:22 smtp���� "
echo "5. classid 1:23 ftp-data���� "
echo "6. classid 1:24 �������� "
}

#11.��ʾ����
usage() {
echo "ʹ�÷���(usage): `basename $0` [start | stop | restart | status | mangle ]"
echo "��������:"
echo "start ��ʼ��������"
echo "stop ֹͣ��������"
echo "restart ������������"
echo "status ��ʾ��������"
echo "mangle ��ʾmark���"
}

#----------------------------------------------------------------------------------------------
#12. �����ǽű����в�����ѡ��Ŀ���
#
kernel=`eval kernelversion`
case "$kernel" in
2.2)
echo " (!) Error: won't do anything with 2.2.x ��֧���ں�2.2.x"
exit 1
;;

2.4|2.6)
case "$1" in
start)
( start_routing && start_mangle && echo "��ʼ��������! TC started!" ) || echo "error."

exit 0
;;

stop)
( stop_routing && stop_mangle && echo "ֹͣ��������! TC stopped!" ) || echo "error."

exit 0
;;
restart)
stop_routing
stop_mangle
start_routing
start_mangle

echo "�������ƹ�������װ��!"
;;
status)
status
;;

mangle)
echo "iptables -t mangle -L (��ʾĿǰmangle�������ϸ):"
iptables -t mangle -nL
;;


*) usage
exit 1
;;
esac
;;

*)
echo " (!) Error: Unknown kernel version. check it !"
exit 1
;;
esac
#��.������
#1. ���Ҫ֧��htb,�뵽�����վ�����йز���.
#�˽ű��ǲο�http://lartc.org �� http://luxik.cdi.cz/~devik/qos/htb/ ��http://www.docum.org/docum.org
#����ȡchinaunix.net��C++����JohnBull��"Linux�ĸ߼�·�ɺ��������Ʊ���ɳ������¼��
#������<<Linux�ĸ߼�·�ɺ���������HOWTO���İ�>>,�������ϵ��Եó����ܽ���,�ڴ˸�л�����������׵���.
#2. iptables,��http://www.iptables.org/ .iptables v1.2.7a ��tc��Red hat linux 9.0���Դ��İ汾.
#3. �˽ű��Ѿ���Red Hat Linux 9.0�ں�2.4.20��,����Լ70̨Ƶ�����������Ļ�������������,��ʵ֤������.
#4. ���ADSL����ͬ���б�,�������rate������ceil��������.
#5. ����,������IMQ,IMQ(Intermediate queueing device,�н�����豸)�����к����ж����з������
#�͸�������,��Ҫ֧��IMQ,��Ҫ���±����ں�.���ڲ����͸�����ĵ������imq��վhttp://www.linuximq.net/
#6. ��ӭ����yahoo messegsender: kindgeorge#yahoo.com�˽ű����д���������.
#7. ����ADSL��,�����Խ�����������Ŀ���.
#8. �����˭���������ڸ��,����ռ������,�Ͱ�����Ϊ������,���ɵ�"����ν������ͨ��",�Է�����ν����
#���谭����: iptables -t mangle -I PREROUTING 1 -s 192.168.xxx.xxx -j MARK --set-mark 6
# iptables -t mangle -I PREROUTING 2 -s 192.168.xxx.xxx -j RETURN
#9.ʹ�÷���: ��ƪ�ĵ�������,chmod +x tc2 ,
#ִ�нű�: ./tc2 start (����������start | stop | restart | status | mangle )����
#�����ÿ����ppp����ʱ������,����/etc/ppp/ip-up �ļ��������һ��: /·��/tc2 restart
echo "script done!"
exit 1
#end----------------------------------------------------------------------------------------
