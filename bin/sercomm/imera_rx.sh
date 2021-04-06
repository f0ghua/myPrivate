smbclient -W sdc -U 11867%sdc.2010 //172.21.67.235/Receive << EOF
prompt
cd outside_s_sdc_sercomm_com/11867
mget $*
rm $*
EOF

