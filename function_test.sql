## 函数

# 字符串函数
select concat('hello', ' ', 'Chelsea');      # concat连接
select lower('Hello');
select upper('hello');
select lpad('chelsea', 10, 'go');       # 左填充，直到指定长度 gogchelsea
select rpad('chelsea', 10, 'go');       # 右填充，直到指定长度 gogchelsea
select substring('chelsea is the pride of london', 1, 10);
# chelsea is
select trim('  chelsea chelsea chelsea  ');     # strip：chelsea chelsea chelsea

# 数值函数
select ceil(1.5);       # 2
select floor(1.5);      # 1
select mod(6, 4);       # 2
select rand();      # 0.6071284391052354
select round(rand(), 2);     # 0.79
select truncate(1.23, 1);       # 1.2

# 例：生成一个6位随机数码
select lpad(round(rand()*1000000, 0), 6, 0)

# 流程控制函数
select if(1>0, 1, 0);   # 1
select ifnull(null, 'this is null');     # this is null
