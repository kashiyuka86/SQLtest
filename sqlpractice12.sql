show databases;
use new_schema;
drop table if exists new_table;
select * from course;
# SQL练习40题，2024年12月考试

select t1.*, t2.cname, t3.tname, t4.sname from sc as t1
        inner join course as t2
        inner join teacher as t3
        inner join student as t4
        on t1.CId = t2.CId and t2.tid=t3.TId and t1.SId=t4.SId;

# 1.选择01课程比02课程成绩高的学生学号
select t1.SId as id, T1.score, T2.score
from
((select * from sc where cid = '01') as t1
left join
(select * from sc where cid = '02') as t2
on t1.sid = t2.sid) where t1.score>t2.score;

# 2.查询平均成绩大于60分的同学学号姓名和平均成绩
select Sid, Sname, Avg(Score) from
(select t1.*, t2.Sname from sc as t1
inner join
student as t2 on t1.SId=t2.SId) as t3
group by sid, Sname having AVG(score)>60;

# 3.查询所有同学学号、姓名、选课数、总成绩
select Sid, Sname, count(score) as number, sum(Score) as sum_score from
(select t1.*, t2.Sname from sc as t1
inner join
student as t2 on t1.SId=t2.SId) as t3
group by sid, Sname;

# 3.1查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为null）
select t1.sid, t1.sname, count(t2.score) as cntscore, sum(t2.score) as sumscore
from student as t1
left join sc as t2
on t1.SId = t2.sid or t2.sid is null
group by t1.SId, t1.Sname;

# 3.2查询所有有成绩的学生信息
select * from student where sid in (select sid from sc);

# 4.查询姓李的老师个数
select count(TId) as countLi from teacher where Tname like '李%';

# 5.查询没学过张三老师课的同学学号姓名
select sid, Sname from student where SId not in
    (
        select t1.SId from sc as t1
        inner join course as t2
        inner join teacher as t3
        inner join student as t4
        on t1.CId = t2.CId and t2.tid=t3.TId and t1.SId=t4.SId
        where tname = '张三'
    );

# 6.查询学过“01”并且也学过编号“02”课程的同学的学号、姓名
with table1 as (select t1.*, t2.Sname from sc as t1
        inner join student as t2
        on t1.SId=t2.SId)
select tb1.SId as sid, tb1.Sname as sname from table1 as tb1
inner join table1 as tb2
on tb1.SId=tb2.SId and tb2.CId='02'
where tb1.CId='01' ;

select sid, sname from student where sid in
    (select t1.sid from sc as t1 inner join sc as t2 on t1.sid = t2.sid
     where t1.cid = 01 and t2.cid = 02);

# 6.1查询存在01课程但是可能不存在02课程的情况
select t1.sid, t1.cid, t1.score, t2.sid, t2.cid, t2.score
from
sc as t1
left join sc as t2
on t1.sid = t2.sid and t2.cid=02
where t1.cid = 01;  # inner join是既有01课程又有02课程的情况

# 7.查询学过“张三”老师所教的课的同学的学号、姓名
select t1.SId, t4.sname from sc as t1
inner join course as t2
inner join teacher as t3
inner join student as t4
on t1.CId = t2.CId and t2.tid=t3.TId and t1.SId=t4.SId
where tname = '张三';

# 8.查询课程编号“01”的成绩比课程编号“02”课程低的所有同学的学号；
select t1.sid
from sc as t1
left join sc as t2
on t1.sid = t2.sid and t2.cid=01
where t1.cid=02 and t1.score>t2.score;

select t1.SId as id from ((select * from sc where cid = '01') as t1
left join
(select * from sc where cid = '02') as t2
on t1.sid = t2.sid) where t1.score<t2.score;

# 9.查询所有课程成绩小于60分的同学的学号、姓名；
select t1.Sid as sid, t2.Sname as sname from sc as t1
inner join student as t2
on t1.SId = t2.SId
group by sid, sname having max(score)<60;

# 9.1查询平均成绩大于60分的同学信息，平均成绩
select t1.Sid, t1.Sname, avg(t2.score) as avgscore
from
student as t1
inner join sc as t2
on t1.SId = t2.sid
group by t1.Sid, t1.Sname
having avg(t2.score)>=60;


# 10.查询没有学全所有课的同学的学号、姓名：
select t1.Sid as sid, t2.Sname as sname from sc as t1
inner join student as t2
on t1.SId = t2.SId
group by sid, sname having count(score)<3;
# 10.1查询学完所有课程的学生信息
select t1.sid, t2.sname, count(t1.cid) as cnt
from sc as t1
inner join student as t2
on t1.sid = t2.SId
group by t1.sid, t2.sname
having count(t1.cid) = (select count(cid) from course);

