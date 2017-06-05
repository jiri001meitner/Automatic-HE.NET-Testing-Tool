#!/bin/bash
echo "    ___         __                        __  _     ";
echo "   /   | __  __/ /_____  ____ ___  ____ _/ /_(______";
echo "  / /| |/ / / / __/ __ \/ __ \`__ \/ __ \`/ __/ / ___/";
echo " / ___ / /_/ / /_/ /_/ / / / / / / /_/ / /_/ / /__  ";
echo "/_/ ___\__,_/\__/\____/_/ /___/_/\__,_/\__/_/\___/  ";
echo "   / / / ___    ____  ___  / /_                     ";
echo "  / /_/ / _ \  / __ \/ _ \/ __/                     ";
echo " / __  /  ___ / / / /  __/ /_                       ";
echo "/__________(_/_/ /__\___/\__/                       ";
echo " /_  _____  _____/ /_(_____  ____ _                 ";
echo "  / / / _ \/ ___/ __/ / __ \/ __ \`/                 ";
echo " / / /  __(__  / /_/ / / / / /_/ /                  ";
echo "/________/____/\__/___/ /_/\__, /                   ";
echo " /_  ______  ____  / /    /____/                    ";
echo "  / / / __ \/ __ \/ /                               ";
echo " / / / /_/ / /_/ / /                                ";
echo "/_/  \____/\____/_/                                 ";
echo "                                                    ";
dir="/tmp/.testy"
public="/www/testy"
installdir="/mnt/sdcard/bin/henet"

f_user="$(grep "f_user" < "${installdir}"/user.txt)"
f_pass="$(grep "f_pass" < "${installdir}"/user.txt)"
pass_name="$(grep "pass_name" < "${installdir}"/user.txt)"

date="$(LANG=cs_CZ LC_ALL=cs_CZ.utf8 date)"
datetime="$(date +%FT%T%z)"
echo " Start at: "$date" "

testujihosta=$(curl -- "https://gist.githubusercontent.com/jiri001meitner/3d5efda5cd08f63ec689bd462a4d2d80/raw/f3dc687ce6498dbd7183d508c519ba808895dd9e/ipv6.he.net.list" | perl -e 'srand; rand($.) < 1 && ($line = $_) while <>; print $line;')
ipv6hosta=$(dig aaaa $testujihosta +short | grep "::" | head -n 1)

echo "Testuji "$testujihosta"" > "${dir}"/testujihosta.txt
echo "#### Budu testovat "$testujihosta", jehož IPv6 je "$ipv6hosta" ####"

echo "#### Kontrola existence souborů ####"

if [ -e "${dir}" ] ; then
	echo " Složka "${dir}" existuje " ; else
	echo " Vytvářím složku "${dir}" " ; 
	mkdir "${dir}" ;	fi

if [ -e "${public}" ] ; then
	echo " Složka "${public}" existuje " ; else
	echo " Vytvářím symlink "${dir}" "${public}" " ;
	ln -s "${dir}" "${public}" ; fi

if [ -e "${installdir}"/user.txt ] ; then
    echo " Soubor settings existuje " ; else
    echo " Vytvořte soubor ${installdir}/settings, za doplňte uživatelské jméno za rovná se bez mezery na řádek f_user=, heslo doplňte analogicky do f_pass= stejným způsobem " ;
    exit 0	; fi
    
if [ -e "${dir}"/traceroute.txt ] ; then
	echo " Traceroute existuje " ; else
	echo " Kopíruji "${installdir}"/traceroute.txt "${dir}"/traceroute.txt " ;
	cp "${installdir}"/traceroute.txt "${dir}"/traceroute.txt ; fi

if [ -e "${dir}"/whois.txt ] ; then
	echo " Whois existuje " ; else
	echo " Kopíruji "${installdir}"/whois.txt "${dir}"/whois.txt " ;
	cp "${installdir}"/whois.txt "${dir}"/whois.txt ; fi

if [ -e "${dir}"/icon.svg ] ; then
	echo " Vektorový obrázek existuje " ; else
	echo " Kopíruji "${installdir}"/icon.svg "${dir}"/icon.svg " ;
	cp "${installdir}"/icon.svg "${dir}"/icon.svg ;
	ln "${dir}"/icon.svg "${dir}"/favicon.svg ; fi

