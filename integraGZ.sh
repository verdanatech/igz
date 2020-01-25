#!/bin/bash
# -------------------------------------------------------------------------
# @Programa 
# 	@name: integraGZ.sh
#	@versao: 3.0.1
#	@Data 25 de Janeiro de 2020
#	@Copyright: Verdanatech Soluções em TI, 2016 - 2020
#	@Copyright: Pillares Consulting, 2016
# --------------------------------------------------------------------------
# LICENSE
#
# integraGZ.sh is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# integraGZ.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------
 
#
# Variables Declaration
#

versionDate="Jul 16, 2018"
TITULO="Verdanatech iGZ - v.3.0.1"
BANNER="http://www.verdanatech.com"

devMail="halexsandro.sales@verdanatech.com"

# Discovery the system version and instanciate variables
source /etc/os-release

serverAddress=$(hostname -I | cut -d' ' -f1)

glpiVersion="GLPI 9.4.5"
zabbixVersion="Zabbix 4.4.4"

verdanatechGIT="https://github.com/verdanatech/igz"

# Control
glpiInstallTag=0
zabbixInstallTag=0

# Works DIRs

# Temp dir
TMP_DIR=/tmp

# GLPi dir
GLPI_DIR="/var/www/html/glpi"
GLPI_PLUGINS_DIR=$GLPI_DIR/plugins

# Zabbix link
zabbixDownloadLink="https://ufpr.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.4.4/zabbix-4.4.4.tar.gz"

# GLPi link
glpiDownloadLink="https://github.com/glpi-project/glpi/releases/download/9.4.5/glpi-9.4.5.tgz"

# Function erroDetect

function erroDetect(){
	clear
	echo -e "
\033[31m
 ----------------------------------------------------------- 
#                    ERRO DETECTED!!!                       #
 -----------------------------------------------------------\033[0m
  There was an error.
  An error was encountered in the installer and the process 
  was aborted.
  - - -
  \033[1m Error Description:\033[0m
 
  *\033[31m $erroDescription \033[0m
  - - -
  
  \033[1mFor commercial support contact us:\033[0m 
  
  +55 81 3091 42 52
  $comercialMail
  $devMail 
  
 ----------------------------------------------------------
  \033[32mVerdanatech Solucoes em TI - http://www.verdanatech.com\033[0m 
 ----------------------------------------------------------"

		kill $$
	
}

# Discovery the system version and instanciate variables
erroDescription="Impossible to determine the Operating System"
source /etc/os-release; [ $? -ne 0 ] && erroDetect

# Define variables by OS
case $ID in 
		debian)
			apacheUser=www-data
		;;
		
		centos)
			apacheUser=apache
		;;
	esac

#
# Functions
#

# Request for use integraGZ

REQ_TO_USE ()
{
	clear

	# Test if the systen has which package
	erroDescription="The whiptail package is required to run the integraGZ.sh"
	which whiptail; [ $? -ne 0 ] && erroDetect

	# Test if the user is root
	erroDescription="System administrator privilege is required"
	[ $UID -ne 0 ] && erroDetect


erroDescription="Operating system not supported."	
case $ID in
	
	debian)
	
	case $VERSION_ID in
		
		9)
		
			whiptail --title "${TITULO}" --backtitle "${BANNER}" --yesno "System GNU/Linux Debian $VERSION_ID was detected. Are we correct?. " --yes-button "Yes" --no-button "No" --fb 10 50
			
			if [ $? -eq 1 ]
			then
				
				whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "We apologize!\nThis script was developed for:\nCentOS 7, Debian 9.\nWe will close the running now." --fb 15 50
				kill $$
				
			fi
			
		;;
		
	esac

	;;
	
	centos)
	
	case $VERSION_ID in
		
		7)
		
			whiptail --title "${TITULO}" --backtitle "${BANNER}" --yesno "System GNU/Linux Centos $VERSION_ID was detected. Are we correct?. " --yes-button "Yes" --no-button "No" --fb 10 50
			
			if [ $? -eq 1 ]
			then
				
				whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "We apologize!\nThis script was developed for:\nCentOS 7, Debian 9.\nWe will close the running now." --fb 15 50
				kill $$
				
			fi
			
		;;
		
	esac

	;;
	
#	ubuntu)
#	
#	case $VERSION_ID in
#		
#		16.04)
#		
#			whiptail --title "${TITULO}" --backtitle "${BANNER}" --yesno "System GNU/Linux Ubuntu $VERSION_ID was detected. Are we correct?. " --yes-button "Yes" --no-button "No" --fb 10 50
#			
#			if [ $? -eq 1 ]
#			then
#				
#				whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "We apologize!\nThis script was developed for:\nCentOS 7, Debian 9 and Ubuntu 16.04.\nWe will close the running now." --fb 15 50
#				kill $$
#				
#			fi
#			
#		;;
#		
#	esac
#
#	;;
	
	*)
	
	erroDetect
	
	;;
	
esac

}

SET_REPOS ()
{

	clear 
	
	echo "Adding repositories, updating and upgrading the system..."
	
	sleep 1
	
	case $ID in

		debian)
		
			case $VERSION_ID in 
		
				9)
		
					echo "deb http://ftp.de.debian.org/debian stretch main" > /etc/apt/sources.list
					echo "deb http://ftp.de.debian.org/debian stretch main non-free" >> /etc/apt/sources.list
					echo "deb http://security.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list
					
					apt-get update
					apt-get upgrade -y
					clear
					
				;;
				
				10)
				
					echo "deb http://ftp.br.debian.org/debian/ buster main" > /etc/apt/sources.list
					echo "deb-src http://ftp.br.debian.org/debian/ buster main" >> /etc/apt/sources.list
					echo "deb http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list
					echo "deb-src http://security.debian.org/debian-security buster/updates main contrib" >> /etc/apt/sources.list
					echo "deb http://ftp.de.debian.org/debian buster main non-free"  >> /etc/apt/sources.list
				
					apt-get update
					apt-get upgrade -y
					clear
				
				;;
				
			esac
			
			;;
					
		centos)
		
			case $VERSION_ID in 
				7) 
				
					rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
					yum -y update
					yum -y upgrade
					
					clear
				
				;;
				
			esac
			
			;;
		
	esac	
}

LAMP_INSTALL ()
{
	
	case $ID in
		
		debian)
		
			case $VERSION_ID in
								
				9)
				
					clear
					echo "Intalling Debian packages for GLPI..."
					sleep 1
					apt-get -y install apache2 bsdtar bzip2 curl libapache2-mod-php7.0 libmariadbd-dev libmariadbd18 mariadb-server openjdk-8-jdk php-soap php-cas php7.0 php7.0-apcu php7.0-cli php7.0-common php7.0-curl php7.0-gd php7.0-imap php7.0-ldap php7.0-mysql php7.0-snmp php7.0-xmlrpc php7.0-xml php7.0-mbstring php7.0-bcmath
				;;
				
				10)
				
					clear
					echo "Intalling Debian packages for GLPI..."
					sleep 1
					apt-get -y install apache2 bsdtar bzip2 curl libapache2-mod-php7.3 libmariadbd-dev mariadb-server php-soap php-cas php7.3 php-apcu php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-imap php7.3-ldap php7.3-mysql php7.3-snmp php7.3-xmlrpc php7.3-xml php7.3-mbstring php7.3-bcmath

				;;
					
			esac
			;;
			
