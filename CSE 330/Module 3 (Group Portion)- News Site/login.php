<?php

    session_start();

    //Check to make sure user is already logged in
    if(isset($_SESSION['user'])) {
        header("Location: index.php?error=You are already logged in");
        die();
    }

    //connect to database with wustl user
    $conn = new mysqli('localhost', 'wustl_inst', 'wustl_pass', 'news_site');

    //exit if connection fails
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    //Make sure email is filled out
    if(isset($_POST['email-login'])) {

        //validate email is in correct format
        $email_regex = "/^[\w!#$%&'*+\/=?^_`{|}~-]+@([\w\-]+(?:\.[\w\-]+)+)$/";
	    if(!preg_match($email_regex, $_POST['email-login'], $matches)){
            header("Location: index.php?error=Invalid email format");
            die();
	    }

        //Select all emails from database
        $query = 'SELECT `email` FROM `users`';
        $result = mysqli_query($conn, $query);
        while($row = mysqli_fetch_array($result)) {
            echo $row['email'];

            //Check to see if email given matches any emails in database
            if($row['email'] == $_POST['email-login']) {
                echo $row['email'];
                echo $_POST['email-login'];

                //Check to see if password was given
                if(isset($_POST['password-login'])) {

                    //Hash password
                    $_Password = password_hash($_POST['password-login'], PASSWORD_DEFAULT);

                    //Select hashed password from database
                    $query = 'SELECT * FROM `users` WHERE `email`="'.$row['email'].'"';
                    $resultPassword = mysqli_query($conn, $query);
                    while($rowPassword = mysqli_fetch_array($resultPassword)) {

                        //Securely verifies if hashed password matches up with database hashed password
                        if(password_verify($_POST['password-login'], $rowPassword['password'])) {

                            //Set the session variable at 'user' to equal users email (log them in)
                            $_SESSION['user'] = mysqli_real_escape_string($conn, $row['email']);
                            echo "<p>User is logged in</p>";

                            //Set the session userid variable to user's id
                            $_SESSION['userid'] = $rowPassword['ID'];
                            echo $_SESSION['userid'];

                            //Add token to user's session to prevent CSRF attack
                            $_SESSION['token'] = bin2hex(random_bytes(32));

                            header("Location: news.php");
                            die();
                        } else {
                            //Let user know wrong email / password'
                            header("Location: index.php?error=Wrong username or password");
                            die();
                        }
                    }
                }
            } else {

            }
        }
        //Let user know that email or password does not exist
        header("Location: index.php?error=Wrong username or password");
    }
?>