if [ -e "${dir}"/icon.png ] ; then
	echo " Favicon existuje " ; else
	echo " Kopíruji "${installdir}"/icon.png "${dir}"/icon.png " ;
	cp "${installdir}"/icon.png "${dir}"/icon.png ;			
	ln "${dir}"/icon.png "${dir}"/favicon.png ; fi

echo "### Získávání informací dig aaaa, dig ptr a ping ###"

echo "### DIG AAAA ###"
echo "dig aaaa $testujihosta" >"${dir}"/aaaa.txt
      dig aaaa "$testujihosta" >>"${dir}"/aaaa.txt 2>&1

echo "### DIG PTR ###"
echo "dig -x $ipv6hosta" >"${dir}"/dig_ptr.txt
      dig -x "$ipv6hosta" >>"${dir}"/dig_ptr.txt 2>&1
      
echo "###   Ping  ###"
echo "ping6 $ipv6hosta -c 1" >"${dir}"/ping6.txt
      ping6 "$ipv6hosta" -c 1 >>"${dir}"/ping6.txt 2>&1

echo "### Příprava souborů pro odeslání a zveřejnění ###"

aaaa=$(cat "${dir}"/aaaa.txt)
aaaa_sed=$(sed 's/&(?!amp;)/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' < "${dir}"/aaaa.txt)

echo "################################################"
echo "################################################"
cat "${dir}"/aaaa.txt
echo "################################################"
echo "################################################"


ptr=$(cat "${dir}"/dig_ptr.txt)
ptr_sed=$(sed 's/&(?!amp;)/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' < "${dir}"/dig_ptr.txt)

echo "################################################"
echo "################################################"
cat "${dir}"/dig_ptr.txt
echo "################################################"
echo "################################################"

ping=$(cat "${dir}"/ping6.txt)
ping_sed=$(sed 's/&(?!amp;)/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' < "${dir}"/ping6.txt)

echo "################################################"
echo "################################################"

cat "${dir}"/ping6.txt

echo "################################################"
echo "################################################"

whois=$(cat "${dir}"/whois.txt)
whois_sed=$(sed 's/&(?!amp;)/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' < "${dir}"/whois.txt)

echo "################################################"
echo "################################################"
cat "${dir}"/whois.txt
echo "################################################"
echo "################################################"

traceroute=$(cat "${dir}"/traceroute.txt)
traceroute_sed=$(sed 's/&(?!amp;)/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' < "${dir}"/traceroute.txt)

echo "################################################"
echo "################################################"
cat "${dir}"/traceroute.txt
echo "################################################"
echo "################################################"

html_header=$(cat "${installdir}"/header.html)
html_footer="$(cat "${installdir}"/footer.html)"

echo "################################################"
echo "################################################"
echo "################################################"
echo "################################################"

echo "### Odesílám výsledky a vytvářím htlm výstup ###"
      
      echo "$html_header" > "${dir}"/index_tmp.html
      echo  '<time datetime='"\""$datetime"\""'>Last update '""$date"</time>" >> "${dir}"/index_tmp.html

cookies="$(mktemp)"
curl -L -F "$f_user" -F "$f_pass" -b "$cookies" -c "$cookies" -- 'https://ipv6.he.net/certification/login.php' &> "${dir}"/output_login.htm
    error_login=$(grep "error" <"${dir}"/output_login.htm && echo "<div class="errorMessageBox">Error</div>"|| echo '<div class="statusMessageBox"><p>OK</p></div>')

	  echo "<section><h2>Login</h2>" >> "${dir}"/index_tmp.html
	  echo "$error_login"
	  echo "$error_login" >> "${dir}"/index_tmp.html
	  echo "</section>" >> "${dir}"/index_tmp.html