#		ubuntu)
#		
#			case $VERSION_ID in
#								
#				16.04)
#				
#					clear
#					echo "Intalling Debian packages for GLPI..."
#					sleep 1
#					apt-get -y install apache2 bsdtar bzip2 curl libapache2-mod-php7.0 libmariadbd-dev libmariadbd18 mariadb-server openjdk-8-jdk php-soap php7.0 php-apcu php7.0-cli php7.0-common php7.0-curl php7.0-gd php7.0-imap php7.0-ldap php7.0-mysql php7.0-snmp php7.0-xmlrpc php7.0-xml php7.0-mbstring php7.0-bcmath
#				;;	
#					
#			esac
#			;;		

		centos)
		
			case $VERSION_ID in
				
				7)
				
					clear
					echo "Intalling CentOS packages for GLPI..."
					sleep 1
					yum -y install bsdtar git httpd httpd-devel mariadb-devel mariadb-server php php-cas php-apcu php-bcmath php-cli php-common php-gd php-imap php-ldap php-mbstring php-mysql php-opcache php-pdo php-xmlreader php-xmlrpc php-xmlwriter wget
					
					systemctl start httpd
					systemctl enable httpd
					
					systemctl start mariadb
					systemctl enable mariadb
					
					# Openning http port on Firewall
					firewall-cmd --permanent --add-port=80/tcp
					firewall-cmd --reload
					setsebool -P httpd_can_network_connect on
					setsebool -P httpd_can_network_connect_db on
					setsebool -P httpd_can_sendmail on
					
					systemctl start httpd.service
					systemctl enable httpd.service
					
					setenforce 0;

				;;
				
			esac
			;;
		esac
	
	
}

SET_TIME_ZONE ()
{
	
# Configura timezone do PHP para o servidor
# Ref: http://php.net/manual/pt_BR/timezones.php
# 

whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "
Now we configure the servers timezone. Select the timezone that best meets!" \
--fb 10 50

while [ -z $timePart1 ]
do

timePart1=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --radiolist \
"Select the timezone for your Server!" 20 60 10 \
	"Africa" "" OFF \
	"America" "" OFF \
	"Antarctica" "" OFF \
	"Arctic" "" OFF \
	"Asia" "" OFF \
	"Atlantic" "" OFF \
	"Australia" "" OFF \
	"Europe" "" OFF \
	"Indian" "" OFF \
	"Pacific" "" OFF   \
3>&1 1>&2 2>&3)
done

