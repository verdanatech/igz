<?php
/*
 *  @Programa iGZ
 *	@name: iGZ - verdanatech_processa_iGZ.php
 *	@versao: 0.1
 *	@Data 10 de Fevereiro de 2017
 *	@Copyright: Verdanatech Soluções em TI, 2017
 *  @Author: Halexsandro de Freitas Sales <halexsandro.sales@verdanatech.com>
 * --------------------------------------------------------------------------
 * LICENSE
 *
 * iGZ is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.

 * iGZ is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * If not, see <http://www.gnu.org/licenses/>.
 * --------------------------------------------------------------------------
 */

require_once dirname(__FILE__).'/include/config.inc.php';

if ($_GET["send"] = 1) {

	$glpi_active = $_POST["glpi_active"];
	$glpi_url = $_POST["glpi_url"];
	$app_token = $_POST["app_token"];
	$glpi_user = $_POST["glpi_user"];
	$glpi_user_password = $_POST["glpi_user_password"];
	$telegram_active = $_POST["telegram_active"];
	$telegram_id_user = $_POST["telegram_id_user"];
	$telegram_bot_token = $_POST["telegram_bot_token"];
	$update = $_POST["update"];

	$fp = fopen("./conf/igz.conf.php", "w");
	$grava = fwrite($fp, "<?php
	\$glpi_active=\"".$glpi_active."\";
	\$appToken=\"".$app_token."\";
	\$apiURL=\"".$glpi_url."\";
	\$userLogin=\"".$glpi_user."\";
	\$passwd=\"".$glpi_user_password."\";
	\$telegram_active=\"".$telegram_active."\";
	\$telegramIdUser=\"".$telegram_id_user."\";
	\$telegramBotToken=\"".$telegram_bot_token."\";

		");

	fclose($fp);

}

header('Location:verdanatech_iGZ.php');

