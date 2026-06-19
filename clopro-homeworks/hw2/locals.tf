locals {
  project = "netology"
  env     = "hw15-2"

  sg_lamp_name = "${local.project}-${local.env}-lamp-sg"
  lamp_ig_name = "${local.project}-${local.env}-lamp-ig"
  lamp_tg_name = "${local.project}-${local.env}-lamp-tg"
  nlb_name     = "${local.project}-${local.env}-nlb"

  picture_public_url = "https://storage.yandexcloud.net/${yandex_storage_bucket.pictures.bucket}/${yandex_storage_object.picture.key}"

  nlb_external_ip = one(flatten([
    for listener in yandex_lb_network_load_balancer.lamp.listener : [
      for addr in listener.external_address_spec : addr.address
    ]
  ]))

  lamp_user_data = <<-EOF
    #!/bin/bash
    cat > /var/www/html/index.html <<HTML
    <html>
    <head><title>Netology HW15.2</title></head>
    <body>
    <h1>LAMP Instance Group</h1>
    <p><a href="${local.picture_public_url}">Picture from Object Storage</a></p>
    <img src="${local.picture_public_url}" alt="picture" width="400"/>
    </body>
    </html>
    HTML
    systemctl restart httpd || service httpd restart
    EOF
}