case $timePart1 in

	Africa)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Abidjan" "" OFF \
			"Accra" "" OFF \
			"Addis_Ababa" "" OFF \
			"Algiers" "" OFF \
			"Asmara" "" OFF \
			"Asmera" "" OFF \
			"Bamako" "" OFF \
			"Bangui" "" OFF \
			"Banjul" "" OFF \
			"Bissau" "" OFF \
			"Blantyre" "" OFF \
			"Brazzaville" "" OFF \
			"Bujumbura" "" OFF \
			"Cairo" "" OFF \
			"Casablanca" "" OFF \
			"Ceuta" "" OFF \
			"Conakry" "" OFF \
			"Dakar" "" OFF \
			"Dar_es_Salaam" "" OFF \
			"Djibouti" "" OFF \
			"Douala" "" OFF \
			"El_Aaiun" "" OFF \
			"Freetown" "" OFF \
			"Gaborone" "" OFF \
			"Harare" "" OFF \
			"Johannesburg" "" OFF \
			"Juba" "" OFF \
			"Kampala" "" OFF \
			"Khartoum" "" OFF \
			"Kigali" "" OFF \
			"Kinshasa" "" OFF \
			"Lagos" "" OFF \
			"Libreville" "" OFF \
			"Lome" "" OFF \
			"Luanda" "" OFF \
			"Lubumbashi" "" OFF \
			"Lusaka" "" OFF \
			"Malabo" "" OFF \
			"Maputo" "" OFF \
			"Maseru" "" OFF \
			"Mbabane" "" OFF \
			"Mogadishu" "" OFF \
			"Monrovia" "" OFF \
			"Nairobi" "" OFF \
			"Ndjamena" "" OFF \
			"Niamey" "" OFF \
			"Nouakchott" "" OFF \
			"Ouagadougou" "" OFF \
			"Porto-Novo" "" OFF \
			"Sao_Tome" "" OFF \
			"Timbuktu" "" OFF \
			"Tripoli" "" OFF   3>&1 1>&2 2>&3)
	done
	;;

	America)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Adak" "" OFF \
			"Anchorage" "" OFF \
			"Anguilla" "" OFF \
			"Antigua" "" OFF \
			"Araguaina" "" OFF \
			"Argentina/Buenos_Aires" "" OFF \
			"Argentina/Catamarca" "" OFF \
			"Argentina/ComodRivadavia" "" OFF \
			"Argentina/Cordoba" "" OFF \
			"Argentina/Jujuy" "" OFF \
			"Argentina/La_Rioja" "" OFF \
			"Argentina/Mendoza" "" OFF \
			"Argentina/Rio_Gallegos" "" OFF \
			"Argentina/Salta" "" OFF \
			"Argentina/San_Juan" "" OFF \
			"Argentina/San_Luis" "" OFF \
			"Argentina/Tucuman" "" OFF \
			"Argentina/Ushuaia" "" OFF \
			"Aruba" "" OFF \
			"Asuncion" "" OFF \
			"Atikokan" "" OFF \
			"Atka" "" OFF \
			"Bahia" "" OFF \
			"Bahia_Banderas" "" OFF \
			"Barbados" "" OFF \
			"Belem" "" OFF \
			"Belize" "" OFF \
			"Blanc-Sablon" "" OFF \
			"Boa_Vista" "" OFF \
			"Bogota" "" OFF \
			"Boise" "" OFF \
			"Buenos_Aires" "" OFF \
			"Cambridge_Bay" "" OFF \
			"Campo_Grande" "" OFF \
			"Cancun" "" OFF \
			"Caracas" "" OFF \
			"Catamarca" "" OFF \
			"Cayenne" "" OFF \
			"Cayman" "" OFF \
			"Chicago" "" OFF \
			"Chihuahua" "" OFF \
			"Coral_Harbour" "" OFF \
			"Cordoba" "" OFF \
			"Costa_Rica" "" OFF \
			"Creston" "" OFF \
			"Cuiaba" "" OFF \
			"Curacao" "" OFF \
			"Danmarkshavn" "" OFF \
			"Dawson" "" OFF \
			"Dawson_Creek" "" OFF \
			"Denver" "" OFF \
			"Detroit" "" OFF \
			"Dominica" "" OFF \
			"Edmonton" "" OFF \
			"Eirunepe" "" OFF \
			"El_Salvador" "" OFF \
			"Ensenada" "" OFF \
			"Fort_Nelson" "" OFF \
			"Fort_Wayne" "" OFF \
			"Fortaleza" "" OFF \
			"Glace_Bay" "" OFF \
			"Godthab" "" OFF \
			"Goose_Bay" "" OFF \
			"Grand_Turk" "" OFF \
			"Grenada" "" OFF \
			"Guadeloupe" "" OFF \
			"Guatemala" "" OFF \
			"Guayaquil" "" OFF \
			"Guyana" "" OFF \
			"Halifax" "" OFF \
			"Havana" "" OFF \
			"Hermosillo" "" OFF \
			"Indiana/Indianapolis" "" OFF \
			"Indiana/Knox" "" OFF \
			"Indiana/Marengo" "" OFF \
			"Indiana/Petersburg" "" OFF \
			"Indiana/Tell_City" "" OFF \
			"Indiana/Vevay" "" OFF \
			"Indiana/Vincennes" "" OFF \
			"Indiana/Winamac" "" OFF \
			"Indianapolis" "" OFF \
			"Inuvik" "" OFF \
			"Iqaluit" "" OFF \
			"Jamaica" "" OFF \
			"Jujuy" "" OFF \
			"Juneau" "" OFF \
			"Kentucky/Louisville" "" OFF \
			"Kentucky/Monticello" "" OFF \
			"Knox_IN" "" OFF \
			"Kralendijk" "" OFF \
			"La_Paz" "" OFF \
			"Lima" "" OFF \
			"Los_Angeles" "" OFF \
			"Louisville" "" OFF \
			"Lower_Princes" "" OFF \
			"Maceio" "" OFF \
			"Managua" "" OFF \
			"Manaus" "" OFF \
			"Marigot" "" OFF \
			"Martinique" "" OFF \
			"Matamoros" "" OFF \
			"Mazatlan" "" OFF \
			"Mendoza" "" OFF \
			"Menominee" "" OFF \
			"Merida" "" OFF \
			"Metlakatla" "" OFF \
			"Mexico_City" "" OFF \
			"Miquelon" "" OFF \
			"Moncton" "" OFF \
			"Monterrey" "" OFF \
			"Montevideo" "" OFF \
			"Montreal" "" OFF \
			"Montserrat" "" OFF \
			"Nassau" "" OFF \
			"New_York" "" OFF \
			"Nipigon" "" OFF \
			"Nome" "" OFF \
			"Noronha" "" OFF \
			"North_Dakota/Beulah" "" OFF \
			"North_Dakota/Center" "" OFF \
			"North_Dakota/New_Salem" "" OFF \
			"Ojinaga" "" OFF \
			"Panama" "" OFF \
			"Pangnirtung" "" OFF \
			"Paramaribo" "" OFF \
			"Phoenix" "" OFF \
			"Port-au-Prince" "" OFF \
			"Port_of_Spain" "" OFF \
			"Porto_Acre" "" OFF \
			"Porto_Velho" "" OFF \
			"Puerto_Rico" "" OFF \
			"Rainy_River" "" OFF \
			"Rankin_Inlet" "" OFF \
			"Recife" "" OFF \
			"Regina" "" OFF \
			"Resolute" "" OFF \
			"Rio_Branco" "" OFF \
			"Rosario" "" OFF \
			"Santa_Isabel" "" OFF \
			"Santarem" "" OFF \
			"Santiago" "" OFF \
			"Santo_Domingo" "" OFF \
			"Sao_Paulo" "" OFF \
			"Scoresbysund" "" OFF \
			"Shiprock" "" OFF \
			"Sitka" "" OFF \
			"St_Barthelemy" "" OFF \
			"St_Johns" "" OFF \
			"St_Kitts" "" OFF \
			"St_Lucia" "" OFF \
			"St_Thomas" "" OFF \
			"St_Vincent" "" OFF \
			"Swift_Current" "" OFF \
			"Tegucigalpa" "" OFF \
			"Thule" "" OFF \
			"Thunder_Bay" "" OFF \
			"Tijuana" "" OFF \
			"Toronto" "" OFF \
			"Tortola" "" OFF \
			"Vancouver" "" OFF \
			"Virgin" "" OFF \
			"Whitehorse" "" OFF \
			"Winnipeg" "" OFF \
			"Yakutat" "" OFF   3>&1 1>&2 2>&3)
		done
		;;
		

	Antarctica)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Casey" "" OFF \
			"Davis" "" OFF \
			"DumontDUrville" "" OFF \
			"Macquarie" "" OFF \
			"Mawson" "" OFF \
			"McMurdo" "" OFF \
			"Palmer" "" OFF \
			"Rothera" "" OFF \
			"South_Pole" "" OFF \
			"Syowa" "" OFF \
			"Troll" "" OFF \
			"Vostok"  "" OFF    3>&1 1>&2 2>&3)
	done
	;;

	Arctic)
	while [ -z $timePart2 ]
	do

		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Longyearbyen" "" OFF    3>&1 1>&2 2>&3)
	done
	;;

	Asia)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Aden" "" OFF \
			"Almaty" "" OFF \
			"Amman" "" OFF \
			"Anadyr" "" OFF \
			"Aqtau" "" OFF \
			"Aqtobe" "" OFF \
			"Ashgabat" "" OFF \
			"Ashkhabad" "" OFF \
			"Baghdad" "" OFF \
			"Bahrain" "" OFF \
			"Baku" "" OFF \
			"Bangkok" "" OFF \
			"Beirut" "" OFF \
			"Bishkek" "" OFF \
			"Brunei" "" OFF \
			"Calcutta" "" OFF \
			"Chita" "" OFF \
			"Choibalsan" "" OFF \
			"Chongqing" "" OFF \
			"Chungking" "" OFF \
			"Colombo" "" OFF \
			"Dacca" "" OFF \
			"Damascus" "" OFF \
			"Dhaka" "" OFF \
			"Dili" "" OFF \
			"Dubai" "" OFF \
			"Dushanbe" "" OFF \
			"Gaza" "" OFF \
			"Harbin" "" OFF \
			"Hebron" "" OFF \
			"Ho_Chi_Minh" "" OFF \
			"Hong_Kong" "" OFF \
			"Hovd" "" OFF \
			"Irkutsk" "" OFF \
			"Istanbul" "" OFF \
			"Jakarta" "" OFF \
			"Jayapura" "" OFF \
			"Jerusalem" "" OFF \
			"Kabul" "" OFF \
			"Kamchatka" "" OFF \
			"Karachi" "" OFF \
			"Kashgar" "" OFF \
			"Kathmandu" "" OFF \
			"Katmandu" "" OFF \
			"Khandyga" "" OFF \
			"Kolkata" "" OFF \
			"Krasnoyarsk" "" OFF \
			"Kuala_Lumpur" "" OFF \
			"Kuching" "" OFF \
			"Kuwait" "" OFF \
			"Macao" "" OFF \
			"Macau" "" OFF \
			"Magadan" "" OFF \
			"Makassar" "" OFF \
			"Manila" "" OFF \
			"Muscat" "" OFF \
			"Nicosia" "" OFF \
			"Novokuznetsk" "" OFF \
			"Novosibirsk" "" OFF \
			"Omsk" "" OFF \
			"Oral" "" OFF \
			"Phnom_Penh" "" OFF \
			"Pontianak" "" OFF \
			"Pyongyang" "" OFF \
			"Qatar" "" OFF \
			"Qyzylorda" "" OFF \
			"Rangoon" "" OFF \
			"Riyadh" "" OFF \
			"Saigon" "" OFF \
			"Sakhalin" "" OFF \
			"Samarkand" "" OFF \
			"Seoul" "" OFF \
			"Shanghai" "" OFF \
			"Singapore" "" OFF \
			"Srednekolymsk" "" OFF \
			"Taipei" "" OFF \
			"Tashkent" "" OFF \
			"Tbilisi" "" OFF \
			"Tehran" "" OFF \
			"Tel_Aviv" "" OFF \
			"Thimbu" "" OFF \
			"Thimphu" "" OFF \
			"Tokyo" "" OFF \
			"Ujung_Pandang" "" OFF \
			"Ulaanbaatar" "" OFF \
			"Ulan_Bator" "" OFF \
			"Urumqi" "" OFF \
			"Ust-Nera" "" OFF \
			"Vientiane" "" OFF \
			"Vladivostok" "" OFF \
			"Yakutsk" "" OFF \
			"Yekaterinburg" "" OFF     3>&1 1>&2 2>&3)
	done
	;;

	Atlantic)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Azores" "" OFF \
			"Bermuda" "" OFF \
			"Canary" "" OFF \
			"Cape_Verde" "" OFF \
			"Faeroe" "" OFF \
			"Faroe" "" OFF \
			"Jan_Mayen" "" OFF \
			"Madeira" "" OFF \
			"Reykjavik" "" OFF \
			"South_Georgia" "" OFF \
			"St_Helena" "" OFF \
			"Stanley" "" OFF      3>&1 1>&2 2>&3)
	done
	;;

	Australia)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"ACT" "" OFF \
			"Adelaide" "" OFF \
			"Brisbane" "" OFF \
			"Broken_Hill" "" OFF \
			"Canberra" "" OFF \
			"Currie" "" OFF \
			"Darwin" "" OFF \
			"Eucla" "" OFF \
			"Hobart" "" OFF \
			"LHI" "" OFF \
			"Lindeman" "" OFF \
			"Lord_Howe" "" OFF \
			"Melbourne" "" OFF \
			"North" "" OFF \
			"NSW" "" OFF \
			"Perth" "" OFF \
			"Queensland" "" OFF \
			"South" "" OFF \
			"Sydney" "" OFF \
			"Tasmania" "" OFF \
			"Victoria" "" OFF \
			"West" "" OFF \
			"Yancowinna" "" OFF      3>&1 1>&2 2>&3)
	done
	;;

	Europe)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Amsterdam" "" OFF \
			"Andorra" "" OFF \
			"Athens" "" OFF \
			"Belfast" "" OFF \
			"Belgrade" "" OFF \
			"Berlin" "" OFF \
			"Bratislava" "" OFF \
			"Brussels" "" OFF \
			"Bucharest" "" OFF \
			"Budapest" "" OFF \
			"Busingen" "" OFF \
			"Chisinau" "" OFF \
			"Copenhagen" "" OFF \
			"Dublin" "" OFF \
			"Gibraltar" "" OFF \
			"Guernsey" "" OFF \
			"Helsinki" "" OFF \
			"Isle_of_Man" "" OFF \
			"Istanbul" "" OFF \
			"Jersey" "" OFF \
			"Kaliningrad" "" OFF \
			"Kiev" "" OFF \
			"Lisbon" "" OFF \
			"Ljubljana" "" OFF \
			"London" "" OFF \
			"Luxembourg" "" OFF \
			"Madrid" "" OFF \
			"Malta" "" OFF \
			"Mariehamn" "" OFF \
			"Minsk" "" OFF \
			"Monaco" "" OFF \
			"Moscow" "" OFF \
			"Nicosia" "" OFF \
			"Oslo" "" OFF \
			"Paris" "" OFF \
			"Podgorica" "" OFF \
			"Prague" "" OFF \
			"Riga" "" OFF \
			"Rome" "" OFF \
			"Samara" "" OFF \
			"San_Marino" "" OFF \
			"Sarajevo" "" OFF \
			"Simferopol" "" OFF \
			"Skopje" "" OFF \
			"Sofia" "" OFF \
			"Stockholm" "" OFF \
			"Tallinn" "" OFF \
			"Tirane" "" OFF \
			"Tiraspol" "" OFF \
			"Uzhgorod" "" OFF \
			"Vaduz" "" OFF \
			"Vatican" "" OFF \
			"Vienna" "" OFF \
			"Vilnius" "" OFF \
			"Volgograd" "" OFF \
			"Warsaw" "" OFF \
			"Zagreb" "" OFF \
			"Zaporozhye" "" OFF \
			"Zurich" "" OFF      3>&1 1>&2 2>&3)
	done
	;;

	Indian)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Antananarivo" "" OFF \
			"Chagos" "" OFF \
			"Christmas" "" OFF \
			"Cocos" "" OFF \
			"Comoro" "" OFF \
			"Kerguelen" "" OFF \
			"Mahe" "" OFF \
			"Maldives" "" OFF \
			"Mauritius" "" OFF \
			"Mayotte" "" OFF \
			"Reunion" "" OFF      3>&1 1>&2 2>&3)
	done
	;;

	Pacific)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Apia" "" OFF \
			"Auckland" "" OFF \
			"Bougainville" "" OFF \
			"Chatham" "" OFF \
			"Chuuk" "" OFF \
			"Easter" "" OFF \
			"Efate" "" OFF \
			"Enderbury" "" OFF \
			"Fakaofo" "" OFF \
			"Fiji" "" OFF \
			"Funafuti" "" OFF \
			"Galapagos" "" OFF \
			"Gambier" "" OFF \
			"Guadalcanal" "" OFF \
			"Guam" "" OFF \
			"Honolulu" "" OFF \
			"Johnston" "" OFF \
			"Kiritimati" "" OFF \
			"Kosrae" "" OFF \
			"Kwajalein" "" OFF \
			"Majuro" "" OFF \
			"Marquesas" "" OFF \
			"Midway" "" OFF \
			"Nauru" "" OFF \
			"Niue" "" OFF \
			"Norfolk" "" OFF \
			"Noumea" "" OFF \
			"Pago_Pago" "" OFF \
			"Palau" "" OFF \
			"Pitcairn" "" OFF \
			"Pohnpei" "" OFF \
			"Ponape" "" OFF \
			"Port_Moresby" "" OFF \
			"Rarotonga" "" OFF \
			"Saipan" "" OFF \
			"Samoa" "" OFF \
			"Tahiti" "" OFF \
			"Tarawa" "" OFF \
			"Tongatapu" "" OFF \
			"Truk" "" OFF \
			"Wake" "" OFF \
			"Wallis" "" OFF \
			"Yap" "" OFF      3>&1 1>&2 2>&3)
	done
	;;
	
