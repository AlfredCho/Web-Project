--회원 테이블
create table tblMember (
    id varchar2(30) primary key, --아이디
    name varchar2(20) not null, --이름
    pw varchar2(20) not null, --비밀번호
    birth date not null, --생년월일
    email varchar2(40) not null, --이메일
    grade varchar2(5) default 1 not null, --등급(관리자, 학생 구분용)
    status varchar2(4000) null, --상태 메시지
    address varchar2(100) not null, --주소
    del varchar2(5) default 1 not null --삭제여부
);

-- 채용공고 게시판 테이블
create table tblJobBoard (
    seq number primary key,
    title varchar2(500) not null,
    content varchar2(1000) not null,
    registerdate date default sysdate not null, -- 작성시간
    dldate date default sysdate not null, -- 마감일
    writer varchar2(30) not null REFERENCES tblMember(id), -- 아이디
    del varchar2(5) default 1 not null, --삭제여부
    grade varchar2(5) default 1 not null, --일반글, 공지글
    lat varchar2(100) default null,
    lng varchar2(100) default null
);

--채용 게시판 댓글
create table tblJobBoardComment (
    seq number primary key,
    content varchar2(1000) not null,
    registerdate date default sysdate not null,
    writer varchar2(30) not null REFERENCES tblMember(id),
    del varchar2(5) default 1 not null, --삭제여부
    jobboard_seq number not null references tblJobBoard(seq)
);

create sequence tblJobBoard_seq; -- 채용공고 시퀀스
create sequence jobboardcomment_seq; -- 채용 게시판 시퀀스

-- ======================================== 생성

drop table tblJobBoardComment;
drop table tblJobBoard;
drop table tblMember;

drop sequence tblJobBoard_seq;
drop sequence jobboardcomment_seq;

-- ======================================== 삭제

insert into tblMember (id, name, pw, birth, email, grade, status, address, del) values ('admin', '관리자', 1111, '19/07/10', 'gdog700@naver.com', 2, null, '06235 서울 강남구 테헤란로132', default);
select name, id, email, birth, grade from tblMember where grade = 1;

--회원 더미 데이터
insert into tblMember values('alc1548', '김기훈', '1234', '1989-12-03', 'alc1548@naver.com', '1', '기후니입니당', '구미','1');
insert into tblMember values('bunny11', '이다현', '1234', '1992-01-09', 'bunny11@naver.com', '1', '서울살아용', '서울','1');
insert into tblMember values('hoka87', '유병현', '1234', '1981-10-25', 'hoka87@gmail.com', '1', '프로젝트', '부산','1');
insert into tblMember values('alf54', '이예찬', '1234', '1993-08-12', 'alf54@naver.com', '1', '너무시러', '대구','1');
insert into tblMember values('lasdd', '안상현', '1234', '1997-06-23', 'lasdd@gmail.com', '1', '시간이없다', '포항','1');
insert into tblMember values('muruea233', '박준우', '1234', '1996-12-17', 'muruea233@hanmail.net', '1', '이력서는 언제넣지...', '스울','1');
insert into tblMember values('jyeop93', '양주엽', '1234', '1986-02-01', 'jyeop93@naver.com', '1', '알고리즘 꼴지..', '스울','1');
insert into tblMember values('baeabae00', '배세훈', '1234', '1999-10-29', 'baeabae00@naver.com', '1', '세후니에요', '스울','1');
insert into tblMember values('bin1764', '조성빈', '1234', '1985-09-18', 'bin1764@hanmail.net', '1', '어디사세요', '스울','1');
insert into tblMember values('zodixx5', '최다빈', '1234', '1979-11-05', 'zodixx5@gmail.com', '1', '이력서는 언제넣지...', '어디사세요','1');
insert into tblMember values('bighi700', '강부경', '1234', '1988-07-30', 'bighi700@naver.com', '1', '이력서는 언제넣지...', '스울','1');
insert into tblMember values('whdhgj134', '정우진', '1234', '1972-10-11', 'whdhgj134@naver.com', '1','이력서는 언제넣지...', '어디사세요','1');
insert into tblMember values('honbaad', '박세인', '1234', '1998-07-02', 'honbaad@naver.com', '1', '이력서는 언제넣지...', '스울','1');

