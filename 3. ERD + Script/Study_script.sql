
create table tblStudy(
    studyNum number primary key,
    studyName varchar2(50) not null,
    title varchar2(500) not null,
    content varchar2(4000) not null,
    regdate date default sysdate,
    cnt number default 0,
    limit number not null,
    id varchar2(50) not null references tblMember(id),
    del varchar2 (1) default '1' not null,
    notice varchar2 (1) default '0' not null
);

create table tblStudyComment(
    StudyCommentNum number primary key,
    studyNum number not null references tblStudy(studyNum),
    id varchar2(30) not null references tblMember(id),
    content varchar2(4000) not null,
    del varchar2(1) default '1' not null,
    regdate date default sysdate not null
);


create table tblStudyCalendar(
    studyCalendarNum number primary key,
    id varchar2(50) not null references tblMember(id),
    title varchar2(1000) not null,
    content varchar2(4000) not null,
    begin date not null,
    end date not null,
    kind varchar2(100) not null,
    studyNum number not null references tblStudy(studyNum),
    del varchar2(1) default '1' not null,
    place varchar2(300) not null,
    lat varchar2(100) not null,
    lng varchar2(100) not null,
    regdate date default sysdate not null,
    cnt number default 0 not null
);


create table tblAttend(
    studyAttendNum number primary key,
    studyCalendarNum number not null references tblStudyCalendar(studyCalendarNum),
    id varchar2(50) not null references tblMember(id)
);

create table tblstudygroup(
    studyGroupNum number primary key,
    studyNum number not null references tblStudy(studyNum),
    id varchar2(50) not null references tblMember(id),
    grade varchar2(10) not null,
    del varchar2(1) default '1' not null
);


create table tblStudyReview(
    studyReviewNum number primary key,
    id varchar2(50) not null references tblMember(id),
    studyNum number not null references tblStudy(studyNum),
    title varchar2(500) not null,
    content varchar2(4000) not null,
    regdate date default sysdate,
    cnt number default 0,
    del varchar2(1) default '1' not null,
    notice varchar2 (1) default '0' not null
);


create table tblStudyReviewComment(
    studyReviewCommentNum number primary key,
    studyReviewNum number references tblStudyReview(studyReviewNum),
    id varchar2(50) not null references tblMember(id),
    content varchar2(4000) not null,
    regdate date default sysdate,
    del varchar2(1) default '1' not null
);


create table tblStudyBoard(
    studyBoardNum number primary key,
    studyNum number null references tblStudy(studyNum),
    id varchar2(50) not null references tblMember(id),
    title varchar2(500) not null,
    kind varchar2(100) not null,
    content varchar2(4000) not null,
    regdate date default sysdate,
    cnt number default 0,
    del varchar2(1) default '1' not null,
    notice varchar2 (1) default '0' not null
);

create table tblStudyBoardComment(
   studyBoardCommentNum number primary key,
   studyBoardNum number not null references tblStudyBoard(studyBoardNum),
   id varchar2(50) not null references tblMember(id),
   content varchar2(4000) not null,
    regdate date default sysdate,
    del varchar2(1) default '1' not null
);

-- ============================ 시퀀스

create sequence studyNum_seq;
create sequence StudyCommentNum_seq;
create sequence studyCalendarNum_seq;
create sequence studyAttendNum_seq;
create sequence studyGroupNum_seq;
create sequence studyReviewNum_seq;
create sequence studyReviewCommentNum_seq;
create sequence studyBoardNum_seq;
create sequence studyBoardCommentNum_seq;

create or replace view vwStudy
as
select studyNum, id, studyName, title, cnt, limit, del,
(select round((sysdate - regdate) * 24 * 60) from tblStudy where s.studyNum = studyNum) as gap, 
(select count(*) from tblStudyGroup where s.studyNum = tblStudyGroup.studyNum and tblStudyGroup.del = '1') as personnel ,
(select m.del from tblMember m where m.id = s.id) as mdel
    from tblStudy s;
-- 회원 리스트 뽑아오는 view

create or replace view vwStudyBoard
as
select studyBoardNum, studyNum, id, title, kind, content, 
round((sysdate-regdate)*24*60) as gap , cnt 
from tblStudyBoard;
-- 스터디 전용 게시판 뽑아오는 view

