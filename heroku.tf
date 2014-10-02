variable "email" {}
variable "api_key" {}
variable "heroku_app_name" {
    default = "kii-heroku-app"
}
variable "kii_app_id" {}
variable "kii_app_key" {}
variable "kii_endpoint" {}

provider "heroku" {
    email = "${var.email}"
    api_key = "${var.api_key}"
}

resource "heroku_app" "default" {
    name = "${var.heroku_app_name}"
    stack = "cedar"
    region = "us"
    config_vars {
        KII_APP_ID="${var.kii_app_id}"
        KII_APP_KEY="${var.kii_app_key}"
        KII_ENDPOINT="${var.kii_endpoint}"
    }
}

output "heroku_app.default.git_url" {
    value = "${heroku_app.default.git_url}"
}

output "heroku_app.default.name" {
    value = "${heroku_app.default.name}"
}
