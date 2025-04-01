select @@transaction_isolation;     # REPEATABLE-READ 查看事务隔离级别
set session transaction isolation level read uncommitted;       #设置事务隔离级别

show engines;