# 11.查询至少有一门课与学号为“01”的同学所学相同的同学的学号和姓名：
select distinct t1.Sid as sid, t2.Sname as sname
from sc as t1
inner join student as t2
on t1.SId = t2.SId
where cid in (
select cid from sc where SId='01') and t1.SId!='01';

# 12.查询和"01"号的同学学习的课程完全相同的其他同学的学号和姓名
with totc as (
    select sid, group_concat(CId) as tot from sc group by SId
)
select distinct t1.Sid as sid, t2.Sname as sname
from sc as t1
inner join student as t2
inner join totc as t3
on t1.SId = t2.SId and t1.sid = t3.SId
where t3.tot = (select tot from totc where SId='01') and t1.sid !='01';

# 13.把“SC”表中“张三”老师教的课的成绩都更改为此课程的平均成绩，不要调用！
with avgscore as (select Avg(t1.score) as avgs from sc as t1
        inner join course as t2
        inner join teacher as t3
        inner join student as t4
        on t1.CId = t2.CId and t2.tid=t3.TId and t1.SId=t4.SId
        where tname = '张三')
update sc set score= (select avgs from avgscore) where cid = 02;

# 14.查询没学过"张三"老师讲授的任一门课程的学生姓名
select sname from student where SId not in (
select t1.sid from sc as t1
        inner join course as t2
        inner join teacher as t3
        inner join student as t4
        on t1.CId = t2.CId and t2.tid=t3.TId and t1.SId=t4.SId
        where tname = '张三');

# 15.查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select t1.Sid, t2.Sname, avg(t1.score) as avgscore
from sc as t1
    inner join student as t2
        on t1.SId=t2.SId
group by sid, Sname having sum(if(t1.score<60, 1, 0))>=2;

# 16.检索"01"课程分数小于60，按分数降序排列的学生信息
select t4.SId, t4.Sname, t1.score from sc as t1
        inner join student as t4
        on t1.SId=t4.SId
where t1.CId = '01' and t1.score<60 order by score desc ;

# 17.按平均成绩从高到低显示所有学生的平均成绩
select t4.SId, t4.Sname, avg(score) as avgscore from sc as t1
        inner join student as t4
        on t1.SId=t4.SId
group by t1.sid, Sname order by avgscore desc;

# 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率
select t2.CId, t2.Cname, max(score) as maxscore, min(score) as minscore, avg(score) as avgscore, sum(score>=60)/count(score) as passrate from sc as t1
        inner join course as t2
        inner join student as t4
        on t1.CId = t2.CId and t1.SId=t4.SId
        group by t2.cid, t2.Cname;
# 18.1查询各科成绩最高分、最低分和平均分，及格率、中等率、优良率、优秀率、选修人数、查询结果按人数降序排列，若人数相同，按课程号升序排列
select t2.CId, t2.Cname,
       max(score) as maxscore,
       min(score) as minscore,
       avg(score) as avgscore,
       concat(100*sum(if(score <60, 1, 0))/count(t1.sid), '%') as '及格率',
       concat(100*sum(if(score between 60 and 69, 1, 0))/count(t1.sid), '%') as '及格率',
       concat(100*sum(if(score between 70 and 79, 1, 0))/count(t1.sid), '%') as '中等率',
       concat(100*sum(if(score between 80 and 89, 1, 0))/count(t1.sid), '%') as '优良率',
       concat(100*sum(if(score >= 90, 1, 0))/count(t1.sid), '%') as '优秀率',
       count(t1.sid) as '选修人数'
from sc as t1
inner join course as t2
on t1.CId = t2.CId
group by t2.cid, t2.Cname
order by '选修人数' desc, t2.cid;

# 19.按各科平均成绩从低到高和及格率的百分数从高到低顺序
select cid,avg(score) as avg_score, sum(case when score>=60 then 1 end)/count(1) as passrate
from sc
group by cid
order by avg_score,passrate desc;

# 20.查询学生的总成绩并进行排名
select t4.SId, t4.Sname, sum(score) as sumscore, rank() over(order by sum(score) desc) as ranking from sc as t1
    inner join student as t4
    on t1.SId=t4.SId
group by t4.SId, Sname;

# 21.查询不同老师所教不同课程平均分从高到低显示
select t3.TId, t3.Tname, avg(score) as avgscore from sc as t1
        inner join course as t2
        inner join teacher as t3
        inner join student as t4
        on t1.CId = t2.CId and t2.tid=t3.TId and t1.SId=t4.SId
    group by t3.TId, t3.Tname order by avgscore desc;

