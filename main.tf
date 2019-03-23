variable "slack_webhook_uri" {}

variable "flask_app_port" {
  default = 5000
}

variable "grafana_port" {
  default = 3000
}

variable "prometheus_port" {
  default = 9090
}

variable "alertmanager_port" {
  default = 9093
}

variable "grafana_admin_password" {}

#############
# Templates #
#############

data "template_file" "alertmanager_config_template" {
  template = "${path.module}/alertmanager/alertmanager.yml.tpl"

  vars = {
    web_hook_uri = "${var.slack_webhook_uri}"
  }
}

resource "local_file" "alertmanager_config" {
  filename = "${path.module}/alertmanager/alertmanager.yml"
  content  = "${data.template_file.alertmanager_config_template.rendered}"

  provisioner "local-exec" {
    command = "chmod u=rw ${path.module}/alertmanager/alertmanager.yml"
  }
}

################
# Build images #
################

resource "null_resource" "images" {
  triggers = {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "docker build -t flask-monitoring/flask-app -f ${path.module}/flask-app/Dockerfile ${path.module}/flask-app"
  }

  provisioner "local-exec" {
    command = "docker build -t flask-monitoring/prometheus -f ${path.module}/prometheus/Dockerfile ${path.module}/prometheus"
  }

  provisioner "local-exec" {
    command = "docker build -t flask-monitoring/grafana -f ${path.module}/grafana/Dockerfile ${path.module}/grafana"
  }

  provisioner "local-exec" {
    command = "docker build -t flask-monitoring/alertmanager -f ${path.module}/alertmanager/Dockerfile ${path.module}/alertmanager"
  }
}

############
# Networks #
############

resource "docker_network" "prometheus" {
  name = "prom"
}

##############
# Containers #
##############

resource "docker_container" "flask-app" {
  name    = "flask-app"
  image   = "flask-monitoring/flask-app"
  restart = "unless-stopped"

  ports {
    internal = "${var.flask_app_port}"
    external = "${var.flask_app_port}"
  }

  networks_advanced {
    name = "prom"
  }

  depends_on = [
    "null_resource.images",
  ]
}

resource "docker_container" "grafana" {
  name    = "grafana"
  image   = "flask-monitoring/grafana"
  restart = "unless-stopped"

  ports {
    internal = "${var.grafana_port}"
    external = "${var.grafana_port}"
  }

  networks_advanced {
    name = "prom"
  }

  depends_on = [
    "null_resource.images",
  ]

  env = [
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}",
  ]
}

resource "docker_container" "prometheus" {
  name    = "prometheus"
  image   = "flask-monitoring/prometheus"
  restart = "unless-stopped"

  ports {
    internal = "${var.prometheus_port}"
    external = "${var.prometheus_port}"
  }

  networks_advanced {
    name = "prom"
  }

  depends_on = [
    "null_resource.images",
  ]
}

resource "docker_container" "alertmanager" {
  name    = "alertmanager"
  image   = "flask-monitoring/alertmanager"
  restart = "unless-stopped"

  ports {
    internal = "${var.alertmanager_port}"
    external = "${var.alertmanager_port}"
  }

  networks_advanced {
    name = "prom"
  }

  depends_on = [
    "null_resource.images",
  ]
}