sleep 1 && curl -b "$cookies" -L -F "$f_user" -F "$f_pass" -F input="$aaaa" -- 'https://ipv6.he.net/certification/daily.php?test=aaaa' &> "${dir}"/output_aaaa.htm
    error_aaaa=$(grep error "${dir}"/output_aaaa.htm || echo '<div class="validMessageBox">
<p>OK</p>
</div>')
	  echo "<section><h2>AAAA</h2>" >> "${dir}"/index_tmp.html
	  echo "$error_aaaa"
	  echo "$error_aaaa" >> "${dir}"/index_tmp.html
	  echo "</section>" >> "${dir}"/index_tmp.html

sleep 1 && curl -b "$cookies" -L -F "$f_user" -F "$f_pass" -F input="$ptr" -- 'https://ipv6.he.net/certification/daily.php?test=ptr' &> "${dir}"/output_ptr.htm
    error_ptr=$(grep error "${dir}"/output_ptr.htm || echo '<div class="validMessageBox"><p>OK</p></div>')
	  echo "<section><h2>PTR</h2>" >> "${dir}"/index_tmp.html
	  echo "$error_ptr"
	  echo "$error_ptr" >> "${dir}"/index_tmp.html
	  echo "</section>" >> "${dir}"/index_tmp.html

sleep 1 && curl -b "$cookies" -L -F "$f_user" -F "$f_pass" -F input="$ping" -- 'https://ipv6.he.net/certification/daily.php?test=ping' &> "${dir}"/output_ping.htm
    error_ping=$(grep error "${dir}"/output_ping.htm || echo '<div class="validMessageBox"><p>OK</p></div>')
	  echo "<section><h2>PING</h2>" >> "${dir}"/index_tmp.html
	  echo "$error_ping"
	  echo "$error_ping" >> "${dir}"/index_tmp.html
	  echo "</section>" >> "${dir}"/index_tmp.html

sleep 1 && curl -b "$cookies" -L -F "$f_user" -F "$f_pass" -F input="$whois" -- "https://ipv6.he.net/certification/daily.php?test=whois" &> "${dir}"/output_whois.htm
    error_whois=$(grep error "${dir}"/output_whois.htm || echo '<div class="validMessageBox"><p>OK</p></div>')
	  echo "<section><h2>Whois</h2>" >> "${dir}"/index_tmp.html
	  echo "$error_whois"
	  echo "$error_whois" >> "${dir}"/index_tmp.html
	  echo "</section>" >> "${dir}"/index_tmp.html

sleep 1 && curl -b "$cookies" -L -F "$f_user" -F "$f_pass" -F input="$traceroute" -- "https://ipv6.he.net/certification/daily.php?test=traceroute" &> "${dir}"/output_traceroute.htm
    error_traceroute=$(grep error "${dir}"/output_traceroute.htm || echo '<div class="validMessageBox"><p>OK</p></div>')
	  echo "<section><h2>Traceroute</h2>" >> "${dir}"/index_tmp.html
	  echo "$error_traceroute"
	  echo "$error_traceroute" >> "${dir}"/index_tmp.html
	  echo "</section>" >> "${dir}"/index_tmp.html

echo "################################################"
echo "################################################"

echo "### Odhlašuji a mažu cookies ###"        
sleep 2 && curl -L -b "$cookies" -- 'https://ipv6.he.net/certification/logout.php' &> "${dir}"/output_logout.htm
    error_logout=$(grep error "${dir}"/output_logout.htm || echo '<div class="statusMessageBox">
<p>Logout OK</p>
</div>')
	  echo "<section><h2>Logout</h2>" >> "${dir}"/index_tmp.html
	  echo "$error_logout"
	  echo "$error_logout" >> "${dir}"/index_tmp.html
	  rm "$cookies"
	  rm "${dir}"/output*
	  echo "</section>" >> "${dir}"/index_tmp.html

echo "################################################"
echo "################################################"

      echo "Získávám skóre"
score=$(curl -- "https://ipv6.he.net/certification/scoresheet.php?"$pass_name"" | grep "Current Score")
      echo ""$score""
	  echo "<section><h3>Score</h3>" ""$score"" "</section>" >> "${dir}"/index_tmp.html

echo "$html_footer" >> "${dir}"/index_tmp.html

mv "${dir}"/index_tmp.html "${dir}"/index.html

cat << "EOF"
       _,.
     ,` -.)
    '( _/'-\\-.               
   /,|`--._,-^|            ,     
   \_| |`-._/||          ,'|       
     |  `-, / |         /  /      
     |     || |        /  /       
      `r-._||/   __   /  /  
  __,-<_     )`-/  `./  /
 '  \   `---'   \   /  / 
     |           |./  /  
     /           //  /     
 \_/' \         |/  /         
  |    |   _,^-'/  /              
  |    , ``  (\/  /_        
   \,.->._    \X-=/^         
   (  /   `-._//^`  
    `Y-.____(__}              
     |     {__)           
           ()`     
EOF

exit 0
