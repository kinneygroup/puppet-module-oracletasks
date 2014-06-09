# == Define: oracletasks::password
#
define oracletasks::password (
  $password,
  $hashed_password,
  $user      = $name,
  $exec_path = '/bin:/usr/bin:/sbin:/usr/sbin',
) {

  exec { "set oracle password for ${user}":
    command => "su - oracle << FIN
                  sqlplus / as sysdba << EOF
                    ALTER USER ${user} IDENTIFIED by \"${password}\";
                    exit
                  EOF
                FIN",
    unless  => "su - oracle << FIN
                  sqlplus / as sysdba << EOF | grep ^${user}\$
                    SET LINESIZE 100;
                    SET PAGESIZE 50;
                    select name from sys.user$ where password='${hashed_password}';
                    exit;
                  EOF
                FIN",
    path    => $exec_path,
  }
}
