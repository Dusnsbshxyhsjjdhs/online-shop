<?php
class yosiket
{
  public function slip_check($qrcode)
  {
    <?php
class yosiket
{
  public function slip_check($qrcode)
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
     CURLOPT_POSTFIELDS =>'{
    "qrCode" : array('payload' => $qrcode)
}',
     CURLOPT_HTTPHEADER => array(
          'Content-Type: application/json',
          'Authorization: Bearer M4e5WQgLlp6Sxb8pChAgpYKinVnnW3FgDtCO5IWkgToKRy8bh0'
     ),
));

$response = curl_exec($curl);

curl_close($curl);
    return $response;
  }
}

