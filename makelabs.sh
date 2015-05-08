#!/bin/bash

mkdir html
html="html"
cp common/ba-lab-index.html $html

for dir in `find . -type dir -maxdepth 1|grep '[0-9]\{1,2\}-'|grep -v CVS|sed -e 's/\.\///g'`; 
do 
	cp $dir/$dir.pdf $html
        title=`cat $dir/$dir.tex|grep \\labtitle\}\{|perl -ne '$_ =~/\{([\+\-\*A-Za-z0-9 ]+)\}/; print $1;'`
        version=`cat $dir/$dir.tex |grep Revision:|perl -ne '$_ =~/([0-9].[0-9]+)/; print $1."\n";'`
        rawsize=`stat -f "%z" $dir/$dir.pdf`
        size=$(echo "scale=0;$rawsize/1024"|bc -l)
        link=`printf "\\\<li\\\>\\\<a href=\"%s\" alt=\"%s\"\>%s\\\<\/a\> \<font size\=\"-2\"\>\(Revision:%s %skb\)\<\/font\>\\\<\/li\\\>" $dir.pdf $dir.pdf "$title" $version $size`
        echo $title $version $size
        cat $html/ba-lab-index.html |sed "s/\<\!--$dir--\>/$link/" > ba-lab-index.html.tmp
        mv -f ba-lab-index.html.tmp $html/ba-lab-index.html
done

cat $html/ba-lab-index.html |sed "s/\<\!--date--\>/$date/" > ba-lab-index.html.tmp
mv -f ba-lab-index.html.tmp $html/index.html
rm $html/ba-lab-index.html

scp html/* mfrag@istlab.dmst.aueb.gr:~/public_html/labs/ba-lab

rm -R $html

