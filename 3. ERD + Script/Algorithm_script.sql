
-- 알고리즘 문제
CREATE TABLE tblquestion(
    seq             NUMBER          PRIMARY KEY,  -- 문제 번호
    id              VARCHAR2(30)    NOT NULL REFERENCES tblMember(id) ON DELETE CASCADE,  --아이디
    questionname    VARCHAR2(4000)  NOT NULL,   -- 문제 이름
    questioncontent VARCHAR2(4000)  NOT NULL, -- 문제 내용
    input           VARCHAR2(4000)  NULL,  -- 입력란
    output          VARCHAR2(4000)  NOT NULL,  -- 출력란
    ex              VARCHAR2(4000)  NOT NULL,  -- 예제
    sourceid        VARCHAR2(30)    NOT NULL REFERENCES tblMember(id) ON DELETE CASCADE,  -- 출처
    clsfc           VARCHAR2(1)     NOT NULL CHECK(clsfc IN (0, 1)), -- 분류
    language       VARCHAR2(1)     NOT NULL CHECK(LANGUAGE IN (0, 1)), -- 다국어
    status          NUMBER          DEFAULT 1 NOT NULL  -- 상태
);



-- 알고리즘 제출
CREATE TABLE tblsubmission ( 
    seq             NUMBER          PRIMARY KEY,   -- 번호
    questionnum     NUMBER          NOT NULL REFERENCES tblquestion(seq) ON DELETE CASCADE,   -- 문제번호
    ID              VARCHAR2(30)    NOT NULL REFERENCES tblMember(id) ON DELETE CASCADE,     -- 아이디 참조
    languagetype    VARCHAR2(30)    NOT NULL,   -- 언어타입(사용언어)
    submitcode      VARCHAR2(4000)  NOT NULL,   -- 제출코드
    regdate         DATE            DEFAULT sysdate NOT NULL, -- 제출일
    RESULT         VARCHAR2(1)     NOT NULL CHECK(RESULT IN (0, 1)),   -- 정답 여부 1:정답 0:틀림
    status          NUMBER          DEFAULT 1 NOT NULL  -- 상태
);


-- 알고리즘 풀이
CREATE TABLE tblqsolving (
    seq             NUMBER          PRIMARY KEY,  -- 번호
    codeused        VARCHAR2(4000)  NOT NULL,  -- 코드소스
    languageused    VARCHAR2(30)    NOT NULL,  -- 사용 언어
    regdate         DATE            DEFAULT sysdate NOT NULL, -- 등록일
    ID              VARCHAR2(30)    NOT NULL REFERENCES tblMember(id) ON DELETE CASCADE,  -- 아이디
    algorithmnum    NUMBER          NOT NULL REFERENCES tblquestion(seq) ON DELETE CASCADE, --문제번호
    status          NUMBER          DEFAULT 1 NOT NULL  -- 상태
);



-- 알고리즘 동영상
CREATE TABLE tblyoutube (
    seq         NUMBER          PRIMARY KEY , -- 동영상번호
    title       VARCHAR2(100)   NOT NULL,  -- 이름
    ID          VARCHAR2(30)    NOT NULL    REFERENCES tblMember(id) ON DELETE CASCADE, -- 아이디참조
    viewcnt     NUMBER          DEFAULT 0   NOT NULL,  -- 조회수
    regdate     DATE            DEFAULT     sysdate NOT NULL,   -- 등록일
    youtubeurl  VARCHAR2(500)   NOT NULL,   -- 링크주소 
    pic         VARCHAR2(50)    DEFAULT     'nopic.png' NOT NULL,
    status      NUMBER          DEFAULT 1   NOT NULL  -- 상태
);


-- 알고리즘 동영상 댓글
CREATE TABLE tblyoucomment (
    seq         NUMBER          PRIMARY KEY, --댓글 번호(PK)
    content     VARCHAR2(4000) NOT NULL,  -- 댓글 내용
    id          VARCHAR2(30)    NOT NULL REFERENCES tblMember(id) ON DELETE CASCADE, -- 댓글아이디
    regdate     DATE DEFAULT    sysdate NOT NULL, --작성 시각
    youtubenum  NUMBER          NOT NULL REFERENCES tblyoutube(seq) ON DELETE CASCADE,   -- 동영상 번호
    status      NUMBER DEFAULT 1 NOT NULL  -- 상태
);