esac

}

ZABBIX_INSTALL ()
{

	# Enabling Zabbix TAG to On
	zabbixInstallTag=1
	
	clear 
	
	case $ID in
		
		debian)
		
			case $VERSION_ID in
								
				9)
					erroDescription="Package installation error"
					
					clear
					echo "Intalling Debian packages for Zabbix..."
					sleep 1
					apt-get -y install sudo git python-pip libxml2 libxml2-dev curl fping libcurl3 libevent-dev libpcre3-dev libcurl3-gnutls libcurl3-gnutls-dev libcurl4-gnutls-dev build-essential libssh2-1-dev libssh2-1 libiksemel-dev libiksemel-utils libiksemel3 fping libopenipmi-dev snmp snmp-mibs-downloader libsnmp-dev libmariadbd18 libmariadbd-dev snmpd ttf-dejavu-core libltdl7 libodbc1 libgnutls28-dev libldap2-dev openjdk-8-jdk unixodbc-dev mariadb-server

					[ $? -ne 0 ] && erroDetect
					
					erroDescription="Zabbix API Package installation error"
					
					pip install zabbix-api
					[ $? -ne 0 ] && erroDetect
				;;
				
			esac
		;;
		
#		ubuntu)
#		
#			case $VERSION_ID in
#								
#				16.04)
#					clear
#					echo "Intalling Ubuntu packages for Zabbix..."
#					sleep 1
#					apt-get -y install sudo git python-pip libmysqlclient-dev libxml2 libxml2-dev curl fping libcurl3 libevent-dev libpcre3-dev libcurl3-gnutls libcurl3-gnutls-dev libcurl4-gnutls-dev build-essential libssh2-1-dev libssh2-1 libiksemel-dev libiksemel-utils libiksemel3 fping libopenipmi-dev snmp snmp-mibs-downloader libsnmp-dev libmariadbd18 libmariadbd-dev snmpd ttf-dejavu-core libltdl7 libodbc1 libgnutls28-dev libldap2-dev openjdk-8-jdk unixodbc-dev mariadb-server
#					pip install zabbix-api
#				;;
#				
#			esac
#		;;
		
		centos)
		
			case $VERSION_ID in
				
				7)
					erroDescription="Package installation error"
					
					clear
					echo "Intalling CentOS 7 packages for Zabbix..."
					sleep 1

					yum -y install gcc python2-pip net-snmp net-snmp-devel net-snmp-utils net-snmp-libs iksemel-devel zlib-devel glibc-devel curl-devel automake libidn-devel openssl-devel rpm-devel OpenIPMI-devel libssh2-devel make fping libxml2-devel unixODBC unixODBC-devel
					
					[ $? -ne 0 ] && erroDetect
					
					erroDescription="Zabbix API Package installation error"
					
					pip install zabbix-api
					[ $? -ne 0 ] && erroDetect
					
				;;
				
			esac
		;;
		
	esac
	
	echo "Executing and compilling zabbix..."
	sleep 1

	## Zabbix install process

	# Creating system user
	groupadd zabbix
	useradd -g zabbix -s /bin/false zabbix
	
	sleep 1

	# Geting and compilling zabbix
	cd /tmp
	
	# Removing all zabbix old files if exist
	rm zabbix* -Rf
	
	# Getting zabbix
	erroDescription="Error downloading zabbix"
	wget -qO- $zabbixDownloadLink | tar -zxv
	[ $? -ne 0 ] && erroDetect
	
	cd $(ls -g | grep zabbix- | grep ^d | rev | cut -d" " -f1 | rev)

	erroDescription="Error to configure zabbix package"
	./configure --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2 --with-ssh2 --with-ldap --with-iconv --with-gnutls --with-unixodbc --with-openipmi --with-jabber=/usr --enable-ipv6 --prefix=/usr/local/zabbix
	[ $? -ne 0 ] && erroDetect
	
	erroDescription="Error creating binary package"
	make install
	[ $? -ne 0 ] && erroDetect
	
	# Preparando scripts de serviço	
	ln -s /usr/local/zabbix/etc /etc/zabbix
	
	# Creating DataBase
	DB_CREATE
	
	case $ID in
		
		debian)
			
			mv misc/init.d/debian/zabbix* /etc/init.d/
			
			sed -i 's/DAEMON=\/usr\/local\/sbin\/${NAME}*/DAEMON=\/usr\/local\/zabbix\/sbin\/${NAME}/' /etc/init.d/zabbix*server
			sed -i 's/DAEMON=\/usr\/local\/sbin\/${NAME}*/DAEMON=\/usr\/local\/zabbix\/sbin\/${NAME}/' /etc/init.d/zabbix*agent*

			update-rc.d zabbix-server defaults
			update-rc.d zabbix-agent defaults
			
			cp /etc/init.d/zabbix-agent /etc/rc5.d/S02zabbix-agent
			cp /etc/init.d/zabbix-server /etc/rc5.d/S02zabbix-server
			
		;;
		
