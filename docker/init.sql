create database if not exists `myapp` default character set = utf8mb4 default collate = utf8mb4_general_ci;

create user if not exists 'homestead'@'localhost' identified by 'secret';
create user if not exists 'homestead'@'%' identified by 'secret';
grant all privileges on `myapp`.* to 'homestead'@'localhost';
grant all privileges on `myapp`.* to 'homestead'@'%';
flush privileges;