-- 알고리즘 문제연결 동영상
CREATE TABLE tbllinkedyou (
    questionnum         NUMBER NOT NULL REFERENCES tblquestion(seq) ON DELETE CASCADE,  --문제번호
    youtubenum          NUMBER NOT NULL REFERENCES tblyoutube(seq)  ON DELETE CASCADE, -- 동영상번호
    status              NUMBER DEFAULT 1 NOT NULL  -- 상태
);





--------------------------------------------------------------------------------------------------------------------------------
-- 뷰 테이블
--------------------------------------------------------------------------------------------------------------------------------

-- 문제 리스트 조인
-- 첫번째 조인
CREATE OR REPLACE VIEW TEMP AS
SELECT 
    QUESTION.SEQ AS SEQ,
    SUBMIT.QUESTIONNUM AS QUESTIONNUM,
    QUESTION.QUESTIONNAME AS QUESTIONNAME,
    QUESTION.SOURCEID AS SOURCEID,
    QUESTION.LANGUAGE AS LANGUAGE,
    SUBMIT.id as id,
    SUBMIT.QUESTIONNUM AS SUBNUM,
    SUBMIT.LANGUAGETYPE AS TYPE,
    SUBMIT.RESULT AS RESULT
    FROM TBLQUESTION QUESTION
        LEFT OUTER JOIN TBLSUBMISSION SUBMIT
            ON (QUESTION.SEQ = SUBMIT.QUESTIONNUM);

-- 두번째 

CREATE OR REPLACE VIEW VWTEMP AS
    SELECT 
        SEQ,
        COUNT(*) AS TOTALCNT, 
        (SELECT COUNT(*) FROM TEMP WHERE TEMP.RESULT = 1 AND TEMP.SEQ = T.SEQ) AS CORRECT 
            FROM TEMP T 
                GROUP BY T.SEQ;



-- 세번째
-- 문제 번호, 총 제출개수, 맞은 개수, 정답률
CREATE OR REPLACE VIEW VWALL AS
    SELECT 
        SEQ AS S, 
        A.TOTALCNT, 
        A.CORRECT, 
        ROUND(A.CORRECT / A.TOTALCNT * 100,2)AS PER 
            FROM VWTEMP A;

-- 조인(네번째)
       
CREATE OR REPLACE VIEW VWJOINQUESTION AS
SELECT 
    QUESTION.SEQ AS SEQ,
    QUESTION.QUESTIONNAME AS QUESTIONNAME,
    QUESTION.SOURCEID AS SOURCEID,
    QUESTION.LANGUAGE AS LANGUAGE,
    ALLCNT.TOTALCNT AS TOTALCNT,
    ALLCNT.CORRECT AS CORRECT,
    ALLCNT.PER AS PER    
        FROM TBLQUESTION QUESTION, VWALL ALLCNT
            WHERE QUESTION.SEQ = ALLCNT.S;
            

-- 문제 리스트 번호 RNUM(다섯번째)
CREATE OR REPLACE VIEW JOINQUESTION AS
SELECT * FROM
(SELECT ROWNUM AS RNUM, V.* FROM VWJOINQUESTION V);


--------------------------------------------------------------------------------------------------------------------------------

-- 풀이 리스트 조인
CREATE OR REPLACE VIEW VWSOLVINGLIST AS
        SELECT
            S.SEQ, 
            S.CODEUSED,
            S.LANGUAGEUSED, 
            S.ID, S.REGDATE, 
            S.ALGORITHMNUM,
            S.STATUS,
            Q.QUESTIONNAME
                FROM TBLQSOLVING S
                    INNER JOIN TBLQUESTION Q
                        ON S.ALGORITHMNUM = Q.SEQ;



CREATE OR REPLACE VIEW JOINSOLVING AS
        SELECT 
            ROWNUM AS RNUM,A.*
                FROM VWSOLVINGLIST A;
    

CREATE OR REPLACE VIEW SOLVINGLIST AS
        SELECT 
            J.RNUM AS QUESTIONLISTRNUM, 
            R.* 
            FROM JOINSOLVING R
                INNER JOIN JOINQUESTION J
                    ON R.ALGORITHMNUM = J.SEQ;
                    
