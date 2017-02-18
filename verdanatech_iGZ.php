<?php
/*
 *  @Programa iGZ
 *	@name: iGZ - verdanatech_iGZ.php
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

include './conf/igz.conf.php';
require_once dirname(__FILE__).'/include/config.inc.php';

$page['title'] = _('Verdanatech iGZ');
$page['file'] = 'verdanatech_iGZ.php';

require_once dirname(__FILE__).'/include/page_header.php';

$themes = array_keys(Z::getThemes());

/*
 * Display
 */
$config = select_config();
?>

<div class="header-title table">
	<div class="cell">
		<h1>Verdanatech iGZ</h1>
	</div>
</div>
<form method="post" action="verdanatech_processa_iGZ.php?send=1" accept-charset="utf-8">
	<div id="tabs" class="table-forms-container">
		<div id="igz">
			<ul class="table-forms">
			 <li>
			 	<div class="table-forms-td-left">
			 		<label for="event_ack_enable">Ativar integração GLPI</label>
			 	</div>
			 	<div class="table-forms-td-right">
			 		<input type="checkbox" id="glpi_active" name="glpi_active" value="1" <?php echo ($glpi_active == "1" ? "checked": "");?>>
			 		sim
			 	</div>
			 </li>
			 <li>
			 	<div class="table-forms-td-left">
			 		<label for="event_expire">GLPI API URL</label>
			 	</div>
			 	<div class="table-forms-td-right">
			 		<input type="text" id="glpi_url" name="glpi_url" maxlength="255" value="<?php echo $apiURL?>" style="width: 265px;">
			 	</div>
			 </li>
			 <li>
			 	<div class="table-forms-td-left">
			 		<label for="event_expire">APP token</label>
			 	</div>
			 	<div class="table-forms-td-right">
			 		<input type="text" id="app_token" name="app_token" maxlength="255" value="<?php echo $appToken;?>" style="width: 265px;">
			 	</div>
			 </li>
			 <li>
			 	<div class="table-forms-td-left">
			 		<label for="event_expire">Usuário GLPI</label>
			 	</div>
			 	<div class="table-forms-td-right">
			 		<input type="text" id="glpi_user" name="glpi_user" maxlength="255" value="<?php echo $userLogin?>" style="width: 75px;">
			 	</div>
			 </li>
			 <li>
			 	<div class="table-forms-td-left">
			 		<label for="event_show_max">Senha usuário</label>
			 	</div>
			 	<div class="table-forms-td-right">
			 		<input type="password" id="glpi_user_password" name="glpi_user_password" maxlength="255" value="<?php echo $passwd?>" style="width: 75px;">
			 	</div>
			 </li>
			 <hr>
				<li>
					<div class="table-forms-td-left">
						<label for="dropdown_first_entry">Ativar Telegram</label>
					</div>
					<div class="table-forms-td-right">
					
							<div class="form-input-margin"></div>
							<label for="dropdown_first_remember">
								<input type="checkbox" id="telegram_active" name="telegram_active" value="1" <?php echo ($telegram_active == "1" ? "checked": "");?>>
									sim
							</label>
					</div>
				</li>
				<li>
					<div class="table-forms-td-left">
						<label for="search_limit">Telegram id user</label>
					</div>
					<div class="table-forms-td-right">
						<input type="text" id="telegram_id_user" name="telegram_id_user" maxlength="255" value="<?php echo $telegramIdUser?>" style="width: 80px;">
					</div>
			 </li>
			 <li>
			 	<div class="table-forms-td-left">
			 		<label for="max_in_table">Telegram bot token</label>
			 	</div>
			 	<div class="table-forms-td-right">
			 		<input type="text" id="telegram_bot_token" name="telegram_bot_token" maxlength="255" value="<?php echo $telegramBotToken ?>" style="width: 320px;">
			 	</div>
			 </li>
		</ul>
	</div>
	<ul class="table-forms">
	<li>
		<div class="table-forms-td-left"></div>
		<div class="table-forms-td-right tfoot-buttons">
			<button type="submit" id="update" name="update" value="Update">Update</button>
		</div>
	</li>
</ul>
</div>
</form>
	<div class="msg-good">
		<div class="msg-details">
			<ul>
				<li>
					IMPORTANTE: <BR>
					Lembre-se de criar a ACTION com o comando a seguir: <BR>
					php /usr/lib/zabbix/externalscripts/igz.php  hostName="{HOST.NAME}" ipAddress="{HOST.IP}" zabbixDate="{DATE}" triggerId="{TRIGGER.ID}" triggerName="{TRIGGER.NAME}" state="{TRIGGER.STATUS}" zabbixEventId="{EVENT.ID}" severity="{TRIGGER.SEVERITY}" triggerDescription="{TRIGGER.DESCRIPTION}" triggerURL="{TRIGGER.URL}"	
				</li>
			</ul>
		</div>
		<button type="button" class="overlay-close-btn" onclick="jQuery(this).closest('.msg-bad').remove();" title="Close"></button>
	</div>
</div>
<?php 
require_once dirname(__FILE__).'/include/page_footer.php';