# 22.查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
select sid, Sname from
    (select t1.*, t2.Cname, t4.Sname as sname,
                               row_number() over (partition by cid order by score desc) as ranking
                        from sc as t1
                                 inner join course as t2
                                 inner join teacher as t3
                                 inner join student as t4
                                            on t1.CId = t2.CId and t2.tid = t3.TId and t1.SId = t4.SId) as t5
                  where ranking = 2 or 3;

# 23.统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比
select t1.cname,
       sum(case when score<=100 and score>=85 then 1 else 0 end)as s1,
       sum(case when score<85 and score>=70 then 1 else 0 end)as s2,
       sum(case when score<70 and score>=60 then 1 else 0 end)as s3,
       sum(case when score<60 then 1 else 0 end)as s4
from course as t1 inner join sc as t2
on t1.Cid = t2.cid
group by t1.cname;

# 24.查询学生平均成绩及名次
select t4.SId, t4.Sname, avg(score) as avgscore, rank() over (order by avg(score) desc) as ranking from sc as t1
        inner join student as t4
        on t1.SId=t4.SId
group by t4.SId, t4.Sname;

# 24.1查询平均成绩≥85的所有学生的学号、姓名和平均成绩
select t1.sid, t2.Sname, avg(score) as avgscore
from sc as t1
inner join student as t2
on t1.sid = t2.SId
group by t1.sid, t2.Sname having avg(score)>=85;

# 24.2查询任何一门课程成绩在70分以上的学生姓名、课程名称和分数
select t4.Sname, t2.cname, t1.score
from sc as t1
inner join course as t2
inner join student as t4
on t1.CId = t2.CId and t1.SId = t4.SId
where t1.score>70;

# 24.3查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
select t1.*, t2.*
from sc as t1
inner join sc as t2
on t1.score = t2.score and t1.cid!=t2.cid;

# 25.查询各科成绩前三名的记录
select * from (
    select t4.SId, t4.Sname, t1.cid, row_number() over (partition by t1.cid order by score desc) as ranking from sc as t1
    inner join student as t4
    on t1.SId=t4.SId) as t5 where ranking<=3;

# 26.查询每门课程被选修的学生数
select cid, count(distinct sid) as cnt
from sc
group by cid;

# 27.查询出只选修了两门课程的全部学生的学号和姓名
select t4.sid, t4.Sname from sc as t1
    inner join student as t4
    on  t1.SId=t4.SId
    group by t4.sid, t4.Sname having count(t1.sid)=2;

# 28.查询男生女生数量
select Ssex, count(1) as count from student group by Ssex;

# 29.查询名字中含有"风"字的学生信息
select * from student where Sname like '%风%';

# 30.查询同名者并返回个数
select Sname, count(Sname) as num from student group by Sname having count(Sname)>=2;

# 31.查询1990年出生的学生名单
select * from student where substr(Sage, 1, 4) = 1990;

# 32.查询每门课程的平均成绩，结果按平均成绩升序排列
select cid, avg(score) as avgscore from (
select t1.*, t2.score from course as t1
inner join sc as t2
on t1.CId = t2.cid) as t3 group by cid
order by avg(score) asc;

# 33.查询不及格的课程，并按课程号从大到小排列
select
    cid,sid,score
from sc
where score<60
order by cid desc,sid;

# 34.查询课程编号为"01"且课程成绩在60分以上的学生的学号和姓名；
select sid,cid,score
from sc
where cid='01' and score>60;

# 35.查询选修“张三”老师所授课程的学生中，成绩最高的学生姓名及其成绩
select t5.Sname as name, t5.score as score from
(select t1.*, t2.Cname, t3.Tname, t4.Sname, rank() over (order by score desc) as ranking from sc as t1
    inner join course as t2
    inner join teacher as t3
    inner join student as t4
    on t1.CId = t2.CId and t2.tid=t3.TId and t1.SId=t4.SId
where t3.Tname = '张三') as t5 where ranking=1;

# 36.统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
select cid, count(cid) as cnt from sc group by cid having count(cid)>=5 order by cnt desc, cid asc;

# 37.检索至少选修两门课程的学生学号
select sid from sc group by sid having count(sid)>=2;

# 38.查询学生的年龄
select timestampdiff(year, Sage, Now()) as age from student;

# 39.查询本月过生日的学生
select Sname from student where extract(month from Sage) = 12;

