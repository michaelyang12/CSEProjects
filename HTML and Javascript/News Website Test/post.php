<?php
    session_start();

    $title;
    $body;
    $link = "";
    $id = -1;


    //Retrieve post id from url or POST
    if(isset($_POST['id'])) {
        $id=$_POST['id'];
    } else {
        if(isset($_GET['post'])) {
            $id = $_GET['post'];
        } 
    }

    //connect to database with wustl user
    $conn = new mysqli('localhost', 'wustl_inst', 'wustl_pass', 'news_site');

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    //update queries with post edits/creations respectively
    if(isset($_POST['changes'])) {
        if(isset($_POST['title']) && isset($_POST['body'])) {
            $title = $_POST['title'];
            $body = $_POST['body'];
            $link = $_POST['link'];

            $query = 'update posts set title="'.$title.'", bodyText="'.$body.'", link="'.$link.'" WHERE id='.$id;
            $result = mysqli_query($conn, $query);

            
            //Redirect to post
            header("Location: post.php?post=".$id);
        }
    } else {
        if(isset($_POST['title']) && isset($_POST['body'])) {
            $title = $_POST['title'];
            $body = $_POST['body'];
            if(isset($_POST['link'])) {
                $link = $_POST['link'];
            }

            //sanitize external input
            $query = $conn->prepare('INSERT INTO posts (title, bodyText, link, email, userid) VALUES (?, ?, ?, ?, ?)');
            $query->bind_param("ssssi", $title, $body, $link, $_SESSION['user'], $_SESSION['userid']);
            $query->execute();
            
            $query = 'SELECT * FROM posts WHERE title="'.$title.'" AND bodyText="'.$body.'" AND link="'.$link.'" AND email="'.$_SESSION['user'].'"';
            $result = mysqli_query($conn, $query);
            while($row = mysqli_fetch_array($result)) {
                $id = $row['id'];
            }

            header("Location: post.php?post=".$id);
        }
    }
    
    //Send user back if invalid id is given
    if($id == -1) {
        header("Location: index.php");
        die();
    }
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>News</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
    <link rel="stylesheet" href="/news/main.css">

</head>

<!--Navigation bar-->
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light sticky-top">
        <a class="navbar-brand" href="#">News Website</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/news">Home</a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" href="/news/news.php">News</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/news/account.php">Account</a>
                </li>
            </ul>
            <?php
                if(isset($_SESSION["user"])) {
                    echo '<p class="mr-sm-2">Welcome '.$_SESSION["user"].'</p>';
                    echo '<form action="news.php" method="GET" class="form-inline my-2 my-lg-0">';
                    echo '<button class="btn btn-success" type="submit" name="logout" value="logout">Logout</button>';
                    echo '</form>';
                } else {
                    echo '<form action="news.php" method="POST" class="form-inline my-2 my-lg-0">';
                    echo '<input class="form-control mr-sm-2" type="email" placeholder="Email" aria-label="email" name="email-login">';
                    echo '<input class="form-control mr-sm-2" type="password" placeholder="Password" aria-label="password" name="password-login">';
                    echo '<button class="btn btn-success">Login</button>';
                    echo '</form>';
                }
            ?>       
        </div>
    </nav>
    <?php
    echo '<div class="container">';

        //search through posts table
        if(isset($_GET['edit'])) {
            $query = 'SELECT * FROM posts WHERE id="'.$id.'"';
            $result = mysqli_query($conn, $query);
            $posts = array();
            $counter = 0;
            while($row = mysqli_fetch_array($result)) {
                $posts[$counter] = $row;
                $counter++;
            }
            echo '<h1 class="center-text" style="margin-top: 20px">Edit Post</h1>
            <div class="col-sm-12">
                <form action="post.php" method="POST">
                    <div class="form-group">
                        <label for="title">Title</label>
                        <input type="text" name="title" class="form-control" id="title" placeholder="Title" value="'.$posts[0]["title"].'" required>
                    </div>
                    <div class="form-group">
                    <label for="body">Type news here</label>
                        <textarea id="body" class="form-control" name="body" rows="10" required>'.$posts[0]["bodyText"].'</textarea>
                    </div>
                    <div class="form-group">
                        <label for="link">Link</label>
                        <input type="text" name="link" class="form-control" id="link" value="'.$posts[0]["link"].'" placeholder="Link">
                    </div>
                    <input name="id" type="hidden" value="'.$_GET['post'].'"></input>
                    <input name="update" type="hidden" value="update"></input>
                    <button type="submit" class="btn btn-primary" name="changes" value="changed">Change</button>
                </form>
            </div>
        </div>';
        } else {
            $query = 'SELECT * FROM posts WHERE id="'.$id.'"';
            $result = mysqli_query($conn, $query);
            $posts = array();
            $counter = 0;
            while($row = mysqli_fetch_array($result)) {
                $posts[$counter] = $row;
                $counter++;
            }
            for($i = count($posts) -1; $i >= 0; $i--) {
                if(isset($_SESSION['userid'])) {
                    if($posts[$i]['userid'] == $_SESSION['userid']) {
                        //creates post edit with sanitized data from database
                        createCardEdit(
                            mysqli_real_escape_string($conn, $posts[$i]['title']), 
                            mysqli_real_escape_string($conn, $posts[$i]['bodyText']), 
                            mysqli_real_escape_string($conn, $posts[$i]['link']), 
                            mysqli_real_escape_string($conn, $posts[$i]['email']), 
                            mysqli_real_escape_string($conn, $posts[$i]['id'])
                        );
                    } else {
                        //creates post with sanitized data from database
                        createCard(
                            mysqli_real_escape_string($conn, $posts[$i]['title']),
                            mysqli_real_escape_string($conn, $posts[$i]['bodyText'] ),
                            mysqli_real_escape_string($conn, $posts[$i]['link']),
                            mysqli_real_escape_string($conn, $posts[$i]['email']),
                            mysqli_real_escape_string($conn, $posts[$i]['id'])
                        );
                    }
                } else {

                    //creates post with sanitized data from database
                    createCard(
                        mysqli_real_escape_string($conn, $posts[$i]['title']),
                        mysqli_real_escape_string($conn, $posts[$i]['bodyText'] ),
                        mysqli_real_escape_string($conn, $posts[$i]['link']),
                        mysqli_real_escape_string($conn, $posts[$i]['email']),
                        mysqli_real_escape_string($conn, $posts[$i]['id'])
                    );
                }
                
                echo "<h3>Comments</h3>";
            }
            //find where the comment is stored and create card
            $query = 'SELECT * FROM comments WHERE postId="'.$id.'"';
            $result = mysqli_query($conn, $query);
            while($row = mysqli_fetch_array($result)) {
                if(isset($_SESSION['userid'])) {
                    if($row['userId'] == $_SESSION['userid']) {
                        //creates comment edit with sanizited data from database
                        createCommentEdit(
                            mysqli_real_escape_string($conn, $row['comment']), 
                            mysqli_real_escape_string($conn, $_SESSION['user']), 
                            mysqli_real_escape_string($conn, $row['id']), 
                            mysqli_real_escape_string($conn, $row['postId'])
                        );
                    } else {
                        //creates comment with sanizited data from database
                        createComment(
                            mysqli_real_escape_string($conn, $row['comment']),
                            mysqli_real_escape_string($conn, $row['email'])
                        );
                    }
                } else {
                     //creates comment with sanizited data from database
                     createComment(
                        mysqli_real_escape_string($conn, $row['comment']),
                        mysqli_real_escape_string($conn, $row['email'])
                    );
                }
                
            }

            //Creat textarea for comment
            createCommentBox();


        echo '</div>';
        }

    ?>
        


    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>

