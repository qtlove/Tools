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
res1 = get_results_by_sql(conn_remote, "select a.qid, a.sid1, a.sid2, a.uid, a.username, a.title, b.supplement, a.score, FROM_UNIXTIME(a.asktime) as asktime, a.status, a.answercount, a.clickcount from cyask_question a left join cyask_question_1 b on (a.qid=b.qid) where a.qid > 100000 and a.qid <= 110000;")
conn_local.query("SET AUTOCOMMIT=0")
conn_local.query("BEGIN")
res1.each_hash { |h| 
  id = h["qid"].to_i
  category_id = (h["sid2"].to_i==0)?(h["sid1"].to_i):(h["sid2"].to_i)
  user_id = h["uid"].to_i
  author = h["username"].to_s
  title = h["title"].to_s.gsub("\\", "").gsub("\"", "\\\"")
  description = h["supplement"].to_s.gsub("\\", "").gsub("\"", "\\\"")
  score = h["score"].to_i
  created_at = updated_at = h["asktime"].to_s
  status = h["status"].to_i
  flag = 0 if status == 1
  flag = 1 if status == 2
  flag = 2 if status == 4
  flag = 3 if status == 7
  flag
  answer_count = h["answercount"].to_i
  view_count = h["clickcount"].to_i
  p insert_sql = "insert into questions(id, category_id, user_id, ip, view_count, answer_count, score, flag, state, author, title, description, created_at, updated_at) " +
    "values (#{id}, #{category_id}, #{user_id}, 2130706433, #{view_count}, #{answer_count}, #{score}, #{flag}, 1, \"#{author}\", \"#{title}\", \"#{description}\", \"#{created_at}\", \"#{updated_at}\")"
  update_or_delete_results_by_sql(conn_local, insert_sql)
}
conn_local.query("COMMIT")
conn_local.close
conn_remote.close