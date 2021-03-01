<?php
    session_start();

    //Check to make sure token matches to prevent CSRF attack
    if(!hash_equals($_SESSION['token'], $_POST['token'])){
        echo "no token";
        die("Request forgery detected");
    }
    
    //connect to database with wustl user
    $conn = new mysqli('localhost', 'wustl_inst', 'wustl_pass', 'news_site');

    if ($conn->connect_error) {
        echo "connection failed";
        die("Connection failed: " . $conn->connect_error);
    }
    
    //Change firstname in database if one was given
    if(isset($_POST['firstName']) && $_POST['firstName'] != "") {

        //validate name is in correct format
        $name_regex = "/^[a-zA-Z-']*$/";
	    if(!preg_match($name_regex, $_POST['firstName'], $matches)){
            header("Location: account.php?error=Invalid name format");
            die();
	    }
        
        //update with sanitized data
        $query = $conn->prepare('UPDATE users SET firstName=? WHERE email=?');
        $query->bind_param("ss", $_POST['firstName'], $_SESSION['user']);
        $query->execute();
       
    }

    //Change lastname in database if one was given
    if(isset($_POST['lastName']) && $_POST['lastName'] != "") {

        //validate name is in correct format
        $name_regex = "/^[a-zA-Z-']*$/";
	    if(!preg_match($name_regex, $_POST['lastName'], $matches)){
            header("Location: account.php?error=Invalid name format");
            die();
	    }

        //update with sanizited data
        $query = $conn->prepare('UPDATE users SET lastName=? WHERE email=?');
        $query->bind_param("ss", $_POST['lastName'], $_SESSION['user']);
        $query->execute();
    }

    //Change birthday in database if one was given
    if(isset($_POST['birthday'])) {

        //update with sanizited data
        $query = $conn->prepare('UPDATE users SET birthday=? WHERE email=?');
        $query->bind_param("ss", $_POST['birthday'], $_SESSION['user']);
        $query->execute();
    }

    //Change email in database if one was given
    if(isset($_POST['email']) && $_POST['email'] != "") {

        //validate email is in correct format
        $email_regex = "/^[\w!#$%&'*+\/=?^_`{|}~-]+@([\w\-]+(?:\.[\w\-]+)+)$/";
	    if(!preg_match($email_regex, $_POST['email'], $matches)) {
            header("Location: account.php?error=Invalid email format");
            die();
        }
        
        $query = 'SELECT `email` FROM `users`';
        $result = mysqli_query($conn, $query);

        //Make sure email does not already exist
        while($row = mysqli_fetch_array($result)) {
            if($row['email'] == $_POST['email']) {
                echo "email already exists";
                header("Location: account.php?error=email already exists");
                die();
            }
        }    

        //update with sanitized data
        $query = $conn->prepare('UPDATE users SET email=? WHERE email=?');
        $query->bind_param("ss", $_POST['email'], $_SESSION['user']);
        $query->execute();

        //Update user's session to new email
        $_SESSION['user'] = $_POST['email'];
    }

    //Send user back to account page
    header("Location: account.php?success=SUCCESS: Your account has been updated!");
?>
