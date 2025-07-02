CREATE DATABASE CortaFila
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE CortaFila;

CREATE TABLE roles(
  role_id    TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  role_name  VARCHAR(20)        NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE appointment_status(
  status_id   TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  status_desc VARCHAR(30)       NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE users(
  user_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  role_id       TINYINT UNSIGNED NOT NULL,
  name     		VARCHAR(100)      NOT NULL,
  phone         VARCHAR(20)       NOT NULL UNIQUE,
  email 		VARCHAR(150) 	  UNIQUE,
  password_hash CHAR(60)          NOT NULL,
  is_active     TINYINT(1)        NOT NULL DEFAULT 1,
  created_at    DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY(role_id) REFERENCES roles(role_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE user_tokens (
  token CHAR(32) PRIMARY KEY,   -- 32 hex chars
  user_id INT     NOT NULL,
  expires_at DATETIME NOT NULL,
  INDEX(user_id)
);

CREATE TABLE barber_profiles(
  profile_id INT UNSIGNED PRIMARY KEY,
  bio        TEXT,
  photo_url  VARCHAR(255),
  FOREIGN KEY(profile_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE services(
  service_id    SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  service_name  VARCHAR(100)      NOT NULL,
  description   TEXT,
  duration_mins SMALLINT UNSIGNED NOT NULL,
  price         DECIMAL(10,2)     UNSIGNED NOT NULL,
  is_active     TINYINT(1)        NOT NULL DEFAULT 1,
  created_at    DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE barber_services(
  barber_id  INT UNSIGNED      NOT NULL,
  service_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY(barber_id,service_id),
  FOREIGN KEY(barber_id) REFERENCES barber_profiles(profile_id) ON DELETE CASCADE,
  FOREIGN KEY(service_id) REFERENCES services(service_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE availabilities(
  availability_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  barber_id       INT UNSIGNED      NOT NULL,
  weekday         TINYINT UNSIGNED  NOT NULL,
  start_time      TIME              NOT NULL,
  end_time        TIME              NOT NULL CHECK(end_time>start_time),
  FOREIGN KEY(barber_id) REFERENCES barber_profiles(profile_id) ON DELETE CASCADE,
  INDEX(barber_id,weekday)
) ENGINE=InnoDB;

CREATE TABLE appointments(
  appointment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  client_id      INT UNSIGNED      NOT NULL,
  barber_id      INT UNSIGNED      NOT NULL,
  service_id     SMALLINT UNSIGNED NOT NULL,
  status_id      TINYINT UNSIGNED  NOT NULL DEFAULT 1,
  start_datetime DATETIME          NOT NULL,
  end_datetime   DATETIME          NOT NULL CHECK(end_datetime>start_datetime),
  created_at     DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY(client_id)  REFERENCES users(user_id)           ON DELETE RESTRICT,
  FOREIGN KEY(barber_id)  REFERENCES barber_profiles(profile_id) ON DELETE RESTRICT,
  FOREIGN KEY(service_id) REFERENCES services(service_id)     ON DELETE RESTRICT,
  FOREIGN KEY(status_id)  REFERENCES appointment_status(status_id) ON DELETE RESTRICT,
  INDEX(start_datetime,end_datetime),
  INDEX(barber_id,start_datetime)
) ENGINE=InnoDB;

CREATE TABLE payments(
  payment_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT UNSIGNED      NOT NULL,
  amount_paid    DECIMAL(10,2)     UNSIGNED NOT NULL CHECK(amount_paid>=0),
  method         ENUM('card','cash','pix') NOT NULL,
  paid_at        DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE
) ENGINE=InnoDB;