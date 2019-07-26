drop table tblTask;
drop table tblModule;
drop table tblProjectMember;
drop table tblProject;
drop sequence project_seq;
drop sequence module_seq;
drop sequence task_seq;

create sequence project_seq;
create sequence module_seq;
create sequence task_seq;

--------------------------------------------------------------------------------------------------------------------------------
create table tblProject (
    seq number primary key,
    name varchar2(500) not null,
    note varchar2(4000) null,
    progress number default 0 not null,
    sDate date not null,
    eDate date not null,
    exist number default 1 not null 
);
--------------------------------------------------------------------------------------------------------------------------------
create table tblProjectMember (
    id varchar2(50) not null references tblMember(id),
    proSeq number not null references tblProject(seq),
    lv number default 1 not null,
    exist number default 1 not null
);


create table tblModule (
    seq number primary key,
    proSeq number not null references tblProject(seq),
    moduleTaker varchar2(50) not null references tblMember(id),
    name varchar2(500) not null,
    progress number default 0 not null,
    exist number default 1 not null
);
--------------------------------------------------------------------------------------------------------------------------------

create table tblTask (
    seq number primary key,
    modSeq number not null references tblModule(seq),
    taskTaker varchar2(500) not null references tblMember(id),
    priority varchar2(20) default '보통' not null ,
    name varchar2(500) not null,
    status varchar2(20) not null,
    exist number default 1 not null
);
--------------------------------------------------------------------------------------------------------------------------------
create or replace view vwProMem as 
    select  seq,
            id,
            name,
            note,
            sdate,
            edate,
            progress,
            lv,
            (case when edate >= sysdate then 0
                  when edate < sysdate then 1 end)as isDone
            
    from tblProject p 
        inner join tblProjectMember m 
            on p.seq = m.proSeq
    where m.exist =1; 

--------------------------------------------------------
--  DDL for View VWPROMOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW VWPROMOD  AS 
  select  p.seq as proSeq,
            p.name as projectName,
            p.note as projectNote,
            p.progress as proProgress,
            p.sdate,
            p.edate,
            mem.name,
            mod.moduletaker,
            mod.progress as modProgress,
            mod.seq as modSeq,
            mod.name as modName,
            
            (select count(*) from tblTask t where t.modSeq =mod.seq and exist =1 and t.status = 1) as taskDone,
            
            (select count(*) from tblTask t where t.modSeq =mod.seq and exist =1) as totalTask
            
    from tblProject p
        inner join tblModule mod 
            on p.seq = mod.proseq
        inner join tblMember mem
            on mod.moduletaker = mem.id
    where mod.exist =1;


--------------------------------------------------------
--  DDL for View VWTASK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW VWTASK AS 
  select 
    
    (select proSeq from tblModule m where m.seq = (select modSeq from tblTask where seq = t.seq)) as proSeq,
    t.seq as taskSeq,
    t.taskTaker as id,
    (select name from tblMember m where m.id = t.taskTaker) as name,
    t.status
    
from tblTask t
where exist =1;

--------------------------------------------------------
--  DDL for View VWMYTASKS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW VWMYTASKS  AS 
  select 
        t.name as taskName,
        t.priority as taskPriority,
        t.status as taskStatus,
        t.tasktaker,
        t.seq as taskSeq,
        mod.seq as modSeq,
        mod.proseq as proSeq,
        mod.name as modName
from tblTask t
    inner join tblmodule mod
        on t.modSeq = mod.seq
where t.exist = 1 and mod.exist =1;

--------------------------------------------------------
--  DDL for View VWMEMBERS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW VWMEMBERS  AS 
  select 
        
        m.id,
        m.name,
        p.lv,
        p.proseq,
        p.exist
        
        

from tblProjectMember p 
    inner join tblMember m
        on p.id = m.id;

--------------------------------------------------------
--  DDL for View VWCOUNTTASK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW VWCOUNTTASK  AS 
  select  proseq,
        id,
        name,
        sum(status) as taskDone,
        count(id) as totalTask 
from vwTask v
group by proseq, id, name;

--------------------------------------------------------
--  DDL for View VWCOUNTTASK2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW VWCOUNTTASK2  AS 
  select  proseq,
        sum(status) as taskDone,
        count(id) as totalTask 
from vwTask v
group by proseq;

commit;

select * from tblStudyCalendar;
select * from tblStudyGroup;

select * from tblMember;
select * from VwCountTask2;
select proseq, taskDone, totalTask from vwCountTask2 where proseq =5;
select * from tblProject;
select * from tblmodule;
select * from tbltask;


