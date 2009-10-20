require 'mysql'

def self.get_connection(host, username, password, db, port=3306)
  connection = Mysql.init
  connection.options(Mysql::SET_CHARSET_NAME, 'utf8')
  connection = Mysql.real_connect(host, username, password, db, port)
  connection.query("SET NAMES utf8")
  return connection
end

def self.get_count_by_sql(connection, sql)
  result = connection.query(sql)
  count = result.num_rows
  return count
end

def self.get_results_by_sql(connection, sql)
  results = connection.query(sql)
  return results
end

def self.update_or_delete_results_by_sql(connection, sql)
  connection.query(sql)
end

conn_remote = get_connection("125.91.15.133", "root", "chrdw,hdhxt.", "lzy_004")
conn_local = get_connection("localhost", "root", "123456", "taobao")
res1 = get_results_by_sql(conn_remote, "SELECT sid, sort1, orderid FROM cyask_sort where cyask_sort.grade = 1;")
conn_local.query("SET AUTOCOMMIT=0")
conn_local.query("BEGIN")
res1.each_hash { |h| 
  sid = h["sid"].to_i
  sort1 = h["sort1"].to_s
  orderid = h["orderid"].to_i
  p insert_sql1 = "insert into question_categories (id, position, name, created_at, updated_at) values (#{sid}, #{orderid}, \"#{sort1}\", now(), now())"
  update_or_delete_results_by_sql(conn_local, insert_sql1)
  res2 = get_results_by_sql(conn_remote, "SELECT sid, sid1, sort2, orderid FROM cyask_sort where cyask_sort.sid1 = #{sid} and cyask_sort.grade = 2")
  res2.each_hash { |h2|
    sid = h2["sid"]
    sid1 = h2["sid1"]
    sort2 = h2["sort2"]
    orderid = h2["orderid"]
    p insert_sql2 = "insert into question_categories (id, parent_id, position, name, created_at, updated_at) values (#{sid}, #{sid1}, #{orderid}, \"#{sort2}\", now(), now())"
    update_or_delete_results_by_sql(conn_local, insert_sql2)
  }
}
conn_local.query("COMMIT")
conn_local.close
conn_remote.close