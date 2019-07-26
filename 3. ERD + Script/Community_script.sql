
-- 자유게시판
create table tblFreeBoard (
    freeSeq number primary key, --글번호(PK)
    id varchar2(50) not null references tblMember(id), --아이디(FK)
    subject varchar2(500) not null, --제목
    content varchar2(4000) not null, --내용
    regdate date default sysdate not null, --시각
    cnt number default 0 not null, --조회수
    notice varchar2(1) default 0 not null check(notice in ('1', '0')) --공지사항(1), 일반글(0)
); 

-- 자유게시판 댓글
create table tblFreeComment (
    fcSeq number primary key, --댓글 번호(PK)    
    content varchar2(2000) not null, --댓글 내용
    regdate date default sysdate not null, --작성 시각
    pfreeSeq number not null references tblFreeBoard(freeSeq), --부모글번호
    id varchar2(30) not null references tblMember(id) --댓글 작성자 id
);


-- 익명게시판
create table tblShadowBoard (
    shadowSeq number primary key, --글번호(PK)
    id varchar2(50) not null references tblMember(id), --아이디(FK)
    subject varchar2(500) not null, --제목
    content varchar2(4000) not null, --내용
    regdate date default sysdate not null, --시각
    cnt number default 0 not null, --조회수  
    notice varchar2(1) default 0 not null check(notice in ('1', '0')) 
); 

-- 익명게시판 댓글
create table tblShadowComment (
    shcSeq number primary key, --댓글 번호(PK)    
    content varchar2(2000) not null, --댓글 내용
    regdate date default sysdate not null, --작성 시각
    pshadowSeq number not null references tblShadowBoard(shadowSeq), --부모글번호
    id varchar2(30) not null references tblMember(id) --댓글 작성자 id
);

-- 교재 추천 게시판
create table tblBookUp (
    bookSeq number primary key, --글번호(PK)
    id varchar2(50) not null references tblMember(id), --아이디(FK)     
    subject varchar2(500) not null, --제목
    content varchar2(4000) not null, --내용
    writer  varchar2(300) not null, --글쓴이
    price varchar2(300) not null, --가격    
    regdate date default sysdate not null, --시각
    cnt number default 0 not null, --조회수  
    love number null,
    notice varchar2(1) default 0 not null check(notice in ('1', '0')), --공지사항(1), 일반글(0)
    filename varchar2(100) null, --첨부파일명(저장될 물리명)
    orgfilename varchar2(100) null, --첨부파일명(사용자 올린 파일명)
    downloadcount number default 0 null --다운로드 횟수   
); 

-- 교재 추천 게시판 댓글
create table tblBookComment (
    bcSeq number primary key, --댓글 번호(PK)    
    content varchar2(2000) not null, --댓글 내용
    regdate date default sysdate not null, --작성 시각
    pbookSeq number not null references tblBookUp(bookSeq), --부모글번호
    id varchar2(30) not null references tblMember(id) --댓글 작성자 id
);


-- 맛집 저장 테이블
create table tblBob(
    bobseq number primary key, -- PK
    name varchar2(100) not null,
    content varchar2(500) not null,
    lat number not null, -- 위도(Latitude)
    lng number not null, -- 경도(Longitude)     
    star varchar2(500) not null
);



--뷰--
--자유게시판 뷰--
create or replace view vwfreeb
as
select freeseq, subject, id, (select name from tblMember where id = b.id) as name
, regdate, cnt, round((sysdate - regdate) * 24 * 60) as gap
, content
, (select count(*) from tblFreeComment where fcSeq = b.freeseq) as commentcount
, notice
from tblFreeBoard b;

--익명게시판 뷰--
create or replace view vwshadowb
as
select shadowseq, subject, id, (select name from tblMember where id = b.id) as name
, regdate, cnt, round((sysdate - regdate) * 24 * 60) as gap
, content
, (select count(*) from tblshadowcomment where shcSeq = b.shadowseq) as commentcount
, notice
from tblshadowboard b;


--교재추천게시판 뷰--
create or replace view vwbookupb
as
select bookseq, subject, id, (select name from tblMember where id = b.id) as name
, regdate, cnt, round((sysdate - regdate) * 24 * 60) as gap
, content
, (select count(*) from tblbookcomment where bcSeq = b.bookseq) as commentcount
, notice
, love
from tblBookUp b;

------------------------------------
--시퀀스--

create sequence freeboard_seq;
create sequence shadowboard_seq;
create sequence bookup_seq;

create sequence freecomment_seq;
create sequence shadowcomment_seq;
create sequence bookcomment_seq;

create sequence bob_seq;

-- ======================== 생성

drop sequence freeboard_seq;
drop sequence shadowboard_seq;
drop sequence bookup_seq;
drop sequence freecomment_seq;
drop sequence shadowcomment_seq;
drop sequence bookcomment_seq;
drop sequence bob_seq;

drop table tblBob;
drop table tblBookComment;
drop table tblBookUp;
drop table tblShadowComment;
drop table tblShadowBoard;
drop table tblFreeComment;
drop table tblFreeBoard;

-- ===================== 삭제


commit;