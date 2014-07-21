import glob
import re

file_list = glob.glob('clean/*.csv')

fout=open("UNFPA_pop.csv","a")
# first file header:
e = open("clean/badghis.csv")
fout.write("Province," + e.readline())
# now the rest:
for file_name in file_list:
    print 'Writing ' + file_name + ' ...'
    f = open(file_name)
    for line in f:
        if re.match("District",line) is None: # had to do it this way because I'm not sure which files have headers
            province = re.sub("clean/|.csv","",file_name).capitalize()
            fout.write(province + "," + line)
    f.close() # not really needed
fout.close()