create or replace view vwStudyReview
as
select r.studyReviewNum, r.id, r.studyNum, r.title, r.content,
round((sysdate-r.regdate)*24*60) as gap, r.cnt, r.notice, s.studyName
from tblStudyReview r inner join tblStudy s on r.studyNum = s.studyNum
where r.del = '1';
-- 스터디 후기 게시판 뽑아오는 view

-- ======================== 생성

drop sequence studyBoardCommentNum_seq;
drop sequence studyBoardNum_seq;
drop sequence studyReviewCommentNum_seq;
drop sequence studyReviewNum_seq;
drop sequence studyGroupNum_seq;
drop sequence studyAttendNum_seq;
drop sequence studyCalendarNum_seq;
drop sequence StudyCommentNum_seq;
drop sequence studyNum_seq;

drop table tblStudyBoardComment;
drop table tblStudyBoard;
drop table tblStudyReviewComment;
drop table tblStudyReview;
drop table tblstudygroup;
drop table tblAttend;
drop table tblStudyCalendar;
drop table tblStudyComment;
drop table tblStudy;

-- ==================== 삭제

-- 여기부터 데이터
-- tblStudy 데이터
insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'baeabae00', '진중모', '[강남]진중모-중국어회화모임', '매번 자기소개하고, 취미는 뭐냐 등 소모적인 회화를 계속 하시겠습니까? 중국어 회화실력에 전혀 도움되지 않습니다. 중국인과 회화를 한다고 해도 따로 공부를 하지 않는다면 실력에 도움되지 않습니다.

중국 프로그램 시청 후 관련 주제에 대해 이야기하는 학습형 중국어회화스터디를 한번 경험해보시기 바랍니다.

장소 : 강남역 스터디룸
시간 : 매주 토요일 오후 3시~5시
모집기준 : 신HSK5급 이상(혹은 그에 상당하는 회화실력)', default, 0, 20, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'bin1764', '퇴영광', '퇴근후 영어 광내기(회화 스터디)', '교포 번역가와 함께하는 15년차 영어모임 퇴영광에 오신걸 환영합니다.

가입 후 3일 이내 가입인사 작성

6개월 이상 오프라인 모임 미참여시 강퇴

<Timetable>
07::30 ~ 08::00 - Preparation
08::00 ~ 08::20 - Stand-up Conversation
08::20 ~ 08::35 - Topic Convers
08::35 ~ 08::40 - BreadkTime
08::40 ~ 09::30 - Article Discussion', default, 0, 30, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'bighi700', '위드 프렌즈', '위드 프렌즈(영어회화,독서,친목)', '영어를 메인으로 함께 성장하는 친목 모입입니다.
영어 회화 실력도 향상시키고, 원어민 및 다양한 분야의 사람들과 함께 소통하는 곳~
관심사가 같은 멤버들과 함께라서 더욱 즐거운 위드 프렌즈 With Friends에서 만나요~

스터디 장소 및 시작 시간(소요시간- 주로 2시간)
1) 평일 - 주로 신림역 저녁 7시 반
2) 주말 - 주로 낙성대역 오전, 오후
3) 그 밖의 장소, 시간에 스터디,친목,번개', default, 0, 15, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'muruea233', '열정청년 스터디', '[스터디 No.1] 열정청년 스터디', '[스터디그룹 No.1 그 어느 모임보다 활동적, 체계적인 모임 열정청년 스터디]
스스로 공부하기 힘든 사람들에게 서로가 의지를 더해주고 자극제 역할을 하여 꿈과 목표를 향해 더 나아갈 수 있도록 하는 유익한 스터디 모임이 되겠습니다.
-다른 스터디 모임ㅇ보다 차별화 되어있는 체계적인 관리, 타임룰 규정안에서 공부를 진행하고 있습니다.
- 기쁨과 슬픔을 진심으로 공감해주는 화목한 분위기 조성(모임자체 축하이벤트, 각종 이벤트 진행)
- 친목겸 뒷풀이와 단결활동/정모가 정기적으로 있으나 공부가 주 목표입니다.
', default, 0, 30, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'whdhgj134', '습관동호회', '습관동호회]스터디 자기계발 자기개발', '습관잡기동호회 CGS

