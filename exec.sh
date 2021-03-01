#! /usr/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
printf "${GREEN}Automator... ${NC}\n"
echo -e "\n"
read -p "Protrie the url: " url
echo -e "\n $url \n"
read -p "$(echo -e "Protrie Cookie parameter"${RED}" _portal_ptl_io_session"${NC} "please: " )" portal
#read -p "$(echo -e "\nProtrie Cookie parameter"${RED}" checkout-live-session" ${NC} "please:" )" checkout
#read -p "$(echo -e "\nProtrie Cookie parameter"${RED}" 1P_JAR" ${NC} "please:" )" jar
x=$(echo $url | cut -f5 -d"/"|cut -f1 -d"_")
echo -e "\n you have selected ${GREEN}$x${NC} directory: "
y=$(echo $url | cut -f5 -d"/"|cut -f2 -d"_")
read -p "$(echo -e "\n Your Current exercise is ${GREEN}$y${NC} do you want to continue to download from ${GREEN}$y${NC} or from all Y OR N(all_answers): ")" ex
tri=$(echo $url | cut --complement -f5 -d "/" | cut --complement -f5 -d "/") 
rm -rf ${x};mkdir "${x}";cd "${x}"
function pdf {
	python3 - <<END

import os
from weasyprint import HTML
from bs4 import BeautifulSoup

    
for i in os.listdir():
    k=os.path.splitext(i)[0]
    pdf=k+".pdf"
    if "html" in (os.path.splitext(i)[1]):
        r=open(i,'r').read()
        soup = BeautifulSoup(r,"html5lib")
        
        for so in soup.find_all('main',attrs={"class":"content"}):
            print(f'found --> {i}')
            #print(so)
            HTML(file_obj=str(so)).write_pdf(pdf)
            print(f'Created {k}.pdf')
            o=os.system('rm '+ i)
            print(f'Deleting --> {i}')
            
END
}
if [ "${ex}" = "Y" ];then
	for i in `seq -w "${y}" 40`;do
		echo -e "\n Url: "${tri}"/"${x}"_"${i}"/course \n"
		status_code=$(curl "${tri}"/"${x}"_"${i}"/course  -H 'Cookie: _portal_ptl_io_session='"$portal"'' --write-out %{http_code} --output /dev/null)
		echo -e "$status_code \n"
		if [ "${status_code}" -eq 200 ];then
		    curl  "${tri}"/"${x}"_"${i}"/course  -H 'Cookie: _portal_ptl_io_session='"$portal"'' --output "${x}"_"${i}".html
			#link = $(cat $x.html | grep "//trieos*" | awk '{print $3}'| cut --complement -f1 -d"/"|cut -f1 -d"'")
		    echo -e "\n Downloaded ${GREEN}'$tri/${x}_${i}/course.html'${NC} "
		    pdf
		else
			break
		fi
	done
else
    for k in `seq -w 1 40`;do
    	echo -e "\n Url: "${tri}"/"${x}"_"${k}"/course \n"
    	status_code1=$(curl "${tri}"/"${x}"_"${k}"/course  -H 'Cookie: _portal_ptl_io_session='"$portal"'' --write-out %{http_code} --output /dev/null)
		echo -e "$status_code1 \n"
		if [ "${status_code1}" -eq 200 ];then
	  	 	curl  "${tri}"/"${x}"_"${k}"/course  -H 'Cookie: _portal_ptl_io_session='"$portal"'' --output "${x}"_"${k}".html
			#link = $(cat $x.html | grep "//trieos*" | awk '{print $3}'| cut --complement -f1 -d"/"|cut -f1 -d"'")
			echo -e "\n Downloaded ${GREEN}'$tri/${x}_${k}/course.html'${NC} "
			pdf
		else
			break
		fi
		
	done

fi