# 40.查询年龄最大者
select Sname from (
    select Sname, rank() over (order by timestampdiff(year, Sage, Now()) desc) as ranking from student
                  )as t1 where ranking=1;

# 41.lag的用法，比较今年与上一年的薪水，薪水增长率等等
select * from sc;
select sid, score-lag(score, 1, null) over(partition by sid order by score) as diff from sc;

# 42.SUM窗口函数
# 43.INSERT INTO tab(col1, col2, ..., coln) VALUES (val1, val2, ..., valn)
# 44.NTile(n)窗口函数，等值n分桶
select *, ntile(3) over(order by score desc) as grade from sc;
# 45.unix_timestamp, from_unixtime
# 46.cast函数转换数据类型
select cast(123.45 as signed);
# 47.length()函数返回长度
# 48.查询名字是三个字的人
select * from student where Sname like '___';
# 49.UNION, INTERSECT, EXCEPT
# 50.EXIST
select * from sc as t1 where exists(select 1 from student as t2 where t1.sid = t2.SId);
# 51.PAD
select LPAD(score, 10, '*') as lpad_score from sc;  # 填充*直到10长
# 52.left join中on和where的区别
# 如果在join后使用where进行过滤，会过滤掉空值，所以若想保留空值（即保留左表的所有列），要在on中添加右表的过滤条件
# select user_id as buyer_id, join_date, count(order_id) as orders_in_2019
# from Users as u left join Orders as o on u.user_id = o.buyer_id and year(order_date)='2019'
# group by user_id

# select user_id as buyer_id, join_date, count(order_id) as orders_in_2019
# from Users as u left join Orders as o on u.user_id = o.buyer_id
# where year(order_date)='2019'
# group by user_id

select 100*Round(sum(t2.order_date = t2.cpdd)/count(t2.customer_id), 4) as immediate_percentage
from
(select *
from
    (select delivery_id, customer_id, order_date, customer_pref_delivery_date as cpdd, rank() over(partition by customer_id order by order_date) as ranking from delivery)
    as t1 where t1.ranking = 1)as t2

select Round(count(t1.customer_id)/t2.cnt2, 4)*100 as immediate_percentage
from
(select customer_id, min(order_date) over(partition by customer_id) as mdt, customer_pref_delivery_date
from Delivery) as t1
cross join
(select count(distinct customer_id) as cnt2 from Delivery) as t2
where t1.mdt = t1.customer_pref_delivery_date
# 53.窗口函数 Range interval n Time preceding，特定时间范围内的窗口函数
SELECT sales_date, sales_amount,
    SUM(sales_amount) OVER (ORDER BY sales_date
                            RANGE INTERVAL 6 DAY PRECEDING)
FROM sales;
# 54.匹配正则表达式
SELECT user_id, name, mail
FROM Users
-- 请注意，我们还转义了`@`字符，因为它在某些正则表达式中具有特殊意义
WHERE mail REGEXP '^[a-zA-Z][a-zA-Z0-9_.-]*\@leetcode\\.com$';

#55 考试题答案测试
insert into employees values
(1, 'Anju', 'Inami', null),
(2, 'Rikako', 'Aida', 1),
(3, 'Ai', 'Furihata', 1),
(4, 'Sayuri', 'Date', null),
(5, 'Jia', 'Li', 4),
(6, 'Nagisa', 'Aoyama', 4),
(7, 'Aguri', 'OOnishi', null),
(8, 'Coco', 'Hayashi', 7),
(9, 'Naomi', 'Payton', 4);

insert into sales values
(1, Now(), 100),
(2, Now(), 150),
(3, Now(), 50),
(4, Now(), 200),
(5, Now(), 500),
(6, Now(), 150),
(7, Now(), 150),
(8, Now(), 300),
(9, Now(), 120);

with TB as
(
    select t1.*, t2.amount
    from
    employees as t1
    inner join
    sales as t2
    on t1.employee_id = t2.employee_id
)
select t3.first_name as f_1, t3.last_name as l_1, t3.amount as a_1,
       t4.first_name as f_2, t4.last_name as l_2, t4.amount as a_2
from
TB as t3
left join
TB as t4
on t3.manager_id = T4.employee_id;

# 56.Greatest函数
select greatest(1, 2, 3) as biggest;
# 57.按照首字母排序
# 58.Substr和Instr
# 59.各个字段的执行顺序
# 60.Update, Delete, Alter, Insert操作
# 61.创建表操作

select * from test;
select t1.* from test_1 as t1
inner join
未出库车架号 as t2
on t1.C3 = t2.C1;