insert into tblMember values('chulll2', '엄현철', '1234', '1995-12-03', 'alc1548@naver.com', '1','이력서는 언제넣지...', '구미','1');
insert into tblMember values('jyeon96', '안지연', '1234', '1986-01-09', 'bunny11@naver.com', '1', '어디사세요', '서울','1');
insert into tblMember values('ehdtjd454', '김동성', '1234', '1997-10-25', 'hoka87@gmail.com', '1', '아이고야!!', '부산','1');
insert into tblMember values('ukyung7', '설유경', '1234', '1978-08-12', 'alf54@naver.com', '1', '아이고야!!', '대구','1');
insert into tblMember values('mimi00', '김찬미', '1234', '1994-06-23', 'lasdd@gmail.com', '1', '어디사세요', '포항','1');
insert into tblMember values('minsang564', '이상민', '1234', '1991-12-17', 'muruea233@hanmail.net', '1', '멤버가 많다 성빈아..', '스울','1');
insert into tblMember values('geenie92', '정희진', '1234', '1992-02-01', 'jyeop93@naver.com', '1', '어디사세요', '스울','1');
insert into tblMember values('bsbsbil22', '조유나', '1234', '1994-10-29', 'baeabae00@naver.com', '1', '멤버가 많다 성빈아..', '스울','1');
insert into tblMember values('gjswjd901', '박헌정', '1234', '1993-09-18', 'bin1764@hanmail.net', '1','어디사세요', '스울','1');
insert into tblMember values('zjusmn22', '김병준', '1234', '1997-11-05', 'zodixx5@gmail.com', '1', '멤버가 많다 성빈아..', '스울','1');
insert into tblMember values('heeeeee9', '차민희', '1234', '1999-07-30', 'bighi700@naver.com', '1', '멤버가 많다 성빈아..', '스울','1');
insert into tblMember values('ahsshksjd58', '김정아', '1234', '1990-10-11', 'whdhgj134@naver.com', '1', '멤버가 많다 성빈아..', '스울','1');
insert into tblMember values('watsupz012', '유성진', '1234', '1995-07-02', 'honbaad@naver.com', '1', '멤버가 많다 성빈아..', '스울','1');

