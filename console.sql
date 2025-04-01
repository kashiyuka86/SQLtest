SHOW DATABASES;
USE mydatabase;
SHOW TABLES;
SELECT * FROM employee;
DESC employee;
INSERT INTO employee VALUES (17, '王文', '1999-08-01 00:00:00', '男', 15000, 'E');
UPDATE employee SET Name_emp = '王文建' WHERE ID = 17;
use mysql;
select * from user;

# 创建一个新的用户，只能在本地主机访问
create user 'itcast'@'localhost' identified by '123456';
# 创建一个用户，可以在任意主机访问
create user 'itcast1'@'%' identified by '123456';
# 修改用户的密码
alter user 'itcast1'@'%' identified with mysql_native_password by '1234';
# 删除用户
drop user if exists 'itcast1'@'%';

# 查询用户的权限
show grants for 'itcast'@'localhost';
# 为用户授予权限
grant all on mydatabase.* to 'itcast'@'localhost';
show grants for 'itcast'@'localhost';
#撤销用户的权限
revoke all on mydatabase.* from 'itcast'@'localhost';