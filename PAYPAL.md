# PayPal Setup

1. Create a sandbox account;

2. Log in at http://www.sandbox.paypal.com with the account;

3. Click Profile (the main link, not any of subitems);

4. Under "More selling tools", click "Encrypted payment settings";

5. Under "Your Public Certificates", click "Add";

6. Go to the command line and create your key (in case you don't have one) under the `certs/` dir:

    `openssl genrsa -out iheartpsychics_dev_key.pem 1024`

7. From the key, create a certificate:

    `openssl req -new -key iheartpsychics_dev_key.pem -x509 -days 365 -out iheartpsychics_dev_cert.pem`

8. Upload the iheartpsychics_dev_cert.pem file created on step 7;

9. Take note on the Cert ID as you'll need to replace it on the config file;

# PayPal IPN callback

    {
                      "mc_gross" => "50.00",
                       "invoice" => "10",
        "protection_eligibility" => "Ineligible",
                      "payer_id" => "MQ4LVXEPWQN2J",
                           "tax" => "0.00",
                  "payment_date" => "18:08:07 Oct 17, 2013 PDT",
                "payment_status" => "Completed",
                       "charset" => "windows-1252",
                    "first_name" => "Felipe",
                        "mc_fee" => "1.75",
                "notify_version" => "3.7",
                        "custom" => "10",
                  "payer_status" => "verified",
                      "business" => "felipe.coury-facilitator@gmail.com",
                      "quantity" => "1",
                   "verify_sign" => "An5ns1Kso7MWUdW4ErQKJJJ4qi4-A6aiL0f6-lxJyGaQahD5s6OA1FbG",
                   "payer_email" => "felipecoury+iheart@gmail.com",
                        "txn_id" => "1XT43486JF537453V",
                  "payment_type" => "instant",
           "payer_business_name" => "Felipe Coury's Test Store",
                     "last_name" => "Coury",
                "receiver_email" => "felipe.coury-facilitator@gmail.com",
                   "payment_fee" => "1.75",
                   "receiver_id" => "5VJRATN8BDR8E",
                      "txn_type" => "web_accept",
                     "item_name" => "$55",
                   "mc_currency" => "USD",
                   "item_number" => "",
             "residence_country" => "US",
                      "test_ipn" => "1",
               "handling_amount" => "0.00",
           "transaction_subject" => "10",
                 "payment_gross" => "50.00",
                      "shipping" => "0.00",
                  "ipn_track_id" => "3bf5d613949cb",
                    "controller" => "paypal",
                        "action" => "callback"
    }

# PayPal success redirect

    {
                      "mc_gross" => "30.00",
                       "invoice" => "12",
        "protection_eligibility" => "Ineligible",
                      "payer_id" => "MQ4LVXEPWQN2J",
                           "tax" => "0.00",
                  "payment_date" => "18:12:22 Oct 17, 2013 PDT",
                "payment_status" => "Completed",
                       "charset" => "UTF-8",
                    "first_name" => "Felipe",
                        "mc_fee" => "1.17",
                "notify_version" => "3.7",
                        "custom" => "12",
                  "payer_status" => "verified",
                      "business" => "felipe.coury-facilitator@gmail.com",
                      "quantity" => "1",
                   "payer_email" => "felipecoury+iheart@gmail.com",
                   "verify_sign" => "AFcWxV21C7fd0v3bYYYRCpSSRl31AchVhxWFQuEht8t8h7PW8-j49bUC",
                        "txn_id" => "8T906783HP520340W",
                  "payment_type" => "instant",
           "payer_business_name" => "Felipe Coury's Test Store",
                     "last_name" => "Coury",
                "receiver_email" => "felipe.coury-facilitator@gmail.com",
                   "payment_fee" => "1.17",
                   "receiver_id" => "5VJRATN8BDR8E",
                      "txn_type" => "web_accept",
                     "item_name" => "$32",
                   "mc_currency" => "USD",
                   "item_number" => "",
             "residence_country" => "US",
                      "test_ipn" => "1",
               "handling_amount" => "0.00",
           "transaction_subject" => "12",
                 "payment_gross" => "30.00",
                      "shipping" => "0.00",
                          "auth" => "AOZgGM5.Xjg6lIx4x46OGUzGCuBkcTGnRDMJfF9xrpYCfOk885Ov2MXw9d4Kin.CB38PAFdm6yV0ox8QeOPwNiA",
                    "controller" => "paypal",
                        "action" => "success"
    }