#		ubuntu)
#			
#			mv misc/init.d/ubuntu/zabbix* /etc/init.d/
#			chmod +x /etc/init.d/zabbix-*
#			
#			sed -i 's/DAEMON=\/usr\/local\/sbin\/${NAME}*/DAEMON=\/usr\/local\/zabbix\/sbin\/${NAME}/' /etc/init.d/zabbix-server.conf
#			sed -i 's/DAEMON=\/usr\/local\/sbin\/${NAME}*/DAEMON=\/usr\/local\/zabbix\/sbin\/${NAME}/' /etc/init.d/zabbix-agent.conf
#
#			update-rc.d zabbix-server.conf defaults
#			update-rc.d zabbix-agent.conf defaults
#			
#			cp /etc/init.d/zabbix-agent.conf /etc/rc5.d/S02zabbix-agent
#			cp /etc/init.d/zabbix-server.conf /etc/rc5.d/S02zabbix-server
#			
#		;;
		
		centos)
		
			mv misc/init.d/fedora/core5/zabbix* /etc/init.d/
			
			sed -i 's/ZABBIX_BIN="\/usr\/local\/sbin\/zabbix_agentd"/ZABBIX_BIN="\/usr\/local\/zabbix\/sbin\/zabbix_agentd"/' /etc/init.d/zabbix_agentd
			sed -i 's/ZABBIX_BIN="\/usr\/local\/sbin\/zabbix_server"/ZABBIX_BIN="\/usr\/local\/zabbix\/sbin\/zabbix_server"/' /etc/init.d/zabbix_server

			chkconfig --add zabbix_server
			chkconfig --add zabbix_agentd
			chkconfig --level 35 zabbix_server on
			chkconfig --level 35 zabbix_agentd on

			systemctl enable zabbix_agentd
			systemctl enable zabbix_server
						
		;;
		
	esac
	
	chmod 775 /etc/init.d/zabbix*
	
	# Adequando arquivos de log de zabbix-server e zabbix-agent
	mkdir /var/log/zabbix
	chown root:zabbix /var/log/zabbix
	chmod 775 /var/log/zabbix

	sed -i 's/LogFile=\/tmp\/zabbix_agentd.log*/LogFile=\/var\/log\/zabbix\/zabbix_agentd.log/' /etc/zabbix/zabbix_agentd.conf
	sed -i 's/LogFile=\/tmp\/zabbix_server.log*/LogFile=\/var\/log\/zabbix\/zabbix_server.log/' /etc/zabbix/zabbix_server.conf
	
	# Habilitando execução de comandos via Zabbix
	sed -i 's/# EnableRemoteCommands=0*/EnableRemoteCommands=1/' /etc/zabbix/zabbix_agentd.conf
	
	# Criando atalhos para binários
	ln -s /usr/local/zabbix/sbin/zabbix_agentd /sbin/zabbix_agentd
	ln -s /usr/local/zabbix/sbin/zabbix_server /sbin/zabbix_server

	ln -s /usr/local/zabbix/bin/zabbix_get /bin/zabbix_get
	ln -s /usr/local/zabbix/bin/zabbix_sender /bin/zabbix_sender
	
	# Iniciando serviços zabbix
		
	case $ID in
			debian)
			
				systemctl start zabbix-server
				systemctl start zabbix-agent
				
			;;
			
			centos)
			
				systemctl start zabbix_server
				systemctl start zabbix_agentd
				
			;;
	esac

	# Preparando o zabbix frontend
	mv frontends/php /var/www/html/zabbix

	SET_TIME_ZONE

	case $ID in
		debian)
			echo -e "# Define /zabbix alias, this is the default\n#Created by Verdanatech integraGZ.sh\n<IfModule mod_alias.c>\n    Alias /zabbix /var/www/html/zabbix\n</IfModule>\n\n<Directory \"/var/www/html/zabbix\">\n\tOptions FollowSymLinks\n\tAllowOverride None\n\tOrder allow,deny\n\tAllow from all\n\n\tphp_value max_execution_time 300\n\tphp_value memory_limit 128M\n\tphp_value post_max_size 16M\n\tphp_value upload_max_filesize 2M\n\tphp_value max_input_time 300\n\tphp_value date.timezone $timePart1/$timePart2\n\tphp_value always_populate_raw_post_data -1\n</Directory>\n\n<Directory \"/var/www/html/zabbix/conf\">\n\tOrder deny,allow\n\tDeny from all\n\t<files *.php>\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</files>\n</Directory>\n\n<Directory \"/var/www/html/zabbix/api\">\n\tOrder deny,allow\n\tDeny from all\n\t<files *.php>\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</files>\n</Directory>\n\n<Directory \"/var/www/html/zabbix/include\">\n\tOrder deny,allow\n\tDeny from all\n\t<files *.php>\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</files>\n</Directory>\n\n<Directory \"/var/www/html/zabbix/include/classes\">\n\tOrder deny,allow\n\tDeny from all\n\t<files *.php>\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</files>\n</Directory>\n" > /etc/apache2/conf-available/zabbix.conf
		;;
		
		centos)
			echo -e "# Define /zabbix alias, this is the default\n#Created by Verdanatech integraGZ.sh\n<IfModule mod_alias.c>\n    Alias /zabbix /var/www/html/zabbix\n</IfModule>\n\n<Directory \"/var/www/html/zabbix\">\n\tOptions FollowSymLinks\n\tAllowOverride None\n\tOrder allow,deny\n\tAllow from all\n\n\tphp_value max_execution_time 300\n\tphp_value memory_limit 128M\n\tphp_value post_max_size 16M\n\tphp_value upload_max_filesize 2M\n\tphp_value max_input_time 300\n\tphp_value date.timezone $timePart1/$timePart2\n\tphp_value always_populate_raw_post_data -1\n</Directory>\n\n<Directory \"/var/www/html/zabbix/conf\">\n\tOrder deny,allow\n\tDeny from all\n\t<files *.php>\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</files>\n</Directory>\n\n<Directory \"/var/www/html/zabbix/api\">\n\tOrder deny,allow\n\tDeny from all\n\t<files *.php>\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</files>\n</Directory>\n\n<Directory \"/var/www/html/zabbix/include\">\n\tOrder deny,allow\n\tDeny from all\n\t<files *.php>\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</files>\n</Directory>\n\n<Directory \"/var/www/html/zabbix/include/classes\">\n\tOrder deny,allow\n\tDeny from all\n\t<files *.php>\n\t\tOrder deny,allow\n\t\tDeny from all\n\t</files>\n</Directory>\n" > /etc/httpd/conf.d/zabbix.conf
			
		;;
	esac
			
	# Set correct permissions to System resources
	
	chmod +s $(which ping)
	chmod +s $(which fping)
	chmod +s $(which ping6)
	chmod +s $(which fping6)

	# Restarting http server
	
	case $ID in
		debian)
		
			# Enabling zabbix confgurations site
			a2enconf zabbix
			
			chmod 775 /var/www/html/zabbix -Rf
			chown $apacheUser:$apacheUser /var/www/html/zabbix -Rf
			systemctl reload apache2
		;;
		
		centos)
			chmod 775 /var/www/html/zabbix -Rf
			chown $apacheUser:$apacheUser /var/www/html/zabbix -Rf
			systemctl restart httpd.service
		;;
		
	esac	

}

