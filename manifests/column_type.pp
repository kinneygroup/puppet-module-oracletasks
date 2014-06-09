# == Define: column_type
#
define oracletasks::column_type (
  $database,
  $table,
  $column,
  $type,
  $exec_path = '/bin:/usr/bin:/sbin:/usr/sbin',
) {

  validate_string($database)
  validate_string($table)
  validate_string($column)
  validate_string($type)
  validate_string($exec_path)

  $escaped_type = escape_parens($type)

  exec { "column_type - ${name}":
    command => "su - oracle << FIN
                  sqlplus / as sysdba << EOF
                    ALTER TABLE \"${database}\".\"${table}\" MODIFY ${column} ${type};
                  EOF
                FIN",
    unless  => "su - oracle << FIN
                  sqlplus / as sysdba << EOF | grep -E ^[[:blank:]]*${column} | grep ${escaped_type}\$
                    describe \"${database}\".\"${table}\";
                  EOF
                FIN",
    path    => $exec_path,
  }
}
