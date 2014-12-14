#!/bin/bash
function makeHeader () {
	echo '<!doctype html><html lang="en"><head><meta charset="utf-8" /><meta name="viewport" content="width=1024" /><meta name="apple-mobile-web-app-capable" content="yes" />';
	echo "<title>$titl</title><meta name=\"description\" content=\"$desc\"/><meta name=\"author\" content=\"$auth\"/>"
	echo ''; #<link href="http://fonts.googleapis.com/css?family=Open+Sans:regular,semibold,italic,italicsemibold|PT+Sans:400,700,400italic,700italic|PT+Serif:400,700,400italic,700italic" rel="stylesheet" />
	echo '<link href="presentation.css" rel="stylesheet"/><link href="custom.css" rel="stylesheet"/></head><body><div class="fallback-message"><p>Your browser <b>does not support the features required</b> by impress.js, so you are presented with a simplified version of this presentation.</p><p>For the best experience please use the latest <b>Chrome</b>, <b>Safari</b> or <b>Firefox</b> browser.</p></div><div id="impress">'
}

function makeFooter () {
	echo '</div><script src="jquery.min.js"></script><script src="impress.js/js/impress.js"></script><script>impress().init();</script></body></html>'
}

function makeTitle () {
	echo '			<div id="title" class="step" data-x="0" data-y="0" data-scale="4">';
	#				<span class="try">then you should try</span>
	echo "					<h1><center>$titl</center></h1>"
	echo "				<span><center>$date</center></span>"
	echo "				<span>By $auth</span>"
	echo '			</div>';
}

function slide () {
	thex=$((1200*$slid+1200))
	echo "			<div id=\"slide$slid\" class=\"step slide bootstrapslide\" data-x=\"$thex\" data-y=\"0\">"
	echo "$cnti" | pandoc -f markdown -t html
	echo '			</div>';
	slid=$(($slid+1))
}

cnt=$(cat)
titl=$(echo "$cnt" | bash scrape.sh -t)
desc=$(echo "$cnt" | bash scrape.sh -D)
auth=$(echo "$cnt" | bash scrape.sh -a)
date=$(echo "$cnt" | bash scrape.sh -d)
slid=0;
makeHeader
makeTitle
for slb in `echo "$cnt" | grep -n -e '----' | cut -f1 -d:`
do
	slb=$(($slb+1))
	cnti=$(echo "$cnt" | tail -n +$slb)
	sle=$(echo "$cnti" | grep -n -m 1 -e '----' | cut -f1 -d:)
	if [ -n "$sle" ]
	then
		sle=$(($sle-1))
		cnti=$(echo "$cnti" | head -n $sle)
	fi
	slide
done
