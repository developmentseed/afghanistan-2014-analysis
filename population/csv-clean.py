import csv
import glob
import re

file_list = glob.glob('csv/*.csv')

for file in file_list:
    with open(file) as fin, open("clean/" + re.sub("csv/","",file),"wb") as fout:
        i=csv.reader(fin)
        o=csv.writer(fout)
        for row in i:
            if re.match("Total|All province",row[0]) is None:
                if len(row) == 2:
                    data = row[1].split()
                    data.insert(0,row[0])
                    o.writerow(data)
                else:
                    o.writerow(row)
