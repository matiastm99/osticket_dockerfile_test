# osticket_dockerfile_test
Dockerfile para crear una imagen que corra osTicket


El archivo esta incompleto, le falta la configuracion de la db (probe mil maneras y no pude hacerla andar de forma automatica).


A la db (mariadb/mysql) hay que configurarla de manera manual y luego reiniciar los servicios (apache y maria), dejo las intrucciones:


1. **Creamos la imagen**

   Bajar el dockerfile y tirar un cd a su ubicacion, luego corremos:

   docker build -t *nombre_imagen* .

2. **Levantamos osTicket**

   docker run -itp 8080:80 --name *nombre_container* *nombre_imagen*


   Arranca a correr el container, ahora le mandamos lo siguiente:


   *service mariadb start*

   *mysql_secure_installation*
   

   Ahora simplemente hay que responder...

    *Enter current password for root (enter for none): mandamos enter*
   
    *Switch to unix_socket authentication [Y/n] n*
   
    *Change the root password? [Y/n] y*
   
    *Remove anonymous users? [Y/n] y*
   
    *Disallow root login remotely? [Y/n] y*
   
    *Remove test database and access to it? [Y/n] y*
   
    *Reload privilege tables now? [Y/n] y*


3. **Ahora creamos la db**

   mysql -u root -p
   
   create database *nombre_db*;
   
   exit;
   
   OPCIONAL:

   podemos crear un nuevo usuario para administrar la db o simplemente utilizar root
   
   create user '*nombre_usuario*'@'localhost' identified by 'una_buena_password';
   
   grant all privileges on *nombre_db*.* to *nombre_usuario*@localhost identified by "una_buena_password";
   
   exit;


5. **Para finalizar**

   *service mariadb restart && service apache2 restart*


Nos metemos en *http://localhost:8080* y con eso deberia andar
   
6. **EXTRA**

   En el archivo */etc/apache2/sites-available/osticket.conf* si cambiamos la linea *ServerName localhost* a *ServerName ip_de_tu_compu* queda un lindo sistema de tickets en tu red local. En ese caso se accede: *ip_elegida:8080*


Yo subi un par de tickets desde el celu!
   