DB_CREATE ()
{

	clear 
	
	echo "Making SQL ..."
	echo "Creating Data Base for systems.."
	echo ""
	sleep 2
	
	erroDescription="MySQL executable not found"
	which mysql; [ $? -ne 0 ] && erroDetect
	
	test_connection=1
	
	while [ $test_connection != 0 ]
	do
		mysql -uroot $(if test $rootPWD_SQL ; then -p$rootPWD_SQL; fi) -e "" 2> /dev/null
		test_connection=$?

		if [ $test_connection != 0 ]
		then
			rootPWD_SQL=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Enter the root user password for the SQL Server" --fb 10 50 3>&1 1>&2 2>&3)
			mysql -uroot $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) -e "" 2> /dev/null
			test_connection=$?	
		fi
		
	done
	
	if [ $zabbixInstallTag -eq 1 ]
	then
		zabbixPWD_SQL1=0
		zabbixPWD_SQL2=1
	
		while [ $zabbixPWD_SQL1 != $zabbixPWD_SQL2 ]
		do
			zabbixPWD_SQL1=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Enter the user's password zabbix to the zabbix Database." --fb 10 60 3>&1 1>&2 2>&3) 
			zabbixPWD_SQL2=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Confirm zabbix user password." --fb 10 50 3>&1 1>&2 2>&3)
		
			if [ $zabbixPWD_SQL1 != $zabbixPWD_SQL2 ]
			then
				whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "
					Error! Informed passwords do not match. Try again.
				" --fb 0 0 0
			fi
		done
	
		# Criando a base de dados zabbix
		erroDescription="Error handling MySQL to Zabbix Database"
		echo "Creating zabbix database..."
		sleep 1

		mysql -u root $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) -e "create database zabbix character set utf8";
		[ $? -ne 0 ] && erroDetect
		
		echo "Creating zabbix user at MariaDB SGBD..."
		sleep 1

		mysql -u root $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) -e "create user 'zabbix'@'localhost' identified by '$zabbixPWD_SQL1'";
		[ $? -ne 0 ] && erroDetect
		
		echo "Making zabbix user the owner to zabbix database..."
		sleep 1

		mysql -u root $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) -e "grant all privileges on zabbix.* to 'zabbix'@'localhost' with grant option";
		[ $? -ne 0 ] && erroDetect
		
		# Configurando /etc/zabbix/zabbix_server.conf
	
		sed -i 's/# DBPassword=/DBPassword='$zabbixPWD_SQL1'/' /etc/zabbix/zabbix_server.conf
		sed -i 's/# FpingLocation=\/usr\/sbin\/fping/FpingLocation=\/usr\/bin\/fping/' /etc/zabbix/zabbix_server.conf
	
		# Avisar que a base está sendo populada....
		# Popular base zabbix
		erroDescription="MySQL population error"
		
		echo "Creating Zabbix Schema at MariaDB..."
		mysql -uroot $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) zabbix < database/mysql/schema.sql
		[ $? -ne 0 ] && erroDetect
		
		echo "Importing zabbix images to MariaDB..."
		mysql -uroot $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) zabbix < database/mysql/images.sql
		[ $? -ne 0 ] && erroDetect
		
		echo "Importing all Zabbix datas to MariaDB..."
		mysql -uroot $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) zabbix < database/mysql/data.sql
		[ $? -ne 0 ] && erroDetect
		sleep 1
		
		zabbixInstallTag=0
	fi
	
		if [ $glpiInstallTag -eq 1 ]
		then
			glpiPWD_SQL1=0
			glpiPWD_SQL2=1
	
			while [ $glpiPWD_SQL1 != $glpiPWD_SQL2 ]
			do
				glpiPWD_SQL1=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Enter the user's password to glpi Database." --fb 10 60 3>&1 1>&2 2>&3) 
				glpiPWD_SQL2=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Confirm password glpi user password..." --fb 10 50 3>&1 1>&2 2>&3)
		
				if [ $glpiPWD_SQL1 != $glpiPWD_SQL2 ]
				then
					whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "
						Error! Informed passwords do not match. Try again.
					" --fb 0 0 0
				fi
			done
	
		# Criando a base de dados glpi
		erroDescription="Error handling MySQL to GLPi Database"
		
		echo "Creating glpi database..."
		sleep 1
		mysql -u root $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) -e "create database glpi character set utf8";
		[ $? -ne 0 ] && erroDetect
		
		echo "Creating glpi user at MariaDB Database..."
		sleep 1
		mysql -u root $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) -e "create user 'glpi'@'localhost' identified by '$glpiPWD_SQL1'";
		[ $? -ne 0 ] && erroDetect
		
		echo "Making glpi user the owner to glpi database..."
		sleep 1
		mysql -u root $(if test $rootPWD_SQL ; then echo "-p$rootPWD_SQL"; fi) -e "grant all privileges on glpi.* to 'glpi'@'localhost' with grant option";
		[ $? -ne 0 ] && erroDetect
		
		$glpiInstallTag=0
	
	fi

}

