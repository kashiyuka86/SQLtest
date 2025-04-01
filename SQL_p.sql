SHOW DATABASES;
USE mydatabase;
SHOW TABLES;
#RENAME TABLE sc TO `score`;



SELECT * FROM course;
CREATE TABLE student_new AS (SELECT distinct * FROM student);
SELECT * FROM teacher;

SHOW DATABASES;
USE mydatabase;
SHOW TABLES;

# 查询"01"课程比"02"课程成绩高的学生的信息及课程分数
SELECT * FROM student_new;
select * from score;

select s1.SId from (select * from score where CId = 01) as s1
inner join
(select * from score where CId = 02) as s2 on s1.SId = s2.SId
where s1.score>s2.score;

# 查询存在" 01 "课程但可能不存在" 02 "课程的情况
select * from (
    (select * from score where CId = 01) as s1
    left join
    (select * from score where CId = 02) as s2
    on s1.SId = s2.SId) where s2.CId is null;

#查询同时存在01和02课程的情况
select * from (
    (select * from score where CId = 01) as s1
    left join
    (select * from score where CId = 02) as s2
    on s1.SId = s2.SId) where s2.CId is not null;

#选了02没有选01的学员
select s1.SId as SId_new from(
(select SId, score from score where CId = 02)as s1
left join
(select SId, score from score where CId = 01)as s2
on s1.SId = s2.SId) where s2.score is null ;

#查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
select * from (select SId, avg(score) as avg_s from score group by SId) as s1 where s1.avg_s>60;

#查询在 SC 表存在成绩的学生信息
SELECT distinct s1.SId, s1.Sname, s1.Sage, s1.Ssex from student_new as s1
inner join score as s2 on s1.SId = s2.SId;

# 查询li姓老师的数量
select count(*) as '数量' from teacher where Tname like '李%';

#查询学过zs老师授课的同学的信息
select * from student_new where SId in (
select SId from score where CId in
(select s3.CId from (select s1.CId, s1.Cname, s1.TId, s2.Tname from course as s1
inner join teacher as s2
on s1.TId = s2.TId where Tname = '张三') as s3));

#查询没有学全所有课程的信息
select SId from (select SId, count(SId) as Count1 from score group by SId) as s1
           where s1.Count1<3 ;

#查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息
select * from student_new where SId in
(   select Sid from score where CId in (select cid
                                        from score
                                        where SId = 01)
)and SId != 01;

#查询没学过zs老师讲授的任一门课程的学生姓名

select sid , sname from student_new where SId not in(
    select sid from (select * from score) as t1 where cid = 02);

#查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select Sname, t1.SId as stuid, t1.avgs from student_new inner join
    (select SId, avg(s1.score) as avgs from
    (select sid, score from score where score<60) as s1 group by SId) as t1
    on student_new.SId = t1.SId;

#检索" 01 "课程分数小于 60，按分数降序排列的学生信息
select * from (select sid, score from score where CId = 01) as t1 where t1.score<60
order by score desc;

#按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
#查询各科成绩最高分、最低分和平均分
select max(score) as '最高分', min(score) as '最低分', avg(score) as '平均分' from score group by CId;

#查询及格率，良好率，优秀率
select SUM(统计 = '不及格') / COUNT(sid) AS '不及格率',
  SUM(统计 = '及格') / COUNT(sid) AS '及格率',
  SUM(统计 = '良好') / COUNT(sid) AS '良好率',
  SUM(统计 = '优秀') / COUNT(sid) AS '优秀率',
  SUM(统计 = '卓越') / COUNT(sid) AS '卓越率'
    from(
select *, (
    case
        when score<60 then '不及格'
        when score>=60 and score<70 then '及格'
        when score>=70 and score<80 then '良好'
        when score>=80 and score<90 then '优秀'
        when score>=90 and score<=100 then '卓越'
    end
) as '统计' from score) as t1 ;

#按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺
select *, dense_rank() over (partition by CId order by score) from score;

#查询学生的总成绩，并进行排名，总分重复时保留名次空缺
select *, rank() over (order by t1.sum_score desc) as '排名' from
        (select sid, sum(score) as sum_score from score group by sid) as t1;

#统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
#?

#查询各科成绩前三名的记录
select * from (select *, row_number() over (partition by cid order by score desc) as ranking from score)
         as t1 where ranking <=3;

# 查询出只选修两门课程的学生学号和姓名
select * from student_new;
select t1.sid, t1.sname from student_new as t1 inner join
(select sid, count(score) as number from score group by sid) as t2 on t1.SId = t2.SId
where t2.number = 2;

#查询男生、女生人数
select Ssex, count(sid) as number from student_new group by Ssex;

#查询名字中含有「风」字的学生信息
SELECT *
FROM student_new
WHERE sname LIKE '%风%';

#查询 1990 年出生的学生名单
select * from student_new where year(Sage) = '1990';

#查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩
select * from (select t3.Sname, avg(t3.score) as avg_s from (select t1.Sname, t2.* from student_new as t1 inner join score as t2
    on t1.SId = t2.SId) as t3 group by t3.Sname) as t4 where t4.avg_s>=85;