smbclient -W sdc -U 11867%sdc.2010 //172.21.67.235/Send << EOF
prompt
cd 11867
del $*
mput $*
EOF