GLPI_INSTALL ()
{

# Enabling GLPI TAG to On
glpiInstallTag=1

clear 

echo "Exec GLPI Install..."
sleep 3

	# GLPi installation process
	# Downloading GLPI
	cd /tmp
	
	erroDescription="Error to download GLPi"
	wget -qO- $glpiDownloadLink | tar -zxv;
	mv glpi /var/www/html/
	[ $? -ne 0 ] && erroDetect

	# Downloading a lot GLPi Plugins
	erroDescription="Error to download some GLPi plugin"
	
	## GLPi Plugins Links

	# Plugin OS

	# Plugin Dashboard
	glpiPluginDashboard="https://forge.glpi-project.org/attachments/download/2257/GLPI-dashboard_plugin-0.9.4.zip"
	wget -qO- $glpiPluginDashboard | bsdtar -xvf-;
	mv dashboard  $GLPI_PLUGINS_DIR; [ $? -ne 0 ] && erroDetect

	# Plugin Mydashboard
	glpiPluginMydashboard="https://github.com/InfotelGLPI/mydashboard/releases/download/1.6.2/glpi-mydashboard.1.6.2.tar.gz"
	wget -qO- $glpiPluginMydashboard | tar -zxv;
	mv mydashboard $GLPI_PLUGINS_DIR; [ $? -ne 0 ] && erroDetect

	# Apps structure inventory
	glpiPluginAppStructureInventory="https://github.com/ericferon/glpi-archisw/archive/v2.0.12.zip"
	wget -qO- $glpiPluginAppStructureInventory | bsdtar -xvf-;
	mv glpi-archisw-2.0.12 $GLPI_PLUGINS_DIR/archisw; [ $? -ne 0 ] && erroDetect

	# Plugin Form Creator
	glpiPluginFormcreator="https://github.com/pluginsGLPI/formcreator/releases/download/v2.6.5/glpi-formcreator-2.6.5.tar.bz2"
	wget -qO- $glpiPluginFormcreator | tar -jxv; 
	mv formcreator $GLPI_PLUGINS_DIR;

	# Plugin Fusion
	glpiPluginFusionInventory="https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/glpi9.3%2B1.2/fusioninventory-9.3+1.2.tar.gz"
	wget -qO- $glpiPluginFusionInventory | tar -zxv;
	mv fusioninventory $GLPI_PLUGINS_DIR; [ $? -ne 0 ] && erroDetect

	# Plugin Behavior
	glpiPluginBehaviors="https://forge.glpi-project.org/attachments/download/2251/glpi-behaviors-2.1.1.tar.gz"
	wget -qO- $glpiPluginBehaviors | tar -zxv;
	mv behaviors $GLPI_PLUGINS_DIR; [ $? -ne 0 ] && erroDetect

	# Plugin Database Inventory
	glpiPluginDatabasesinventory="https://github.com/InfotelGLPI/databases/releases/download/2.1.1/glpi-databases-2.1.1.tar.gz"
	wget -qO- $glpiPluginDatabasesinventory | tar -zxv;
	mv databases $GLPI_PLUGINS_DIR; [ $? -ne 0 ] && erroDetect

	# Plugin Appliances Inventory
	glpiPluginAppliancesinventory="https://forge.glpi-project.org/attachments/download/2259/glpi-appliances-2.4.1.tar.gz"
	wget -qO- $glpiPluginAppliancesinventory | tar -zxv;
	mv appliances $GLPI_PLUGINS_DIR; [ $? -ne 0 ] && erroDetect

	# Plugin Webapplications Inventory
	glpiPluginWebapplicationsinventory="https://github.com/InfotelGLPI/webapplications/releases/download/2.5.1/glpi-webapplications-2.5.1.tar.gz"
	wget -qO- $glpiPluginWebapplicationsinventory | tar -zxv;
	mv webapplications $GLPI_PLUGINS_DIR; [ $? -ne 0 ] && erroDetect


	chmod 775 /var/www/html/glpi -Rf
	
	case $ID in
		debian)
			
			chown www-data:www-data /var/www/html/glpi -Rf
			echo -e "<Directory \"/var/www/html/glpi\">\n\tAllowOverride All\n</Directory>" > /etc/apache2/conf-available/glpi.conf
			a2enconf glpi.conf
			systemctl reload apache2
			
		;;
		
		centos)
			
			echo -e "<Directory \"/var/www/html/glpi\">\n\tAllowOverride All\n</Directory>" > /etc/httpd/conf.d/glpi.conf
			
			chmod 775 /var/www/html/glpi -Rf
			chown apache:apache /var/www/html/glpi -Rf
			systemctl restart httpd.service
		;;
		
	esac

	# Creating Data Base
	DB_CREATE
}

