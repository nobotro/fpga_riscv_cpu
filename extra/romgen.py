import sys
templete='''
WIDTH={};
DEPTH={};

ADDRESS_RADIX=UNS;
DATA_RADIX=UNS;

CONTENT BEGIN
{}
END;
'''
data=''
addr=0;
for i in sys.argv[1].split('\n'):
 #print("{:032b}".format(i))
    data+="{}  : {:d};\n".format(addr,int(i,16))
    addr+=1
print templete.format(32,addr,data)

for i in sys.argv[1].split('\n'):
  line="{:032b}".format(int(i,16))
  print line[:25]+" "+line[25:]

