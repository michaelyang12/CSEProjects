<?php

    session_start();

    //Send user back to homepage if already logged in
    if(isset($_SESSION['user'])) {
        header("Location: index.php");
        die();
    }

    $email = $_POST['email-register'];
    $password = $_POST['password-register'];
    $passwordConfirm = $_POST['password-register-confirm'];

    //validate email is in correct format
    $email_regex = "/^[\w!#$%&'*+\/=?^_`{|}~-]+@([\w\-]+(?:\.[\w\-]+)+)$/";
	if(!preg_match($email_regex, $email, $matches)){
        header("Location: index.php?error=Invalid email format");
        die();
	}

    //Send user back to homepage with error if passwords do not match
    if($password != $passwordConfirm) {
        header("Location: index.php?error=passwords do not match");
        die();
    }

    //Connect to database
    $conn = new mysqli('localhost', 'wustl_inst', 'wustl_pass', 'news_site');

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    //Check to see if email already exists
    $query = 'SELECT `email` FROM `users`';
    $result = mysqli_query($conn, $query);
    while($row = mysqli_fetch_array($result)) {
        if(mysqli_real_escape_string($conn, $row['email']) == $email) {
            
            //Send user back to homepage with error if email already exists
            header("Location: index.php?error=email already exists");
            die();
        }
    }

    //Insert sanitized email and hashed password into database
    $query = $conn->prepare('INSERT INTO users (email, password) values (?, ?)');
    $query->bind_param("ss", $email, password_hash($password, PASSWORD_DEFAULT));
    $query->execute();

    //Select hashed password from database
    $query = 'SELECT * FROM `users` WHERE `email`="'.$email.'"';
    $result = mysqli_query($conn, $query);
    while($row = mysqli_fetch_array($result)) {

        //Log user in and send them to news page
        $_SESSION['user'] = $email;
        
        //Set the session userid variable to user's id
        $_SESSION['userid'] = $row['ID'];

        //Add token to user's session to prevent CSRF attack
        $_SESSION['token'] = bin2hex(random_bytes(32));
    }
        header("Location: news.php");

?>