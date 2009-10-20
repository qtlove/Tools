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
res1 = get_results_by_sql(conn_remote, "select a.aid, a.qid, a.uid, b.username, b.content, a.response, FROM_UNIXTIME(a.answertime) as answertime, FROM_UNIXTIME(a.adopttime) as adopttime from cyask_answer a left join cyask_answer_1 b on (a.aid=b.aid)  where a.aid > 200000 and a.aid <= 300000;")
conn_local.query("SET AUTOCOMMIT=0")
conn_local.query("BEGIN")
res1.each_hash { |h| 
  id = h["aid"].to_i
  question_id = h["qid"].to_i
  user_id = h["uid"].to_i
  ip = 2130706433
  state = 1
  author = h["username"].to_s
  content = h["content"].to_s.gsub("\\", "").gsub("\"", "\\\"")
  is_best_answer = h["response"].to_i
  created_at = h["answertime"].to_s
  updated_at = (h["adopttime"].to_s=="1969-12-31 14:00:00")?(created_at):(h["adopttime"].to_s)
  p insert_sql = "insert into question_answers(id, question_id, user_id, ip, state, author, content, is_best_answer, created_at, updated_at) " +
    "values (#{id}, #{question_id}, #{user_id}, #{ip}, #{state}, \"#{author}\", \"#{content}\", #{is_best_answer}, \"#{created_at}\", \"#{updated_at}\")"
  update_or_delete_results_by_sql(conn_local, insert_sql)
}
conn_local.query("COMMIT")
conn_local.close
conn_remote.close
