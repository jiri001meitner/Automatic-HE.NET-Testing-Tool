# Automatic HE.NET Testing Tool

**Automatic HE.NET Testing Tool** for daily tests with html output. This works for free IPv6 additional daily tests in **[Hurricane Electric IPv6 Certification Project](https://ipv6.he.net/certification/scoresheet.php?pass_name=meitner "Hurricane Electric IPv6 Certification Project")**. LINUX and OpenWRT friendly.

## Instaling
1)	git clone https://github.com/jiri001meitner/Automatic-HE.NET-Testing-Tool
2)	edit the file henet.sh and set logdir and installdir path
3)	edit the file henet/henet-main.sh and set installdir (the same as in the file henet.sh)
4)	edit the file henet/users.txt and set user and password after = (like f_user=yourlogin, pass_name=yourlogin, f_pass=yourpassword)
5) than you run as root henet.sh. It automatically set cronjob /etc/cron.d/henet to time 15 minuts.
6) set your webserver, I use lighttpd on OpenWRT (Router Turris)

## Uninstall
rm /etc/cron.d/henet
rm dir with Automatic HE.NET Testing Tool