38기 모집진행중

가벼운 모임 휘발성 모임을 찾으신다면 돌아가주세요~

소모적인모임이 아닙니다.

단, 하나 약속 드릴게요.
이곳에 오시면 6주동안은
무엇을 원하든
목표를 실행할 수 있는 힘을
얻을 수 있습니다!

그리고 저희는 기수제로 운영되는 동호회입니다.

잡고싶은 습관목표를 설정하고 협동, 경쟁을 통하여 습관목표를 달성하는 모임이에요

참여제한 - 대학생~직장인', default, 0, 30, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'jyeon96', '낯선대', '관악구 스터디 낯선대', '-낯선- 사람들이 모여 대화도 하고 스터디도 하는 친목 + 공부 모임

자격증, 토익, 독서 등 원하는 공부를 할 수 있는 스터디!

주말은 정기, 평일은 선택 스터디!

한달에 1번 주말 스터디 필참!

스터디 중 함께 식사도 하고 2시간에 한번 쉬는시간을 함께합니다!

낙성대 [오렌지연필]에서 스터디!

■ 한달에 한번 정모!
■ 식사나 간단한 벙들도 가끔 열려요!

※ 취미모임은 ok! 친목모임 및 타스터디 모임 가입불가!', default, 0, 50, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'minsang564', 'NGO', '사회적기업/NGO 모임', '사회적기업가, 소셜벤처, NGO/NPO사업가 또는 이 분야에 관심과 열정이 ㅣㅇㅆ고 나눔을 실천하는 마음 따뜻한 사람들의 모임입니다.

스터디, 정보공유, 토론, 인적네트워킹, 협업 등 편안하지만 의미있고 실천하는 모임을 만들고자 합니다.

사회적기업 / 소셜벤처 / NPO npo / NGO ngo / CSR csr / CSV csv / 공유경제 / 사업 / 스타트업 / 나눔 / 봉사 / 자선 / 공유 / 기부', default, 0, 80, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'gjswjd901', '2030', '2030 얻어가는 독서모임', '매주 월요일 저녁 7시~30분에 시작해서 2시간 가량 진행됩니다.

직장을 다니다 보면 책 읽기가 쉽지 않습니다.
최근에는 어플 <밀리의 서재>, e북 등을 이용해 장소에 구애받지 않고 책을 읽고 있습니다.
스터디를 통해 독서습관을 길러서 사고의 깊이나 세상을 바라보는 시야를 넓히고자 독서모임을 만들게 됬습니다.

독서 모임과 함께 서로 강제성을 부여해보면 어떨까요?

단순 수다로 끝나는 친목 모임이 아닌 독서와 의견교환을 통해 얻어가는 독서모임을 함께 만들어갑시다.

장소 강남역 12번 출구 분위기 좋은 스터디카페',  default, 0, 25, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'watsupz012', '꿈보다 해봄', '[STUDY] 꿈보다 해봄', 'SINCE 2019.01.26
자율적 자기계발, 자기개발 스터디
꿈과 목표가 있는 청년들의 스터디 모임
하루의 끝, 집이 아닌 스터디가 생각나는 모임
꿈만 꾸기보다는 실천으로 옮기는 스터디 모임
혼자 공부하기 힘들 때, 같이 공부하는 분위기를 만들어가는 모임
어느 스터디도 시도하지 않는 새벽, 첫차 스터디 진행
1~2개월에 한번씩 열리는 정모
스터디 중간에 함께 하는 저녁 식사

단순 친목을 위한 가입 X
빠른년생 인정 X', default, 0, 50, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'jyeop93', '일러스트 공부 and 창작 모임', '일러스트 공부 and 창작 모임', '일러스트 공부 and 창작 모임 그림 공부와 개인의 창작활동을 하는 모임입니다.

혼자서 작업을 지속하시기 힘든 분들이나 그림공부를 추가적으로 하고 싶으신 분들끼리 모여서 서로 정보도 공유하고 동기부여도 받으면서 그림을 그려나갈 수 잇으면 좋겠다 싶어서 만든 모임이에요~

