#
# main.tf - Terraform Google App Engine Wordpress Deployment
# 

provider "google" {
  region 	= "${var.region}"
}

data "google_client_config" "current" {}


# generate random password for MySQL user

resource "random_id" "user-password" {
  byte_length = 8
}

# deploy a Cloud SQL instance with MySQL

resource "google_sql_database_instance" "wp-mysql" {
  name             	= "wp-mysql-instance"
  database_version 	= "MYSQL_5_7"
  region           	= "${var.region}"
  project			= "${data.google_client_config.current.project}"
  settings {
    tier 						= "${var.tier}"
	disk_size 					= "${var.disk_size}"
	activation_policy 			= "ALWAYS"
	# authorized_gae_applications = [A list of Google App Engine (GAE) project names that are allowed to access this instance]
	disk_autoresize 			= true
	disk_type 					= "PD_SSD"
	backup_configuration {
		enabled 				= true
		binary_log_enabled 		= true
		start_time 				= "00:00"
	}
	ip_configuration  {
		require_ssl 			= true
		ipv4_enabled 			= true
	}
	location_preference  {
		follow_gae_application 	= true
	}
	maintenance_window  {
		day 					= 7
		hour 					= 0
		update_track 			= "stable"
	}
  }
}