</body>
</html>


<?php
//Functions for card creation for posts, comments, and edits.
    function createCard($title, $bodyText, $link, $user, $id) {
        echo '<div class="card col-md-12 border-dark mb-3" style="margin-bottom: 20px;">';
        echo '<div class="card-body">';
        echo '<h5 style="display: inline;" class="card-title">'.$title.' - By: '.$user.'</h5>';
        echo '<hr>';
        echo '<p class="card-text">'.$bodyText.'</p>';
        if(isset($link) && $link != "") {
            echo '<hr>';
            echo '<button class="btn"><a href="'.$link.'" style="float: left; margin-right: 20px;" target="_blank" class="card-link">Link</a></button>';
        }
        echo '</div>';
        echo '</div>';
    }

    //Function to create comments
    function createComment($comment, $user) {
        echo '<div class="card col-md-12 border-dark mb-3" style="margin-bottom: 20px;">';
        echo '<div class="card-body">';
        echo '<p class="card-text">'.$user.' - '.$comment.'</p>';
        echo '</div>';
        echo '</div>';
    }

    //Function to create comments with edit button
    function createCommentEdit($comment, $user, $commentId, $postId) {
        echo '<div class="card col-md-12 border-dark mb-3" style="margin-bottom: 20px;">';
        echo '<div class="card-body">';
        echo '<p class="card-text">'.$user.' - '.$comment.'</p>';
        echo '<form action="editComment.php" method="POST">';
        //CSRF Token
        echo '<input type="hidden" name="token" value="'.$_SESSION['token'].'"/>';
        echo '<input type="hidden" name="commentId" value="'.$commentId.'"/>';
        echo '<input type="hidden" name="postId" value="'.$postId.'"/>';
        echo '<button class="btn btn-danger" type="submit">Edit</button>';
        echo '</form>';
        echo '<form action="deleteComment.php" method="POST">';
        //CSRF Token
        echo '<input type="hidden" name="token" value="'.$_SESSION['token'].'"/>';
        echo '<input type="hidden" name="commentId" value="'.$commentId.'"/>';
        echo '<input type="hidden" name="postId" value="'.$postId.'"/>';
        echo '<button class="btn btn-warning" type="submit">Delete</button>';
        echo '</form>';
        echo '</div>';
        echo '</div>';
    }

    //Function to create textarea for new comments
    function createCommentBox() {
        echo '<form action="comment.php" method="POST">';
        echo ' <textarea class="form-control" name="comment" rows="10" placeholder="Write comment here" required></textarea>';
        echo '<button class="btn btn-danger" type="submit">Comment</button>';

        //CSRF Token
        if(isset($_SESSION['userid'])) {
            echo '<input type="hidden" name="token" value="'.$_SESSION['token'].'"/>';
        }
        echo '<input name="postid" type="hidden" value='.$_GET['post'].'>';
        echo '</form>'; 
    }

    //Function to create post with edit button
    function createCardEdit($title, $bodyText, $link, $user, $id) {
        echo '<div class="card col-md-12 border-dark mb-3" style="margin-bottom: 20px;">';
        echo '<div class="card-body">';
        echo '<h5 style="display: inline;" class="card-title">'.$title.' - By: '.$user.'</h5>';
        echo '<hr>';
        echo '<p class="card-text">'.$bodyText.'</p>';
        
        if(isset($link) && $link != "") {
            echo '<hr>';
            echo '<button class="btn"><a href="'.$link.'" style="float: left; margin-right: 20px;" target="_blank" class="card-link">Link</a></button>';
        }
        echo '<form action="post.php" method="GET">';
        echo '<button class="btn btn-danger" type="submit" name="post" value="'.$id.'">Edit</button>';
        echo '<input name="edit" type="hidden" value="true">';
        echo '</form>';
        echo '</div>';
        echo '</div>';
    }
?>