모집원 : 그림 전공 학생, 일러스트 작가 지망생, 현직 일러스트레이터 (그림 처음 접하시는 분 / 그림을 처음부터 배우기 위해 들어오시는 분은 받지 않습니다.)
나이 : 96 ~ 90년생까지
장소 : 강남역 스터디룸', default, 0, 20, '1', '0');

insert into tblStudy (studyNum, id, studyName, title, content, regdate, cnt, limit, del, notice)
values(studyNum_seq.nextval, 'zodixx5', '강남 자율 스터디', '강남 자율 스터디', '소규모 자율 스터디

주로 강남 스터디룸에서 진행합니다.

주 목적 : 공부, 자기개발, 독서

가벼운 친목활동(선택사항)

정기 스터디
일요일 오후 2시~6시

스터디 1달 이상 미참여시 강퇴

스터디 당일 취소(피치 못할 이유 제외), 무단 잠수시 강퇴', default, 0, 25, '1', '0');

-- ================================================ 
-- tblStudyGroup

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'baeabae00', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 2, 'zodixx5', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 3, 'jyeop93', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 4, 'watsupz012', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 5, 'gjswjd901', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 6, 'minsang564', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 7, 'jyeon96', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 8, 'whdhgj134', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 9, 'muruea233', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 10, 'bighi700', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 11, 'bin1764', 3, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'alc1548', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'bunny11', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'hoka87', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'alf54', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'lasdd', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'ehdtjd454', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'ukyung7', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'mimi00', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'minsang564', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'geenie92', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'bsbsbil22', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'zjusmn22', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'heeeeee9', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 1, 'ahsshksjd58', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 2, 'zey1548', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 2, 'zey1111', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 2, 'zey2222', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 3, 'zey3333', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 3, 'zey4444', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 3, 'zey5555', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 4, 'zey6666', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 4, 'zey7777', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 4, 'zey8888', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 4, 'zey9999', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 4, 'zey0000', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 5, 'zey1234', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 5, 'zey1212', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 6, 'cey1548', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 6, 'cey1111', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 6, 'cey2222', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 6, 'cey3333', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 6, 'cey4444', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 7, 'cey5555', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 7, 'cey6666', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 7, 'cey7777', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 7, 'cey8888', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 7, 'cey9999', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 7, 'cey0000', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 8, 'cey1234', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 8, 'cey1212', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 8, 'dey1548', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 8, 'dey1111', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 8, 'dey2222', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 9, 'dey3333', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 9, 'dey4444', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 9, 'dey5555', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 9, 'dey6666', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 10, 'dey7777', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 10, 'dey8888', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 10, 'dey9999', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 10, 'dey0000', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 10, 'dey1234', 1, default);

insert into tblStudyGroup (studyGroupNum, studyNum, id, grade, del) 
values (studyGroupNum_seq.nextval, 10, 'dey1212', 1, default);

-- =================================================================
-- tblStudyComment

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 1, 'baeabae00', default, '안녕하세요~', default);

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 1, 'alc1548', default, '잘부탁드리겠습니다~', default);

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 1, 'bunny11', default, '중국어를 배우고 싶어왔습니다', default);

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 1, 'hoka87', default, '외국인과 대화할 수 있는 기회를 얻고 싶었는데 감사합니다', default);

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 1, 'alf54', default, '안녕하세요', default);

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 2, 'zodixx5', default, '반갑습니다', default);

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 2, 'zey1548', default, '잘부탁드리겠습니다', default);

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 2, 'zey1111', default, '하이', default);

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 2, 'zey2222', default, 'ㅎㅇ', default);

insert into tblStudyComment (StudyCommentNum, studyNum, id, regdate, content, del)
values (StudyCommentNum_seq.nextval, 2, 'zey0000', default, 'ㅎㅇ', default);

-- ================================================================
-- tblStudyCalendar

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-05-04', '2019-05-04', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-05-02', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-05-11', '2019-05-11', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-05-09', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-05-18', '2019-05-18', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-05-016', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-05-25', '2019-05-25', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-05-23', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-06-01', '2019-06-01', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-05-30', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-06-08', '2019-06-08', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-06-06', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-06-15', '2019-06-15', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-06-13', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-06-22', '2019-06-22', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-06-20', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-06-29', '2019-06-29', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-06-27', default);


insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-07-06', '2019-07-06', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-07-04', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-07-13', '2019-07-13', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-07-11', default);

insert into tblStudyCalendar (studyCalendarNum, studyNum, id, title, content, begin, end, kind, del, place, lat, lng, regdate, cnt)
values (studyCalendarNum_seq.nextval, 1, 'baeabae00', '스터디정모', '중국어 회화하기
시간 :: 토요일 오후 3시~5시', '2019-07-20', '2019-07-20', '스터디', default, '공간더하기', '37.498925120868606', '127.028222241074', '2019-07-18', default);

-- =========================================================
-- tblAttend

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'baeabae00');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'alc1548');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'bunny11');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'hoka87');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'alf54');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'lasdd');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'ehdtjd454');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'ukyung7');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'mimi00');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'minsang564');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 13, 'zjusmn22');


insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'baeabae00');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'alc12548');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'bunny1212');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'hoka87');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'alf54');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'lasdd');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'ehdtjd454');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'ukyung7');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'mimi00');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'minsang564');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 12, 'zjusmn22');


insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'baeabae00');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'alc11548');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'bunny1111');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'hoka87');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'alf54');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'lasdd');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'ehdtjd454');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'ukyung7');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'mimi00');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'minsang564');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 11, 'zjusmn22');


insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'baeabae00');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'alc10548');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'bunny1010');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'hoka87');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'alf54');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'lasdd');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'ehdtjd454');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'ukyung7');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'mimi00');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'minsang564');

insert into tblAttend (studyAttendNum, studyCalendarNum, id)
values (studyAttendNum_seq.nextval, 10, 'zjusmn22');

-- ======================================================================
-- tblStudyReview


insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'alc1548', 1, '너무 좋아요', '지금까지 한 스터디중에 가장 좋았습니다~ 계속 참여할게요', '2019-06-01', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'alf54', 1, '잘맞고 좋네요', '스터디원끼리 마음도 잘맞고 좋아요~', '2019-06-02', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'ehdtjd454', 1, '회화 도움이 정말 많이 됬습니다', '혼자하는것보다 훨씬 좋습니다', '2019-06-05', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'mimi00', 1, '외국인과 소통할수 있어 좋았어요', '중국인과 실질적으로 대화하면서 많이 성장했습니다', '2019-06-07', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'geenie92', 1, '중국어에 자신감이 생겼습니다', '혼자하던때보다 훨씬 늘었어요', '2019-06-08', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'bsbsbil22', 1, '중국어? 그까짓것', '정말 껌이됬습니다', '2019-06-10', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'zjusmn22', 1, '자신감이 생겼습니다', '중국어에 대한 자신감이 생겼습니다', '2019-06-11', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'ahsshksjd58', 1, '중국? 가지마세요 한국에서 하세요', '스터디를 들고 난후 중국을 가지 않아도 충분히 할 수 있다는것을 깨달았습니다', '2019-06-15', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'heeeeee9', 1, '중국 가깝지만 먼나라... 스터디로 와서 간접체험 할수 있었습니다.', '스터디에 중국인들이 있다보니 간접적으로나마 대화를 통하여 중국에 대해 많이 알수 있었고 회화 실력도 향상됬습니다.', '2019-06-17', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'lasdd', 1, '외국어 자신감이 붙었습니다', '스터디에서 회화를 통해 중국어 실력이 늘다보니 외국어에대한 자신감이 붙었습니다.', '2019-06-24', default, default, default);

insert into tblStudyReview (studyReviewNum, id, studyNum, title, content, regdate, cnt, del, notice)
values (studyReviewNum_seq.nextval, 'hoka87', 1, '혼자하지마세요 같이해요', '같이하니까 동기부여도 되고 정말 좋았습니다.', '2019-06-25', default, default, default);

-- =====================================================
-- tblStudyReviewComment

insert into tblStudyReviewComment (studyReviewCommentNum, studyReviewNum, id, content, regdate, del)
values (studyReviewCommentNum_seq.nextval, 11, 'minsang564', '다음번엔 저희랑도 같이해요~', '2019-06-07', default);