insert into tblMember values('zey1548', '세훈', '1234', '1994-04-03', '1234@naver.com', '1', '멤버가 많다 성빈아..', '구미','1');
insert into tblMember values('zey1111', '훈세', '1234', '1994-05-03', '5678@naver.com', '1', '메시지가 없습니다.', '서울','1');
insert into tblMember values('zey2222', '배세', '1234', '1994-06-03', '9101@naver.com', '1', '수료가 얼마 안남았당', '부산','1');
insert into tblMember values('zey3333', '개세', '1234', '1994-07-03', '1121@naver.com', '1', '수료가 얼마 안남았당', '대구','1');
insert into tblMember values('zey4444', '훈이', '1234', '1994-08-03', '3141@naver.com', '1', '메시지가 없습니다.', '포항','1');
insert into tblMember values('zey5555', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1','이력서는 언제넣지...', '스울','1');
insert into tblMember values('zey6666', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '메시지가 없습니다.', '스울','1');
insert into tblMember values('zey7777', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '수료가 얼마 안남았당', '스울','1');
insert into tblMember values('zey8888', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '메시지가 없습니다.', '스울','1');
insert into tblMember values('zey9999', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '이력서는 언제넣지...', '스울','1');
insert into tblMember values('zey0000', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '메시지가 없습니다.', '스울','1');
insert into tblMember values('zey1234', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '수료가 얼마 안남았당', '스울','1');
insert into tblMember values('zey1212', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '메시지가 없습니다.', '스울','1');

insert into tblMember values('cey1548', '세훈', '1234', '1994-04-03', '1234@naver.com', '1', '이력서는 언제넣지...', '구미','1');
insert into tblMember values('cey1111', '훈세', '1234', '1994-05-03', '5678@naver.com', '1', '아이고야!!', '서울','1');
insert into tblMember values('cey2222', '배세', '1234', '1994-06-03', '9101@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '부산','1');
insert into tblMember values('cey3333', '개세', '1234', '1994-07-03', '1121@naver.com', '1', '메시지가 없습니다.', '대구','1');
insert into tblMember values('cey4444', '훈이', '1234', '1994-08-03', '3141@naver.com', '1', '아이고야!!', '포항','1');
insert into tblMember values('cey5555', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '멤버가 많다 성빈아..', '스울','1');
insert into tblMember values('cey6666', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '메시지가 없습니다.', '스울','1');
insert into tblMember values('cey7777', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '메시지가 없습니다.', '스울','1');
insert into tblMember values('cey8888', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '멤버가 많다 성빈아..', '스울','1');
insert into tblMember values('cey9999', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1','메시지가 없습니다.', '스울','1');
insert into tblMember values('cey0000', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '메시지가 없습니다.', '스울','1');
insert into tblMember values('cey1234', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '멤버가 많다 성빈아..', '스울','1');
insert into tblMember values('cey1212', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '메시지가 없습니다.', '스울','1');

insert into tblMember values('dey1548', '세훈', '1234', '1994-04-03', '1234@naver.com', '1', 'Ajax 아세요 ??', '구미','1');
insert into tblMember values('dey1111', '훈세', '1234', '1994-05-03', '5678@naver.com', '1', '메시지가 없습니다.', '서울','1');
insert into tblMember values('dey2222', '배세', '1234', '1994-06-03', '9101@naver.com', '1', '수료가 얼마 안남았당', '부산','1');
insert into tblMember values('dey3333', '개세', '1234', '1994-07-03', '1121@naver.com', '1', 'Ajax 아세요 ??', '대구','1');
insert into tblMember values('dey4444', '훈이', '1234', '1994-08-03', '3141@naver.com', '1', '메시지가 없습니다.', '포항','1');
insert into tblMember values('dey5555', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', 'Ajax 아세요 ??', '스울','1');
insert into tblMember values('dey6666', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('dey7777', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('dey8888', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('dey9999', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', 'Ajax 아세요 ??', '스울','1');
insert into tblMember values('dey0000', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '수료가 얼마 안남았당', '스울','1');
insert into tblMember values('dey1234', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '수료가 얼마 안남았당', '스울','1');
insert into tblMember values('dey1212', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', 'Ajax 아세요 ??', '스울','1');

insert into tblMember values('ey1548', '세훈', '1234', '1994-04-03', '1234@naver.com', '1', 'Ajax 아세요 ??', '구미','1');
insert into tblMember values('ey1111', '훈세', '1234', '1994-05-03', '5678@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '서울','1');
insert into tblMember values('ey2222', '배세', '1234', '1994-06-03', '9101@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '부산','1');
insert into tblMember values('ey3333', '개세', '1234', '1994-07-03', '1121@naver.com', '1', 'Ajax 아세요 ??', '대구','1');
insert into tblMember values('ey4444', '훈이', '1234', '1994-08-03', '3141@naver.com', '1', '수료가 얼마 안남았당', '포항','1');
insert into tblMember values('ey5555', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('ey6666', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('ey7777', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', 'Ajax 아세요 ??', '스울','1');
insert into tblMember values('ey8888', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', 'Ajax 아세요 ??', '스울','1');
insert into tblMember values('ey9999', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '수료가 얼마 안남았당', '스울','1');
insert into tblMember values('ey0000', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '수료가 얼마 안남았당', '스울','1');
insert into tblMember values('ey1234', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '아이고야!!', '스울','1');
insert into tblMember values('ey1212', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '수료가 얼마 안남았당', '스울','1');

insert into tblMember values('hey1548', '세훈', '1234', '1994-04-03', '1234@naver.com', '1', '순대국 순대국 순대구 !', '구미','1');
insert into tblMember values('hey1111', '훈세', '1234', '1994-05-03', '5678@naver.com', '1', '순대국 순대국 순대구 !', '서울','1');
insert into tblMember values('hey2222', '배세', '1234', '1994-06-03', '9101@naver.com', '1', '순대국 순대국 순대구 !', '부산','1');
insert into tblMember values('hey3333', '개세', '1234', '1994-07-03', '1121@naver.com', '1', '아이고야!!', '대구','1');
insert into tblMember values('hey4444', '훈이', '1234', '1994-08-03', '3141@naver.com', '1','순대국 순대국 순대구 !', '포항','1');
insert into tblMember values('hey5555', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1','순대국 순대국 순대구 !', '스울','1');
insert into tblMember values('hey6666', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '순대국 순대국 순대구 !', '스울','1');
insert into tblMember values('hey7777', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1','순대국 순대국 순대구 !', '스울','1');
insert into tblMember values('hey8888', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '아이고야!!', '스울','1');
insert into tblMember values('hey9999', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '순대국 순대국 순대구 !', '스울','1');
insert into tblMember values('hey0000', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('hey1234', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('hey1212', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '아이고야!!', '스울','1');

insert into tblMember values('ley1548', '세훈', '1234', '1994-04-03', '1234@naver.com', '1', '순대국 순대국 순대구 !', '구미','1');
insert into tblMember values('ley1111', '훈세', '1234', '1994-05-03', '5678@naver.com', '1', '아이고야!!', '서울','1');
insert into tblMember values('ley2222', '배세', '1234', '1994-06-03', '9101@naver.com', '1', '김치찌개!', '부산','1');
insert into tblMember values('ley3333', '개세', '1234', '1994-07-03', '1121@naver.com', '1', '아이고야!!', '대구','1');
insert into tblMember values('ley4444', '훈이', '1234', '1994-08-03', '3141@naver.com', '1', '순대국 순대국 순대구 !', '포항','1');
insert into tblMember values('ley5555', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('ley6666', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '김치찌개!', '스울','1');
insert into tblMember values('ley7777', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '아이고야!!', '스울','1');
insert into tblMember values('ley8888', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '김치찌개!', '스울','1');
insert into tblMember values('ley9999', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('ley0000', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '김치찌개!', '스울','1');
insert into tblMember values('ley1234', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '오늘의 점심메뉴 ! 두구두구두구두구', '스울','1');
insert into tblMember values('ley1212', '훈세버거', '1234', '1994-10-03', '3544@naver.com', '1', '아이고야!!', '스울','1');


commit;

