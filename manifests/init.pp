# == Class: oracletasks
#
# Module to manage oracletasks
#
class oracletasks (
  $locked_users_script      = '/home/oracle/.locked_users_query.sql',
  $unlock_users_script      = '/home/oracle/.unlock_users.sql',
  $locked_users             = undef,
  $unlock_oracle_users_cmd  = 'su -l oracle -c \'sqlplus /nolog @/home/oracle/.unlock_users.sql\'',
  $unlock_oracle_users_path = '/bin:/usr/bin',
  $passwords                = undef,
  $passwords_hiera_merge    = true,
  $column_types             = undef,
  $column_types_hiera_merge = true,
) {

  validate_absolute_path($locked_users_script)
  validate_absolute_path($unlock_users_script)

  if type($passwords_hiera_merge) == 'string' {
    $passwords_hiera_merge_real = str2bool($passwords_hiera_merge)
  } else {
    $passwords_hiera_merge_real = $passwords_hiera_merge
  }
  validate_bool($passwords_hiera_merge_real)

  if type($column_types_hiera_merge) == 'string' {
    $column_types_hiera_merge_real = str2bool($column_types_hiera_merge)
  } else {
    $column_types_hiera_merge_real = $column_types_hiera_merge
  }
  validate_bool($column_types_hiera_merge_real)

  file { 'locked_users_script':
    ensure => file,
    path   => $locked_users_script,
    source => 'puppet:///modules/oracletasks/locked_users_query.sql',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  if type($::oracle_locked_users) == 'array' {

    file { 'unlock_users_script':
      ensure  => file,
      path    => $unlock_users_script,
      content => template('oracletasks/unlock_users.sql.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    exec { 'unlock_oracle_users':
      command     => $unlock_oracle_users_cmd,
      refreshonly => true,
      path        => $unlock_oracle_users_path,
      subscribe   => File['unlock_users_script'],
    }
  }

  if $passwords != undef {
    if $passwords_hiera_merge_real == true {
      $passwords_real = hiera_hash('oracletasks::passwords')
    } else {
      $passwords_real = $passwords
    }
    validate_hash($passwords_real)
    create_resources('oracletasks::password',$passwords_real)
  }

  if $column_types != undef {
    if $column_types_hiera_merge_real == true {
      $column_types_real = hiera_hash('oracletasks::column_types')
    } else {
      $column_types_real = $column_types
    }
    validate_hash($column_types_real)
    create_resources('oracletasks::column_type',$column_types_real)
  }
}
