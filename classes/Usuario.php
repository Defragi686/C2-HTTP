<?php

    Class Usuario
    {
        private $sql;
        public $msgError = "";
        public function conectar($banco, $nome, $host, $usuario, $senha){
        
            global $sql;
            try {
                $sql = new PDO($banco.":dbname=".$nome.";host=".$host,$usuario,$senha);
            } catch (PDOException $e) {
                $msgError = $e->getMessage();
            }
            
        }

        public function logar($email, $senha){
            global $sql;
            
            $pdo = $sql->prepare("SELECT id FROM usuarios WHERE senha=:s AND email=:e");
            $pdo->BindValue(":e",$email);
            $pdo->BindValue(":s",$senha);
            $pdo->execute();
            if($pdo->rowCount() > 0){
                $dado = $pdo->fetch();
                session_start();
                $_SESSION['id'] = $dado['id'];
                $_SESSION['email'] = $dado['email'];
                return true;
            }else
            {
                echo $pdo->rowCount();
                return false; //Nao foi possivel logar
            }
        }
        /*Costumize sua busca!*/

    }

?>