--------------------------------------------------------------------------------------------------------------------------------

---- 채점 조인


-- 첫번째 조인
CREATE OR REPLACE VIEW vwresultlist AS
    SELECT 
            q.seq, 
            s.id, 
            s.languagetype, 
            s.result, 
            s.regdate 
    FROM tblquestion q
        INNER JOIN tblsubmission S
            ON q.seq = S.questionnum;


-- 두번째 조인
CREATE OR REPLACE VIEW resultlist AS
    SELECT 
        ROWNUM AS resultrnum,
        T.* 
        FROM 
        (SELECT 
            jq.rnum,
            jq.seq, 
            vl.id, 
            vl.languagetype, 
            vl.result, 
            vl.regdate 
        from vwresultlist vl
            INNER JOIN joinquestion jq
                ON jq.seq = vl.seq)T ORDER BY resultrnum DESC;
        
--------------------------------------------------------------------------------------------------------------------------------

-- 랭킹 리스트
-- 첫번째 
           
CREATE OR REPLACE VIEW RTEMP AS
    SELECT
        TI.ID AS ID,
        TI.status AS MS,
        TS.RESULT AS RS,
        TS.SEQ AS SEQ
            FROM TBLSUBMISSION TS
                INNER JOIN TBLMEMBER TI
                    ON (TS.ID = TI.ID);


-- 두번째
CREATE OR REPLACE VIEW STEMP AS
    SELECT ID AS ID,COUNT(ID) AS TOTAL, SUM(RS) AS CORRECT, (COUNT(ID) - SUM(RS))AS SUB, ROUND(SUM(RS) / COUNT(ID) * 100, 2) AS PER  FROM RTEMP GROUP BY ID;
    
-- 세번째 
CREATE OR REPLACE VIEW FINALRANK AS
    SELECT 
        ROWNUM AS RNUM,
        TI.ID,
        TI.STATUS AS MS,
        ST.TOTAL,
        ST.CORRECT,
        ST.SUB,
        ST.PER
            FROM STEMP ST
                INNER JOIN TBLMEMBER TI
                    ON (ST.ID = TI.ID);


-- 완전 마지막 !
CREATE OR REPLACE VIEW FINALRANKEND AS
SELECT ROWNUM AS RNUM2, A.* FROM (SELECT * FROM FINALRANK ORDER BY TOTAL DESC)A;



COMMIT;
-- 시퀀스

CREATE SEQUENCE QUESTION_SEQ;
CREATE SEQUENCE qsolving_seq;
CREATE SEQUENCE submission_seq;
CREATE SEQUENCE youtube_seq;
CREATE SEQUENCE youcomment_seq;

-- ================================================================ 생성
-- 실 데이터

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO tblquestion (seq,ID,questionname,questioncontent,INPUT,output,ex,sourceid,clsfc,LANGUAGE,status)
    VALUES(question_seq.NEXTVAL, 'hey1212'
            ,'수열 구하기','P[0], P[1], ...., P[N-1]은 0부터 N-1까지(포함)의 수를 한 번씩 포함하고 있는 수열이다. 수열 P를 길이가 N인 배열 A에 적용하면 길이가 N인 배열 B가 된다. 적용하는 방법은 B[P[i]] = A[i]이다.배열 A가 주어졌을 때, 수열 P를 적용한 결과가 비내림차순이 되는 수열을 찾는 프로그램을 작성하시오. 비내림차순이란, 각각의 원소가 바로 앞에 있는 원소보다 크거나 같을 경우를 말한다. 만약 그러한 수열이 여러개라면 사전순으로 앞서는 것을 출력한다.'
            , '첫째 줄에 배열 A의 크기 N이 주어진다. 둘째 줄에는 배열 A의 원소가 0번부터 차례대로 주어진다. N은 50보다 작거나 같은 자연수이고, 배열의 원소는 1,000보다 작거나 같은 자연수이다.'
            , '첫째 줄에 비내림차순으로 만드는 수열 P를 출력한다.'
            , '1 2 0'
            , 'hey1212'
            , '0'
            , '1', DEFAULT);