insert into tblStudyReviewComment (studyReviewCommentNum, studyReviewNum, id, content, regdate, del)
values (studyReviewCommentNum_seq.nextval, 11, 'gjswjd901', '어떤식으로 진행하는지 구체적으로 알수 있을까요?', '2019-06-07', default);

insert into tblStudyReviewComment (studyReviewCommentNum, studyReviewNum, id, content, regdate, del)
values (studyReviewCommentNum_seq.nextval, 11, 'watsupz012', '굿', '2019-06-08', default);

insert into tblStudyReviewComment (studyReviewCommentNum, studyReviewNum, id, content, regdate, del)
values (studyReviewCommentNum_seq.nextval, 11, 'zodixx5', '좋아요~', '2019-06-08', default);

insert into tblStudyReviewComment (studyReviewCommentNum, studyReviewNum, id, content, regdate, del)
values (studyReviewCommentNum_seq.nextval, 11, 'jyeop93', '댓글냠냠', '2019-06-09', default);

-- ============================================
-- tblStudyBoard


insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'baeabae00', '많이 참석해주셔서 감사합니다', '자유글', '생각보다 많은 인원들이 참여하여 좋았습니다', '2019-06-11', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'alc1548', '안녕하세요', '가입인사', '잘부탁드립니다~', '2019-06-12', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'hoka87', '스터디원 너무좋아요', '자유글', '앞으로도 이대로만~', '2019-06-13', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'bunny11', '하이', '가입인사', '첨 뵈요', '2019-06-14', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'alf54', '아~령하세요~', '가입인사', '아~령하세요~~~ 반갑습니다', '2019-06-15', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'lasdd', '다음 정모 빨리 하고싶어요', '자유글', '너무너무 좋아요', '2019-06-16', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'ehdtjd454', '스터디원이 더욱 늘었으면...', '자유글', '다양한 사람들이 더 왔으면 좋겠습니다', '2019-06-16', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'ukyung7', '주변에 추천하고있습니다!', '자유글', '너무 좋아서 주변에 추천하고 있어요!!!', '2019-06-17', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'mimi00', '공부하기 정말 좋네요', '스터디', '회화 실력이 쑥쑥!', '2019-06-18', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'geenie92', '하이', '가입인사', '하이', '2019-06-21', default, default, default);

insert into tblStudyBoard (studyBoardNum, studyNum, id, title, kind, content, regdate, cnt, del, notice)
values (studyBoardNum_seq.nextval, 1, 'minsang564', '프로젝트 생각하실분 계신가요?', '프로젝트', '저희끼리 모여서 중국회화에 관해 더 좋은 방향으로 이끌수 있는 프로젝트를 하나 만들고 싶은데 같이 하실분 계신가요?', '2019-06-25', default, default, default);


-- =========================================
-- tblStudyBoardComment

insert into tblStudyBoardComment (studyBoardCommentNum, studyBoardNum, id, content, regdate, del)
values (studyBoardCommentNum_seq.nextval, 11, 'zodixx5', '좋다좋다~', '2019-06-25', default);

insert into tblStudyBoardComment (studyBoardCommentNum, studyBoardNum, id, content, regdate, del)
values (studyBoardCommentNum_seq.nextval, 11, 'bighi700', '참여하고싶습니다', '2019-06-25', default);

insert into tblStudyBoardComment (studyBoardCommentNum, studyBoardNum, id, content, regdate, del)
values (studyBoardCommentNum_seq.nextval, 11, 'honbaad', '구체적인 계획이 있나요?', '2019-06-25', default);

insert into tblStudyBoardComment (studyBoardCommentNum, studyBoardNum, id, content, regdate, del)
values (studyBoardCommentNum_seq.nextval, 11, 'chulll2', '음...잘하고 있어!', '2019-06-25', default);

insert into tblStudyBoardComment (studyBoardCommentNum, studyBoardNum, id, content, regdate, del)
values (studyBoardCommentNum_seq.nextval, 11, 'jyeon96', '어떤식으로 진행할지 궁금합니다!', '2019-06-25', default);






commit;

select * from tblStudyCalendar;
select * from tblStudy;
select * from tblMember;
select * from tblStudyGroup where studynum = 1;
select * from tblStudyComment;
select * from tblStudyBoard;