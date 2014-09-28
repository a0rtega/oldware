<?php
	/* phpot, minimalist web honeypot written in PHP and MySQL */
	/* Licensed under GNU/GPLv3             */
	/* a0rtega                              */
	/*                securitybydefault.com */
	/*
		mysql> describe tries;
		+---------+--------------+------+-----+---------+-------+
		| Field   | Type         | Null | Key | Default | Extra |
		+---------+--------------+------+-----+---------+-------+
		| id      | varchar(50)  | NO   | PRI | NULL    |       |
		| ip      | varchar(50)  | YES  |     | NULL    |       |
		| country | varchar(5)   | YES  |     | NULL    |       |
		| uagent  | varchar(200) | YES  |     | NULL    |       |
		| user    | varchar(200) | YES  |     | NULL    |       |
		| pass    | varchar(200) | YES  |     | NULL    |       |
		| date    | varchar(35)  | YES  |     | NULL    |       |
		| type    | varchar(5)   | YES  |     | NULL    |       |
		+---------+--------------+------+-----+---------+-------+
		8 rows in set (0.00 sec)

		mysql>
	*/
	function conn_db() {
		$db_conn = mysql_connect("127.0.0.1", "user", "password");
		mysql_select_db("php_honeypot", $db_conn);
		return $db_conn;
	}
	function ip_2_country($ip) {
		return file_get_contents("http://api.hostip.info/country.php?ip=" . $ip);
	}
?>
<!doctype html>
<html>
<head>
	<title>Admin control panel</title>
</head>
<body>
	<table align=center>
	<tr>
		<td align=right><font color=#003333>Administration panel login</font></td>
	<tr>
		<td><hr width=500 color=#003399 noshade></td>
	</table>
	<br><br>
	<table align=center>
	<form name=login method=post>
	<tr>
		<td><font color=#003333>User: </font></td>
		<td><input type=text name=user value=root></td>
	<tr>
		<td><font color=#003333>Password: </font></td>
		<td><input type=password name=passwd></td>
	<tr>
		<td align=right colspan=2><input type=submit value=Login></td>
<?php
	if (isset($_POST["user"]) && isset($_POST["passwd"])) {
		sleep(1); /* trolling art */
		if (strpos($_POST["user"], "'") !== false || strpos($_POST["passwd"], "'") !== false) {
			$error = "Query error, bad syntax";
		}
		else {
			$error = "Invalid username or password";
		}
		echo "\t<tr>\n";
		echo "\t\t<td align=center colspan=2><br><font color=#FF0033>" . $error . "</font>\n";
		$country = ip_2_country($_SERVER['REMOTE_ADDR']);
		$db_conn = conn_db();
		mysql_query("insert into tries values ('" . time() . "', '" . mysql_real_escape_string($_SERVER['REMOTE_ADDR']) . "', '" .
			    mysql_real_escape_string($country) . "', '" . mysql_real_escape_string($_SERVER['HTTP_USER_AGENT']) . "', '" .
			    mysql_real_escape_string($_POST["user"]) . "', " . "'" . mysql_real_escape_string($_POST["passwd"]) . "', '" .
			    date("r") . "', 'login');", $db_conn);
		mysql_close($db_conn);
	}
	else {
		sleep(1);
		$country = ip_2_country($_SERVER['REMOTE_ADDR']);
		$db_conn = conn_db();
		mysql_query("insert into tries values ('" . time() . "', '" . mysql_real_escape_string($_SERVER['REMOTE_ADDR']) . "', '" .
			    mysql_real_escape_string($country) . "', '" . mysql_real_escape_string($_SERVER['HTTP_USER_AGENT']) . "', '" .
			    "null', 'null', '" .
			    date("r") . "', 'visit');", $db_conn);
		mysql_close($db_conn);
	}
?>
	</form>
	</table>
</body>
</html>
