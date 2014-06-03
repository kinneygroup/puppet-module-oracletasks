# puppet-module-oracletasks
===

[![Build Status](https://travis-ci.org/kinneygroup/puppet-module-oracletasks.png?branch=master)](https://travis-ci.org/kinneygroup/puppet-module-oracletasks)

Puppet module to manage tasks related to Oracle.

This module needs two puppet runs. The first ensures the locked_users_script,
which is needed by the oracle_locked_users fact. One the second run, the fact
should be populated with data that is needed to write to the
unlock_users_script. Note that this module needs stringify_facts setting in
puppet set to false so that we can have structured facts.

===

# Compatibility
---------------
This module is built for use with Puppet v3 with Ruby versions 1.8.7, 1.9.3, and 2.0.0 on the following OS families.

* EL 5

===

# Parameters
------------

locked_users_script
-------------------

- *Default*: '/home/oracle/.locked_users_query.sql',

unlock_users_script
-------------------

- *Default*: '/home/oracle/.unlock_users.sql',

locked_users
------------

- *Default*: undef,

unlock_oracle_users_cmd
-----------------------

- *Default*: `su -l oracle -c 'sqlplus /nolog @/home/oracle/.unlock_users.sql'`

unlock_oracle_users_path
------------------------

- *Default*: '/bin:/usr/bin',
