resource "yandex_lb_target_group" "lb-tg" {
  name      = "reddit-target-group"
  region_id = "ru-central1"

  dynamic "target" {
    iterator = reddit_instance_ip
    for_each = yandex_compute_instance.app.*.network_interface.0.ip_address
    content {
      subnet_id = var.subnet_id
      address   = reddit_instance_ip.value
    }
  }

}

resource "yandex_lb_network_load_balancer" "lb" {
  name = "reddit-load-balancer"

  listener {
    name = "reddit-lb-listener"
    port = var.reddit_listener_port
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lb-tg.id

    healthcheck {
      name = "http"
      http_options {
        port = var.reddit_listener_port
        path = "/"
      }
    }
  }
}
