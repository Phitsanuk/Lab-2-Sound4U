<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s274004/sound4u/php/PHPMailer/src/Exception.php';
require '/home8/crimsonw/public_html/s274004/sound4u/php/PHPMailer/src/PHPMailer.php';
require '/home8/crimsonw/public_html/s274004/sound4u/php/PHPMailer/src/SMTP.php';

include_once("dbconnect.php");

$name = $_POST['user'];
$email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(100000,999999);

$sqlregister = "INSERT INTO tbl_user(name, email, password, otp) VALUES('$name', '$email', '$passha1', '$otp')";
if ($conn->query($sqlregister) === TRUE){
    echo "success";
    sendEmail($otp,$email);
}

else{
    echo "failed";
}

function sendEmail($otp,$email)
    {$mail = new PHPMailer(true);
     $mail->SMTPDebug = 0;                                       //Disable verbose debug output
     $mail->isSMTP();                                            //Send using SMTP
     $mail->Host       = 'mail.crimsonwebs.com';                 //Set the SMTP server to send through
     $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
     $mail->Username   = 'sound4u@crimsonwebs.com';        //SMTP username
     $mail->Password   = 'r78HX0k2-5ZA';                         //SMTP password
     $mail->SMTPSecure = 'tls';         
     $mail->Port       = 587;
    
     $from = "sound4u@crimsonwebs.com";
     $to = $email;
     $subject = "From Sound4U Admin.";
     $message = "<p>Click the following link to verify your account<br><br><a href='https://crimsonwebs.com/s274004/sound4u/php/verify.php?email=".$email."&key=".$otp."'>Click Here to verify your account</a>";
    
     $mail->setFrom($from,"sound4u");
     $mail->addAddress($to);
    
     $mail->isHTML(true);                    //Set email format to HTML
     $mail->Subject = $subject;
     $mail->Body    = $message;
     $mail->send();
    }
?>