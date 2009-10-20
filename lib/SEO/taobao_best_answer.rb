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

conn_local = get_connection("localhost", "root", "123456", "taobao")
conn_local2 = get_connection("localhost", "root", "123456", "taobao")
res1 = get_results_by_sql(conn_local, "select id from questions where best_answer_id is null;")
conn_local2.query("SET AUTOCOMMIT=0")
conn_local2.query("BEGIN")
res1.each_hash { |h| 
  question_id = h["id"].to_i
  select_sql = "select id from question_answers where question_id = #{question_id} and state = 1 and is_best_answer = 1;"
  answer_count = get_count_by_sql(conn_local, select_sql)
  if answer_count == 1
    res2 = get_results_by_sql(conn_local, select_sql)
    res2.each_hash { |h| @best_answer_id = h["id"].to_i }
    p update_sql = "update questions set best_answer_id = #{@best_answer_id} where id = #{question_id};"
    update_or_delete_results_by_sql(conn_local2, update_sql)
  end
}
conn_local2.query("COMMIT")
conn_local2.close
conn_local.close
