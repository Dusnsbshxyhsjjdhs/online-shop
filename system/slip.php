<?php
error_reporting(1);

require_once './a_func.php';

function slip_check($qrcode)
{
    $curl = curl_init();

    curl_setopt_array($curl, array(
         CURLOPT_URL => 'https://noodle.hwud.xyz/api/v1/slip',
         CURLOPT_RETURNTRANSFER => true,
         CURLOPT_ENCODING => '',
         CURLOPT_MAXREDIRS => 10,
         CURLOPT_TIMEOUT => 0,
         CURLOPT_FOLLOWLOCATION => true,
         CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
         CURLOPT_CUSTOMREQUEST => 'POST',
         CURLOPT_POSTFIELDS => json_encode(['qrCode' => $qrcode]),
         CURLOPT_HTTPHEADER => array(
              'Content-Type: application/json',
              'Authorization: Bearer XXXXXXXX'
         ),
    ));

    $response = curl_exec($curl);

    curl_close($curl);
    $p = json_decode($response, true);
    
    return json_decode($response);
}

function dd_return($status, $message)
{
    $response = [
        'status' => $status ? 'success' : 'fail',
        'message' => $message,
    ];

    http_response_code($status ? 200 : 500);
    die(json_encode($response));
}

function processTopup($codeqr, $plr)
{
    $sc = slip_check($codeqr);
    
    if ($sc->status == 200) {
        $info = $sc->data;
        $amount = $info->amount;

        $full_name = $config_bank['bnum'];
        $recv_name = $info->receiver_data->accountNumber;

        
       if (strpos($recv_name, $full_name) !== false) {
            $ref =  $info->transRef;
            $q1 = dd_q("SELECT * FROM kbank_trans WHERE ref = ?", [$ref]);
            
            if ($q1->rowCount() < 1) {
                $senderName = $info->sender_data->senderName;
                
                $ha = dd_q(
                    "INSERT INTO `topup_his` (`id`, `link`, `amount`, `date`, `uid`, `uname`) VALUES (NULL, ? ,  ? , NOW() , ? , ? )",
                    [
                        "สลิปบัญชีชื่อ : " . $senderName,
                        $amount,
                        $_SESSION['id'],
                        $plr['username']
                    ]
                );
                
                $insert_ref = dd_q("INSERT INTO `kbank_trans`(`id`,`ref`, `sender`,`date`) VALUES(0,?,?,0)", [$ref, $senderName]);
                
                $update_user = dd_q("UPDATE users SET point = ? WHERE id = ?", [$plr['point'] + $amount, $_SESSION['id']]);
                
                if ($ha && $update_user) {
                    dd_return(true, "คุณเติมเงินสำเร็จจำนวน " . $amount . " บาท");
                } else {
                    dd_return(false, "SQL ผิดพลาด");
                }
            } else {
                dd_return(false, "สลิปนี้ใช้แล้ว");
            }
        } else {
            dd_return(false, "หมายเลขบัญชีหรือธนาคารไม่ตรงกลับทางร้าน");
        }
    } else {
        dd_return(false, "Qr code ไม่ถูกต้อง : " . $sc->message);
    }
}

$config_bank = dd_q("SELECT * FROM bank")->fetch(PDO::FETCH_ASSOC);

header('Content-Type: application/json; charset=utf-8;');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_SESSION['id'])) {
        $plr = dd_q("SELECT * FROM users WHERE id = ?", [$_SESSION['id']])->fetch(PDO::FETCH_ASSOC);
        if ($_POST['qrcode'] != '') {
            $codeqr = $_POST['qrcode'];

            processTopup($codeqr, $plr);
        } else {
            dd_return(false, "กรุณาส่งข้อมูลให้ครบ");
        }
    } else {
        dd_return(false, "เข้าสู่ระบบก่อนดำเนินการ");
    }
} else {
    dd_return(false, "Method '{$_SERVER['REQUEST_METHOD']}' not allowed!");
}
?>
