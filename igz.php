<?php
/*
 *  @Programa 
 *	@name: iGZ
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

/*
 * Abrindo uma sessão:
 * é necessário criar um Token para a aplicação, de forma que possa ser utiliza aqui.
 * app_token é gerada em "Menu principal > Configurar > Geral > API"
 * API_URL é definida de acordo com o caminho do sistema
 * 
 */

include 'ZABBIX_FRONTEND_DIR/conf/igz.conf.php';

if ($glpi_active == 1){
	
	$passwd=base64_encode($userLogin.":".$passwd);
	
	/*
	 * Iniciando a sessão com php-curl
	 */
	
	$url=$apiURL . "/initSession";
	
	$ch=curl_init($url);
	
	/*
	 * Passando parâmetros extras para a conexão com o servidor (vide documentação da API do GLPI)
	 */
	
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, TRUE);
	
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			'Content-Type: application/json',
			'Authorization: Basic ' . $passwd,
			'App-Token:' . $appToken));
	
	/*
	 * Forçando o returno da curl em uma string
	 */
	
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	
	/*
	 * Baixando session token id e colocando-a em uma variavel
	 */
	
	$sessionToken = curl_exec($ch);
	$sessionToken = json_decode($sessionToken);
	$sessionToken = $sessionToken->session_token;
	
	/*
	 * Tratamento de variáveis zabbix para a abertura de chamado 
	 */
	
	 /*
	  * Convertendo parâmetros da linha de comandos em variáveis
	  */
	
	 for ($i=1; $i < $argc; $i++) {
	 	parse_str($argv[$i]);
	 }
	 
	/*
	 * Formatando chamado
	 */ 
	
	 /*
	  * Tratanto severidade do evento
	  */
	
	 switch ($severity)	{
		case "Not classified":
			$severity = 1;
		break;
		case "Information":
			$severity = 2;
		break;
		case "Warning":
			$severity = 3;
		break;
		case "Average":
			$severity = 4;
		break;
		case "High":
			$severity = 5;
		break;
		case "Disaster":
			$severity = 6;
		break;
		default:
			$severity = 4;
	 }
	 
	/*
	 * Abrindo chamado no GLPI
	 */
	
	$post = array(
			input => array(
	//				'entities_id'			=> '0',
					'name'					=> "[Verdanatech iGZ] - Ocorrência em " . $hostName,
					'content'				=> "Foi detectado pelo sistema de monitoramento, um problema de ". $triggerName . 
											   " em " . $hostName . "\nO número desta trigger no Zabbix é " . $triggerId . 
											   " e sua severidade é " . $severity . 
											   "\nA URL para consulta desta trigger é " . $triggerURL,
					'status'				=> '1',
					'priority'				=> $severity
	));
	
	$postEncode = json_encode($post);
	
	$urlTicket=$apiURL . "/Ticket/";
	
	$ch=curl_init($urlTicket);
	
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
	curl_setopt($ch, CURLOPT_POSTFIELDS, $postEncode);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			'Content-Type: application/json',
			'Session-Token:' . $sessionToken,
			'App-Token:' . $appToken,
			'Content-Length: ' . strlen($postEncode)
			
	));
	
	curl_setopt($cURL, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	
	$ticket = curl_exec($ch);
	
	/*
	 * Encerrando conexão curl
	 */
	
	curl_close($ch);
}

if ($telegram_active == 1) {
	
	$mensagem = "[Verdanatech iGZ] - Ocorrência em " .$hostName . 
				" Foi detectado pelo sistema de monitoramento, um problema de " . 
				$triggerName . " em " . $hostName. "O número desta trigger no Zabbix é " .
				$triggerId . " e sua severidade é $severity. A prioridade deste evento é $severity";
	
	$url="https://api.telegram.org/bot".$telegramBotToken."/sendMessage?chat_id=".$telegramIdUser."&text=".$mensagem;
	
	$ch=curl_init($url);
	$telegramMessage=curl_exec($ch);
	curl_close($ch);
}

?>