SELECT * FROM tblquestion;
INSERT INTO tblquestion (seq,id,questionname,questioncontent,input,output,ex,sourceid,clsfc,language,status)
    VALUES(question_seq.NEXTVAL, 'ley4444'
            ,'벡터 매칭','평면 상에 N개의 점이 찍혀있고, 그 점을 집합 P라고 하자. 집합 P의 벡터 매칭은 벡터의 집합인데, 모든 벡터는 집합 P의 한 점에서 시작해서, 또 다른 점에서 끝나는 벡터의 집합이다. 또, P에 속하는 모든 점은 한 번씩 쓰여야 한다.'
            , '첫째 줄에 테스트 케이스의 개수 T가 주어진다. 각 테스트 케이스는 다음과 같이 구성되어있다.'
            , '각 테스트 케이스마다 정답을 출력한다. 절대/상대 오차는 10-6까지 허용한다.'
            , '0.000000000000
282842.712474619038'
            , 'ley4444'
            , '0'
            , '1', DEFAULT);
            
INSERT INTO tblquestion (seq,ID,questionname,questioncontent,INPUT,output,ex,sourceid,clsfc,LANGUAGE,status)
    VALUES(question_seq.NEXTVAL, 'hey0000'
            ,'분산 처리','재용이는 최신 컴퓨터 10대를 가지고 있다. 어느 날 재용이는 많은 데이터를 처리해야 될 일이 생겨서 각 컴퓨터에 1번부터 10번까지의 번호를 부여하고, 10대의 컴퓨터가 다음과 같은 방법으로 데이터들을 처리하기로 하였다.'
            , '입력의 첫 줄에는 테스트 케이스의 개수 T가 주어진다. 그 다음 줄부터 각각의 테스트 케이스에 대해 정수 a와 b가 주어진다. (1 ≤ a < 100, 1 ≤ b < 1,000,000)'
            , '각 테스트 케이스에 대해 마지막 데이터가 처리되는 컴퓨터의 번호를 출력한다.'
            , '1 2 0'
            , 'hey0000'
            , '0'
            , '1', DEFAULT);
            
INSERT INTO tblquestion (seq,ID,questionname,questioncontent,INPUT,output,ex,sourceid,clsfc,LANGUAGE,status)
    VALUES(question_seq.NEXTVAL, 'cey3333'
            ,'분산 처리','지민이는 N개의 원소를 포함하고 있는 양방향 순환 큐를 가지고 있다. 지민이는 이 큐에서 몇 개의 원소를 뽑아내려고 한다. 지민이는 이 큐에서 다음과 같은 3가지 연산을 수행할 수 있다.'
            , '첫째 줄에 큐의 크기 N과 뽑아내려고 하는 수의 개수 M이 주어진다. N은 50보다 작거나 같은 자연수이고, M은 N보다 작거나 같은 자연수이다. 둘째 줄에는 지민이가 뽑아내려고 하는 수의 위치가 순서대로 주어진다. 위치는 1보다 크거나 같고, N보다 작거나 같은 자연수이다.'
            , '각 테스트 케이스에 대해 마지막 데이터가 처리되는 컴퓨터의 번호를 출력한다.'
            , '10 3
1 2 3'
            , 'cey3333'
            , '0'
            , '1', DEFAULT);
            
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------            

-- 풀이


INSERT INTO tblqsolving (seq, codeused, languageused, regdate, ID, algorithmnum,status)
    VALUES(qsolving_seq.NEXTVAL, 'int main(){
    int t;	
    for(scanf("%d",&t);t;--t){
        Point p;
        ans=INF;
        scanf("%d",&n);
        for(int i=1;i<=n;++i){
            scanf("%d%d",&point[i].x,&point[i].y);
        }
        dfs(0,p,n>>1);
        printf("%.6lf\n",sqrt(ans));
    }
}', '1', TO_DATE('2021-07-05','YYYY-MM-DD'), 'whdhgj134', 1, '1');



--===================================================================== 삽입



DROP SEQUENCE youcomment_seq;
DROP SEQUENCE question_seq;
DROP SEQUENCE qsolving_seq;
DROP SEQUENCE submission_seq;
drop sequence youtube_seq;


DROP TABLE tbllinkedyou;
DROP TABLE tblyoucomment;
DROP TABLE tblyoutube;
DROP TABLE tblsubmission;
DROP TABLE tblqsolving;
DROP TABLE tblquestion;




GRANT CONNECT, dba, RESOURCE TO web;


COMMIT;
