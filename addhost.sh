read -p "input domain:" domain
echo "server {
  listen  80;
  server_name $domain;
  root   /www/$domain/;
  location / {
   index index.html index.htm index.php;
   autoindex off;
  }
  location ~ \.php(.*)$ {
   root   /www/$domain/;
   fastcgi_pass phpfpm:9000;
   fastcgi_index index.php;
   fastcgi_split_path_info ^((?U).+\.php)(/?.+)$;
   fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
   fastcgi_param PATH_INFO \$fastcgi_path_info;
   fastcgi_param PATH_TRANSLATED \$document_root\$fastcgi_path_info;
   include  fastcgi_params;
  }
}
" >> $PWD/nginx/conf.d/default.conf