INTEGRA ()
{

	clear 
	
	cd /tmp
	
	# Install Verdanatech extra SNMP tools
	
	wget http://www.verdanatech.com/scripts/listaPortasSNMP.sh
	mv listaPortasSNMP.sh /bin/
	chmod 775 /bin/listaPortasSNMP.sh

	wget http://www.verdanatech.com/scripts/zbTemplateBuilder.sh
	mv zbTemplateBuilder.sh /bin/
	chmod 775 /bin/zbTemplateBuilder.sh
	
	# Install integraGZ
	
	echo "Detecting externalScripts directory..."
	externalScriptsDir=$(find / -iname externalscripts)
	echo "ok..."
	echo "Detecting frontend directory..."
	zabbixFrontend=$(find / -name zabbix.php | sed 's/zabbix.php//')
	echo "ok..."
	
	echo "Making Systems Integration with Verdanatech iGZ..."
	sleep 1
	
	git clone $verdanatechGIT
	
	chmod 775 igz/*
	
	sed -i 's/ZABBIX_FRONTEND_DIR\//'$(echo $zabbixFrontend | sed 's/\//\\\//g')'/' igz/igz.php
	sed -i 's/ZABBIX_EXTERNALSCRIPT_DIR/'$(echo $externalScriptsDir | sed 's/\//\\\//g')'/' igz/verdanatech_iGZ.php
	
	mv igz/igz.php $externalScriptsDir/
	
	mv igz/verdanatech_iGZ.php $zabbixFrontend/
	
	mv -f igz/verdanatech_iGZ_menu.inc.php $zabbixFrontend/include/menu.inc.php
	
	mv igz/verdanatech_processa_iGZ.php $zabbixFrontend/
	
	touch $zabbixFrontend/conf/igz.conf.php

	chown $apacheUser $zabbixFrontend/conf/igz.conf.php
	
	chmod +x $zabbixFrontend/conf/igz.conf.php
	
	# Avaliar...estava no código mas não encontre o por que!?!
	# mv zabbix-glpi/*zabbix* $externalScriptsDir
	
	chmod 775 $externalScriptsDir -Rf
	
	chown zabbix:zabbix $externalScriptsDir -Rf
	
	# Limpando diretório /tmp
	rm -Rf /tmp/igz

}

MAIN_MENU ()
{
 
	menu01Option=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --menu "Select a option!" --fb 15 50 6 \
	"1" "Verdanatech iGZ (complete installation)" \
	"2" "GLPI and plugins" \
	"3" "Zabbix + Verdanatech iGZ" \
	"4" "Only Verdanatech iGZ" \
	"5" "About" \
	"6" "Exit" 3>&1 1>&2 2>&3)
 
	status=$?

	if [ $status != 0 ]; 
	then
	
		echo "You have selected out. Bye!"
		echo "Verdanatech Solucoes em TI..."
		sleep 2
		exit;

	fi

}

ABOUT ()
{

	clear

	whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "Copyright:\n- Verdanatech Solucoes em TI, $versionDate\nLicence:\n- GPL v3 <http://www.gnu.org/licenses/>\nProject partners:\n- Gustavo Soares <slot.mg@gmail.com>\n- Halexsandro Sales <halexsandro@gmail.com>\n- Janssen Lima <janssenreislima@gmail.com>\n "  --fb 0 0 0
}

INFORMATION () 
{

	whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox " 
		This script aims to perform the installation automated systems:
		- $glpiVersion  [http://glpi-project.com]
		  -- With a lot community plugins
		- $zabbixVersion   [http://zabbix.com]
		  -- zabbix-server-mysql
		  -- zabbix-agent" 
	--fb 0 0 0

}

END_MSG ()
{
	clear
	
	whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "

		Copyright:
		- Verdanatech Solucoes em TI, $versionDate
		Thank you for using our script. We are at your disposal to contact.
		$devMail

		PATHS: 
		If you made installations, try to access 
		GLPI, http://$serverAddress/glpi
		Zabbix, try http://$serverAddress/zabbix
		iGZ conf, zabbix menu Administration > Verdanatech iGZ 

	"  --fb 0 0 0

}

# Script start

# Script init

clear

cd /tmp

echo -e " ------------------------------------------------ _   _   _ \n ----------------------------------------------- / \\ / \\ / \\ \n ---------------------------------------------- ( \033[31mi\033[0m | \033[32mG\033[0m | \033[32mZ\033[0m ) \n ----------------------------------------------- \\_/ \\_/ \\_/ \n| __      __          _                   _            _\n| \\ \\    / /         | |                 | |          | | \n|  \\ \\  / ___ _ __ __| | __ _ _ __   __ _| |_ ___  ___| |__ \n|   \\ \\/ / _ | '__/ _\` |/ _\` | '_ \\ / _\` | __/ _ \\/ __| '_ \\ \n|    \\  |  __| | | (_| | (_| | | | | (_| | ||  __| (__| | | | \n|     \\/ \\___|_|  \\__,_|\\__,_|_| |_|\\__,_|\\__\\___|\\___|_| |_| \n| \n|                    consulting, training and implementation \n|                                  comercial@verdanatech.com \n|                                        www.verdanatech.com \n|                                          \033[1m+55 81 3091 42 52\033[0m \n ------------------------------------------------------------ \n| \033[31mintegraGZ.sh\033[0m  - \033[32m$glpiVersion and a many plugins + $zabbixVersion\033[0m| \n ----------------------------------------------------------- \n"

sleep 5

clear

# Verify whiptail

[ ! -e /usr/bin/whiptail ] && { erroDescription='ERRO! Not found WHIPTAIL PKG'; erroDetect ; }

# Openning Main Menu

MAIN_MENU

while true
do
	case $menu01Option in

		1)
			# instalação completa
			REQ_TO_USE
			SET_REPOS
			LAMP_INSTALL
			ZABBIX_INSTALL
			GLPI_INSTALL
			INTEGRA
			END_MSG
			kill $$
		;;
	
		2)
			# Instala apenas GLPI
			REQ_TO_USE
			SET_REPOS
			LAMP_INSTALL
			GLPI_INSTALL
			END_MSG
			kill $$
		;;	

		3)
			# Zabbix + VerdanatechiGZ
			REQ_TO_USE
			SET_REPOS
			LAMP_INSTALL
			ZABBIX_INSTALL
			INTEGRA
			END_MSG
			kill $$
		;;
	
		4)
			# Apenas iGZ
			INTEGRA
			END_MSG
			kill $$
		;;
	
		5)
			# Sobre
			ABOUT
			MAIN_MENU
		;;
	
		6)
			# Sair
			END_MSG
			kill $$
		;;

	esac

done
