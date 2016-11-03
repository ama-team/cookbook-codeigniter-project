include_recipe 'apt'
include_recipe 'chef_nginx'
include_recipe 'php'

%w{apcu xdebug zip}.each do |extension|
  package "php-#{extension}"
end

php_fpm_pool 'default' do
  listen '/var/run/php-fpm.sock'
  user 'www-data'
  group 'www-data'
end

mysql_service 'default' do
  port '3306'
  bind_address '127.0.0.1'
  initial_root_password 'root'
end