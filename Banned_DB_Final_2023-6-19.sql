if not exists (select * from sys.databases where name ='banned_app')

CREATE DATABASE banned_app

GO

use banned_app

GO

------------------------------------------------------------- DOWN
---FK8
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_challengeschallenge_cr_id')
        alter table challenges drop constraint fk_challenges_challenge_cr_id
--FK18
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_challenges_reasons_cr_challenge_id')
        alter table challenges_reasons drop constraint fk_challenges_reasons_cr_challenge_id
--FK9 -- This is in the data load
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_challenges_reasons_cr_reason_id')
        alter table challenges_reasons drop constraint fk_challenges_reasons_cr_reason_id
--FK3 - This is in the data load
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_authors_books_ab_book_id foreign key ')
        alter table authors_books drop constraint fk_authors_books_ab_book_id
--FK1 -- This is in the data load       
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_authors_books_ab_author_id ')
        alter table authors_books drop constraint fk_authors_books_ab_author_id 
--FK16
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_banned_apps_ba_user_id')
        alter table banned_apps drop constraint fk_banned_apps_ba_user_id
--FK5
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_banned_apps_ba_book_id')
        alter table banned_apps drop constraint fk_banned_apps_ba_book_id

--FK7
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_banned_apps_ba_challenge_id')
        alter table banned_apps drop constraint fk_banned_apps_ba_challenge_id

--FK17
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_banned_apps_ba_rating_id')
        alter table banned_apps drop constraint fk_banned_apps_ba_rating_id

drop table if exists banned_apps
--FK15

if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_users_user_level_id')
        alter table users drop constraint fk_users_user_level_id

drop table if exists users
drop table if exists user_levels
--FK14
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_ratings_rating_book_id')
        alter table ratings drop constraint fk_ratings_rating_book_id

--FK13
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_ratings_rating_rrd_id')
        alter table ratings drop constraint fk_ratings_rating_rrd_id

--FK12
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_ratings_review_descriptors_rrd_rating_id')
        alter table ratings_review_descriptors drop constraint fk_ratings_review_descriptors_rrd_rating_id

drop table if exists ratings

--FK11
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_ratings_review_descriptors_rrd_descriptor_id')
        alter table ratings_review_descriptors drop constraint fk_ratings_review_descriptors_rrd_descriptor_id

drop table if exists ratings_review_descriptors
drop table if exists review_descriptors

--FK10
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_challenges_challenge_book_id')
        alter table challenges drop constraint fk_challenges_challenge_book_id

drop table if exists books_challenges


--FK4
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_books_challenges_bc_book_id')
        alter table books_challenges drop constraint fk_books_challenges_bc_book_id

drop table if exists challenges

drop table if exists challenges_reasons
drop table if exists reasons
--FK2
if exists(select*from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        where CONSTRAINT_NAME = 'fk_books_book_author_id')
        alter table books drop constraint fk_books_book_author_id

drop table if exists authors_books
drop table if exists books
drop table if exists authors


-------------------------------------------------------------------------UP Metadata

create table authors(
    author_id char(6) not null, 
    author_firstname varchar(50) not null, 
    author_lastname varchar(50) not null, 
    author_ethnicity varchar(50) null, 
    author_birthdate date null,
    author_expiredate date NULL,
    author_age int NULL,
    author_homestate char(2) NULL, 
    author_homecountry varchar(50) NULL, 
    author_sexualorientation varchar(25) NULL
    constraint pk_authors_author_id PRIMARY KEY(author_id)
)

GO

create table books(
    book_id char(6) not null,
    book_title varchar(75) NOT NULL,
    book_author_id int NOT NULL,
    book_publication_year int NULL,
    book_series char(1) NULL default 'N',
    book_last_modification date NOT NULL
    constraint pk_books_book_id PRIMARY KEY(book_id)
)
GO 



create table authors_books(
    ab_id int not null,
    ab_author_id char(6) NOT NULL,
    ab_book_id char(6) NOT NULL,
    constraint pk_ab_id PRIMARY KEY(ab_id)
)
GO

----------------------------
--FK2
alter table books 
   add CONSTRAINT fk_books_book_author_id foreign key (book_author_id)
   REFERENCES authors_books (ab_id)
GO

create table reasons(
    reason_id int NOT NULL,
    reason_descriptor varchar(100) NOT NULL,
    reason_freq int NOT NULL 
    constraint pk_reason_id PRIMARY KEY(reason_id)
)
GO

create table challenges_reasons(
    cr_id int,
    cr_challenge_id char(6),
    cr_reason_id int
    constraint pk_cr_id PRIMARY KEY(cr_id)
)
GO


create table challenges(
    challenge_id char(6) NOT NULL,
    challenge_book_id char(6) NOT NULL,
    challenge_school_district varchar(50) NOT NULL,
    challenge_county varchar (50) NULL,
    challenge_state char(2) NOT NULL,
    challenge_last_modified date NOT NULL,
    challenge_book_status varchar(50) NOT NULL default 'Unknown', 
    constraint pk_challenges_challenge_id PRIMARY KEY(challenge_id)
)

GO


--FK10--------I'm not sure we need this, there's already a relationship made? I'm not sure. Leaving it here. 
alter table challenges
    add CONSTRAINT fk_challenges_challenge_book_id foreign key (challenge_book_id)
    REFERENCES books (book_id)

--GO




create table ratings(
    rating_id int not null,
    rating_book_id char(6) NOT NULL,
    rating_review_score int not null,
    rating_review_summary varchar(100) NOT NULL,
    constraint pk_rating_id PRIMARY KEY(rating_id)
)
GO


 

--FK14
alter table ratings
    add CONSTRAINT fk_ratings_rating_book_id foreign key (rating_book_id)
    REFERENCES books (book_id)

GO 
create table user_levels(
    user_level_id int NOT NULL, 
    user_level_name varchar(20) NOT NULL,
    constraint pk_user_level_id PRIMARY KEY(user_level_id)
)

GO

create table users(
    user_id int NOT NULL,
    user_firstname varchar(50) NOT NULL,
    user_lastname varchar(50) NOT NULL,
    user_email varchar(100) not null, 
    user_level_id int not null,
    constraint pk_user_id PRIMARY KEY(user_id)
)
GO

--FK15
alter table users
    add CONSTRAINT fk_users_user_level_id foreign key (user_level_id)
    REFERENCES user_levels (user_level_id)
GO

create table banned_apps(
    ba_session_id int not null,
    ba_user_id int null,
    ba_book_id char(6) null,
    ba_challenge_id char(6) null,
    ba_rating_id int null,
    constraint pk_ba_session_id PRIMARY KEY(ba_session_id)

)
GO
--FK16
alter table banned_apps
    add CONSTRAINT fk_banned_apps_ba_user_id foreign key (ba_user_id)
    REFERENCES users (user_id)
GO

--FK5
alter table banned_apps
    add CONSTRAINT fk_banned_apps_ba_book_id foreign key (ba_book_id)
    REFERENCES books (book_id)
GO

--FK7
alter table banned_apps
    add CONSTRAINT fk_banned_apps_ba_challenge_id foreign key (ba_challenge_id)
    REFERENCES challenges (challenge_id)
GO

--FK17
alter table banned_apps
    add CONSTRAINT fk_banned_apps_ba_rating_id foreign key (ba_rating_id)
    REFERENCES ratings (rating_id)
GO


--UP Data

INSERT into authors
    (author_id, author_firstname, author_lastname, author_ethnicity,
     author_birthdate, author_expiredate, author_age, author_homestate,
      author_homecountry, author_sexualorientation)
    VALUES
          ('A^0001','Tanya Lee','Stone','Caucasian','1965-12-23',NULL,NULL,'CN','United States ','unknown '),
     ('A^0002','Anthony','Burgess','Caucasian','1917-02-25','1919-11-22',NULL,NULL,'England ','heterosexual '),
     ('A^0003','Jill','Twiss','Caucasian',NULL ,NULL ,NULL,'OR','United States ','unknown '),
     ('A^0004','Robert','Peck','Caucasian','1928-02-17','2020-06-23',NULL,'NY','United States ','heterosexual '),
     ('A^0005','Jason','Reynolds','African-American','1983-12-06',NULL ,NULL,'DC','United States ','unknown '),
     ('A^0006','Brian','Katcher','Caucasian',NULL ,NULL,NULL,'MI','United States ','heterosexual '),
     ('A^0007','E.R','Frank','Caucasian',NULL ,NULL ,NULL,'VA','United States ','heterosexual '),
     ('A^0008','Justin ','Richardson','Caucasian',NULL ,NULL ,NULL,NULL,'United States ','homosexual'),
     ('A^0009','Peter','Parnell','Caucasian',NULL ,NULL,NULL,NULL,'United States ','homosexual'),
     ('A^0010','Nancy','Garden','Caucasian','1938-05-15','2014-06-23',NULL,'MA','United States ','homosexual'),
     ('A^0011','Joanna','Cole','Caucasian','1944-08-11','2020-07-12',NULL,'NJ','United States ','heterosexual '),
     ('A^0012','Toni','Morrison','African-American','1931-02-18','2019-08-05',NULL,'OH','United States ','heterosexual '),
     ('A^0013','Katherine','Paterson','Caucasian','1932-10-31',NULL,NULL,'VT','United States ','heterosexual '),
     ('A^0014','Ellen','Hopkins','Caucasian','1955-03-26',NULL ,NULL,NULL,'United States ','heterosexual '),
     ('A^0016','Patricia','McCormick','Caucasian','1956-05-23',NULL ,NULL,'NY','United States ','heterosexual'),
     ('A^0017','Michael','Willhoite','Caucasian','1946-07-03',NULL ,NULL,'OK','United States ','homosexual '),
     ('A^0018','Marilyn','Reynolds','Caucasian','1935-09-13',NULL,NULL,'CA','United States ','heterosexual'),
     ('A^0019','Eric','Carle','Caucasian','1929-06-25','2021-05-23',NULL,'NY','United States ','heterosexual'),
     ('A^0020','Rainbow','Rowell','Caucasian','1973-02-24',NULL ,NULL,'NE','United States ','heterosexual'),
     ('A^0021','Robert','Cormier','Caucasian','1925-01-17','2000-11-02',NULL,'MA','United States ','heterosexual'),
     ('A^0022','Lisa','McMann','Caucasian','1968-02-27',NULL ,NULL,'MI','United States ','heterosexual'),
     ('A^0023','M.T','Anderson','Caucasian','1968-11-04',NULL ,NULL,'MA','United States ','unknown '),
     ('A^0024','Mike','Curato','unknown ',NULL ,NULL ,NULL,'NY','United States ','unknown '),
     ('A^0025','Anonymous','Anonymous','NULL',NULL ,NULL,NULL,NULL,NULL,NULL),
     ('A^0026','Truman','Capote','Caucasian','1924-09-30','1984-08-25',NULL,'LA','United States ','homosexual '),
     ('A^0027','Maurice','Sendak','Caucasian','1928-06-10','2012-05-08',NULL,'NY','United States ','homosexual '),
     ('A^0028','Robie','Harris','Caucasian','1940-04-03',NULL ,NULL,'NY','United States ','heterosexual '),
     ('A^0029','A.M.','Homes','Caucasian','1961-12-18',NULL ,NULL,'DC','United States ','bisexual '),
     ('A^0030','Lois','Duncan','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0031','Brian','Katcher','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0032','Vladimir','Nabokov','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0033','Natasha','Friend','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0034','Jesse','Andrews','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0035','Walter Dean','Myers','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0036','Cheryl','Kilodavis','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0037','Jodi','Picoult','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0038','Richard','Wright','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0039','Jodi','Picoult','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0040','Daniel','Haack','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0041','Alex','Sanchez','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0042','Mildred D','Taylor','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0043','Tamara L','Roleff','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0044','Kurt','Vonnegut','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0045','David','Guterson','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0046','Yoko Kawashima','Watkins',NULL,NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0047','Laurie Halse','Anderson',NULL,NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0048','Chris','Crutcher','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0049','Sherman','Alexie','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0050','Kate','Chopin','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0051','Toni','Morrison','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0052','Alice','Walker','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0053','Mark','Haddon','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0054','Todd','Parr','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0055','Lois','Lowry','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0056','Isabel','Allende','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0057','Khaled','Hosseini','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0058','Alice','Sebold','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0059','S.E.','Hinton','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0060','Tim','O''Brien','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0061','Zora Neale','Hurston','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0062','Jay','Asher','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0063','Judy','Blume','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0064','Harper','Lee','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0065','Ellen','Hopkins','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0066','Sarah','Brannen','NULL',NULL,NULL,NULL,NULL,'NULL','NULL'),
     ('A^0067','Chris','Crutcher','NULL',NULL,NULL,NULL,NULL,'NULL','NULL')




GO
INSERT into authors_books
    (ab_id,ab_author_id, ab_book_id)
VALUES
    (1,'A^0001','B^1048'),
    (2,'A^0002','B^1007'),
    (3,'A^0003','B^3492'),
    (4,'A^0004','B^3360'),
    (5,'A^0005','B^3369'),
    (6,'A^0006','B^1008'),
    (7,'A^0007','B^2856'),
    (8,'A^0008','B^1147'),
    (9,'A^0009','B^1147'),
    (10,'A^0010','B^1152'),
    (11,'A^0011','B^2840'),
    (12,'A^0012','B^1010'),
    (13,'A^0013','B^1275'),
    (14,'A^0014','B^1285'),
    (15,'A^0016','B^3680'),
    (16,'A^0017','B^1367'),
    (17,'A^0018','B^1398'),
    (18,'A^0019','B^1419'),
    (19,'A^0020','B^1443'),
    (20,'A^0021','B^1479'),
    (21,'A^0022','B^1479'),
    (22,'A^0023','B^1498'),
    (23,'A^0024','B^1513'),
    (24,'A^0025','B^1594'),
    (25,'A^0026','B^1737'),
    (26,'A^0027','B^2827'),
    (27,'A^0028','B^1770'),
    (28,'A^0029','B^1772'),
    (29,'A^0030','B^1012'),
    (30,'A^0031','B^1008'),
    (31,'A^0032','B^1863'),
    (32,'A^0033','B^1894'),
    (33,'A^0034','B^1918'),
    (34,'A^0035','B^1944'),
    (35,'A^0036','B^1978'),
    (36,'A^0037','B^1980'),
    (37,'A^0038','B^3359'),
    (38,'A^0039','B^1980'),
    (39,'A^0040','B^1019'),
    (40,'A^0041','B^2108'),
    (41,'A^0042','B^3319'),
    (42,'A^0043','B^3289'),
    (43,'A^0044','B^2208'),
    (44,'A^0045','B^3325'),
    (45,'A^0046','B^2211'),
    (46,'A^0047','B^2237'),
    (47,'A^0048','B^2254'),
    (48,'A^0049','B^1093'),
    (49,'A^0050','B^1013'),
    (50,'A^0051','B^1010'),
    (51,'A^0052','B^2348'),
    (52,'A^0053','B^2353'),
    (53,'A^0054','B^2375'),
    (54,'A^0055','B^2393'),
    (55,'A^0056','B^2415'),
    (56,'A^0057','B^1811'),
    (57,'A^0058','B^2444'),
    (58,'A^0059','B^2465'),
    (59,'A^0060','B^2515'),
    (60,'A^0061','B^2544'),
    (61,'A^0062','B^1034'),
    (62,'A^0063','B^3352'),
    (63,'A^0064','B^2576'),
    (64,'A^0065','B^1285'),
    (65,'A^0066','B^2607'),
    (66,'A^0067','B^2254'),
    (67,'A^0014','B^3484'),
    (68,'A^0014','B^2595'),
    (69,'A^0006','B^1840'),
    (70,'A^0048','B^2660'),
    (71,'A^0037','B^1037'),
    (72,'A^0012','B^1006')



GO

INSERT into books
    (book_id, book_title, book_author_id, book_publication_year, book_series, book_last_modification)
    VALUES
    ('B^1048','A Bad Boy Can Be Good for a Girl',1,2006,'N','2023-5-23'),
    ('B^1007','A Clockwork Orange',2,NULL,'N','2023-5-23'),
    ('B^3492','A Day In the Life of Marlon Bundo',3,2018,'N','2023-5-23'),
    ('B^3360','A Day No Pigs Would Die',4,NULL,'N','2023-5-23'),
    ('B^3369','All American Boys',5,2015,'N','2023-5-23'),
    ('B^1008','Almost Perfect',6,2010,'N','2023-5-23'),
    ('B^2856','America',7,NULL,'N','2023-5-23'),
    ('B^1147','And Tango Makes Three',8,2015,'N','2023-5-23'),
    ('B^1152','Annie On My Mind',10,2007,'N','2023-5-23'),
    ('B^2840','Asking about Sex and Growing Up',11,NULL,'N','2023-5-23'),
    ('B^1010','Beloved',12,2004,'N','2023-5-23'),
    ('B^1275','Bridge To Terabithia',13,1977,'N','2023-5-23'),
    ('B^1285','Burned',14,2013,'Y','2023-5-23'),
    ('B^3484','Crank',67,2004,'Y','2023-5-23'),
    ('B^3680','Cut',15,NULL,'N','2023-5-23'),
    ('B^1367','Daddy''s Roommate',16,1990,'N','2023-5-23'),
    ('B^1398','Detour for Emmy',17,1993,'N','2023-5-23'),
    ('B^1419','Draw Me a Star',18,1992,'N','2023-5-23'),
    ('B^1443','Eleanor & Park',19,2012,'N','2023-5-23'),
    ('B^1479','Fade',20,2009,'N','2023-5-23'),
    ('B^1498','Feed',22,NULL,'N','2023-5-23'),
    ('B^1513','Flamer',23,NULL,'N','2023-5-23'),
    ('B^1594','Go Ask Alice',24,1971,'N','2023-5-23'),
    ('B^1737','In Cold Blood',25,1965,'N','2023-5-23'),
    ('B^2827','In the Night Kitchen',26,NULL,'N','2023-5-23'),
    ('B^1770','It''s Perfectly Normal: Changing Bodies, Growing Up, Sex, and Sexual Health',27,NULL,'N','2023-5-23'),
    ('B^1772','Jack',28,NULL,'N','2023-5-23'),
    ('B^1012','Killing Mr. Griffin',29,NULL,'N','2023-5-23'),
    ('B^1840','Life Is Funny',69,NULL,'N','2023-5-23'),
    ('B^1863','Lolita',31,NULL,'N','2023-5-23'),
    ('B^1894','Lush',32,NULL,'N','2023-5-23'),
    ('B^1918','Me and Earl and the Dying Girl',33,NULL,'N','2023-5-23'),
    ('B^1944','Monster',34,NULL,'N','2023-5-23'),
    ('B^1978','My Princess Boy',35,NULL,'N','2023-5-23'),
    ('B^1980','My Sister''s Keeper',36,NULL,'N','2023-5-23'),
    ('B^3359','Native Son',37,NULL,'N','2023-5-23'),
    ('B^1037','Nineteen Minutes',71,2008,'N','2023-5-23'),
    ('B^1019','Prince & Knight',39,NULL,'N','2023-5-23'),
    ('B^2108','Rainbow Boys',40,NULL,'Y','2023-5-23'),
    ('B^3319','Roll of Thunder, Hear My Cry',41,NULL,'N','2023-5-23'),
    ('B^3289','Sex',42,NULL,'N','2023-5-23'),
    ('B^2208','Slaughterhouse-Five',43,NULL,'N','2023-5-23'),
    ('B^3325','Snow Falling on Cedars',44,NULL,'N','2023-5-23'),
    ('B^2211','So Far from the Bamboo Grove',45,NULL,'N','2023-5-23'),
    ('B^2237','Speak',46,NULL,'N','2023-5-23'),
    ('B^2254','Staying Fat for Sarah Byrnes',47,NULL,'N','2023-5-23'),
    ('B^1093','The Absolutely True Diary of a Part-Time Indian',48,2007,'N','2023-5-23'),
    ('B^1013','The Awakening',49,NULL,'N','2023-5-23'),
    ('B^1006','The Bluest Eye',72,NULL,'N','2023-5-23'),
    ('B^2348','The Color Purple',51,NULL,'N','2023-5-23'),
    ('B^2353','The Curious Incident of the Dog in the Night-Time',52,NULL,'N','2023-5-23'),
    ('B^2375','The Family Book',53,NULL,'N','2023-5-23'),
    ('B^2393','The Giver',54,NULL,'N','2023-5-23'),
    ('B^2415','The House of the Spirits',55,NULL,'N','2023-5-23'),
    ('B^1811','The Kite Runner',56,NULL,'N','2023-5-23'),
    ('B^2444','The Lovely Bones',57,NULL,'N','2023-5-23'),
    ('B^2465','The Outsiders',58,NULL,'N','2023-5-23'),
    ('B^2515','The Things They Carried',59,NULL,'N','2023-5-23'),
    ('B^2544','Their Eyes Were Watching God',60,NULL,'N','2023-5-23'),
    ('B^1034','Thirteen Reasons Why',61,2007,'N','2023-5-23'),
    ('B^3352','Tiger Eyes',62,NULL,'N','2023-5-23'),
    ('B^2576','To Kill a Mockingbird',63,NULL,'N','2023-5-23'),
    ('B^2595','Tricks',68,NULL,'Y','2023-5-23'),
    ('B^2607','Uncle Bobby''s Wedding',65,NULL,'N','2023-5-23'),
    ('B^2660','Whale Talk',70,NULL,'N','2023-5-23')
   

GO

INSERT into reasons
    (reason_id, reason_descriptor, reason_freq)
    VALUES
    (1,'alcohol',2),
    (2,'bullying',2),
    (3,'violence',49),
    (4,'sexual',85),
    (5,'profanity',9),
    (6,'slurs',4),
    (7,'allegations',3),
    (8,'against',0),
    (9,'author',6),
    (10,'profanity',9),
    (11,'drug',15),
    (12,'alcoholism',2),
    (13,'anti',15),
    (14,'police',0),
    (15,'views',7),
    (16,'divisive',2),
    (17,'topics',2),
    (18,'lgbt',19),
    (19,'sexual',85),
    (20,'drug',15),
    (21,'alcohol',2),
    (22,'homosexuality',11),
    (23,'sex',16),
    (24,'marriage',2),
    (25,'lgbt',19),
    (26,'sexual',85),
    (27,'sexual',85),
    (28,'crude',4),
    (29,'language',83),
    (30,'sexual',85),
    (31,'mature',3),
    (32,'slavery',3),
    (33,'violence',49),
    (34,'racism',14),
    (35,'incest',4),
    (36,'child',6),
    (37,'sexual',85),
    (38,'abuse',11),
    (39,'allegations',3),
    (40,'secular',0),
    (41,'humanism',0),
    (42,'age',35),
    (43,'religion',2),
    (44,'occultism',2),
    (45,'satanism',0),
    (46,'supernatural',12),
    (47,'occult',0),
    (48,'anti',15),    
    (49,'family',6),
    (50,'encourages',2),
    (51,'disobedience',6),
    (52,'obscene',37),
    (53,'language',83),
    (54,'offensive',36),
    (55,'language',83),
    (56,'sexually',35),
    (57,'explicit',39),
    (58,'age',35),
    (59,'drugs',6),
    (60,'offensive',36),
    (61,'language',83),
    (62,'sexually',35),
    (63,'explicit',39),
    (64,'offensive',36),
    (65,'language',83),
    (66,'religious',17),
    (67,'viewpoint',18),
    (68,'age',35),
    (69,'profanity',9),
    (70,'atheism',2),
    (71,'cutting',0),
    (72,'harm',0),
    (73,'lgbt',19),
    (74,'lgbtqia+',8),
    (75,'political',8),
    (76,'religious',17),
    (77,'viewpoints',18),
    (78,'animal-slaughter',0),
    (79,'slaughter',0),
    (80,'animal-mating',0),
    (81,'sexual',85),
    (82,'pregnancy',0),
    (83,'offensive',36),
    (84,'language',83),
    (85,'child',6),
    (86,'sexual',85),
    (87,'abuse',11),
    (88,'violence',49),
    (89,'lgbtqia+',8),
    (90,'sexually',35),
    (91,'explicit',39),
    (92,'obscene',37),
    (93,'language',83),
    (94,'sexual',85),
    (95,'violence',49),
    (96,'age',35),
    (97,'drugs',6),
    (98,'sexual',85),
    (99,'violence',49),
    (100,'sexual',85),
    (101,'obscene',37),
    (102,'language',83),
    (103,'nudity',10),
    (104,'sexual',85),
    (105,'exploiting',0),
    (106,'toddler',0),
    (107,'nudity',10),
    (108,'sex',16),
    (109,'education',0),
    (110,'sexually',35),
    (111,'explicit',39),
    (112,'age',35),
    (113,'additional',3),
    (114,' child-pornography',6),
    (115,'lgbt',19),
    (116,'divorce',2),
    (117,'domestic',0),
    (118,'violence',49),
    (119,'violence',49),
    (120,'obscene',37),
    (121,'language',83),
    (122,'offensive',36),
    (123,'language',83),
    (124,'age',35),
    (125,'violence',49),
    (126,'sexual',85),
    (127,'pedophillia',3),
    (128,'sexual',85),
    (129,'abuse',11),
    (130,'religious',17),
    (131,'drugs',6),
    (132,'offensive',36),
    (133,'language',83),
    (134,'sexually',35),
    (135,'explicit',39),
    (136,'age',35),
    (137,'sexually',35),
    (138,'explicit',39),
    (139,'degrading',0),
    (140,'women',4),
    (141,'lgbt',19),
    (142,'homosexuality',11),
    (143,'offensive',36),
    (144,'language',83),
    (145,'religious',17),
    (146,'viewpoint',18),
    (147,'sexism',2),
    (148,'sexually',35),
    (149,'explicit',39),
    (150,'age',35),
    (151,'violence',49),
    (152,'violence',49),
    (153,'sexual',85),
    (154,'anti-religion',2),
    (155,'lgbtqia+',8),
    (156,'featuring',0),
    (157,'gay',0),
    (158,'marriage',2),
    (159,'indoctrinate',0),
    (160,'children”',2),
    (161,'potential',0),
    (162,'confusion',0),
    (163,'curiosity',0),
    (164,'gender',0),
    (165,'dysphoria',0),
    (166,'conflicting',0),
    (167,'religious',17),
    (168,'viewpoint',18),
    (169,'lgbt',19),
    (170,'sexual',85),
    (171,'offensive',36),
    (172,'language',83),
    (173,'sexual',85),
    (174,'sexual',85),
    (175,'anti',15),
    (176,'religious',17),
    (177,'violence',49),
    (178,'sexual',85),
    (179,'rape',5),
    (180,'violence',49),
    (181,'against',0),
    (182,'women',4),
    (183,'rape',5),
    (184,'obscene',37),
    (185,'language',83),
    (186,'sexual',85),
    (187,'political',8),
    (188,'views',7),
    (189,'violence',49),
    (190,'animal',6), 
    (191,'abuse',11),
    (192,'obscene',37),
    (193,'language',83),
    (194,'criticism',2),
    (195,'vietnam',2),
    (196,'war',2),
    (197,'drugs',6),
    (198,'sexually',35),
    (199,'explicit',39),
    (200,'suicide',6),
    (201,'age',35),
    (202,'alcohol',2),
    (203,'smoking',2),
    (204,'sexual',85),
    (205,'drug',15),
    (206,'language',83),
    (207,'offensive',36),
    (208,'language',83),
    (209,'racism',14),
    (210,'age',35),
    (211,'lgbt',19),
    (212,'racism',14),
    (213,'offensive',36),
    (214,'language',83)

GO

INSERT into challenges_reasons
    (cr_id, cr_challenge_id, cr_reason_id)
    VALUES
     (1,'C^1015',197),
     (2,'C^1015',198),
     (3,'C^1015',199),
     (4,'C^1015',200),
     (5,'C^1015',201),
     (6,'C^1015',202),
     (7,'C^1015',203),
     (8,'C^1016',197),
     (9,'C^1016',198),
     (10,'C^1016',199),
     (11,'C^1016',200),
     (12,'C^1016',201),
     (13,'C^1016',202),
     (14,'C^1016',203),
     (15,'C^1017',197),
     (16,'C^1017',198),
     (17,'C^1017',199),
     (18,'C^1017',200),
     (19,'C^1017',201),
     (20,'C^1017',202),
     (21,'C^1017',203),
     (22,'C^1141',1),
     (23,'C^1141',2),
     (24,'C^1141',3),
     (25,'C^1141',4),
     (26,'C^1141',5),
     (27,'C^1141',6),
     (28,'C^1141',7),
     (29,'C^1141',8),
     (30,'C^1141',9),
     (31,'C^1038',28),
     (32,'C^1038',29),
     (33,'C^1038',30),
     (34,'C^1038',31),
     (35,'C^1039',28),
     (36,'C^1039',29),
     (37,'C^1039',30),
     (38,'C^1039',31),
     (39,'C^1087',74),
     (40,'C^1087',75),
     (41,'C^1087',76),
     (42,'C^1087',77),
     (43,'C^1166',10),
     (44,'C^1166',11),
     (45,'C^1166',12),
     (46,'C^1166',13),
     (47,'C^1166',14),
     (48,'C^1166',15),
     (49,'C^1166',16),
     (50,'C^1166',17),
     (51,'C^1167',10),
     (52,'C^1167',11),
     (53,'C^1167',12),
     (54,'C^1167',13),
     (55,'C^1167',14),
     (56,'C^1167',15),
     (57,'C^1167',16),
     (58,'C^1167',17),
     (59,'C^1168',10),
     (60,'C^1168',11),
     (61,'C^1168',12),
     (62,'C^1168',13),
     (63,'C^1168',14),
     (64,'C^1168',15),
     (65,'C^1168',16),
     (66,'C^1168',17),
     (67,'C^1169',10),
     (68,'C^1169',11),
     (69,'C^1169',12),
     (70,'C^1169',13),
     (71,'C^1169',14),
     (72,'C^1169',15),
     (73,'C^1169',16),
     (74,'C^1169',17),
     (75,'C^1170',10),
     (76,'C^1170',11),
     (77,'C^1170',12),
     (78,'C^1170',13),
     (79,'C^1170',14),
     (80,'C^1170',15),
     (81,'C^1170',16),
     (82,'C^1170',17),
     (83,'C^1171',10),
     (84,'C^1171',11),
     (85,'C^1171',12),
     (86,'C^1171',13),
     (87,'C^1171',14),
     (88,'C^1171',15),
     (89,'C^1171',16),
     (90,'C^1171',17),
     (91,'C^1172',10),
     (92,'C^1172',11),
     (93,'C^1172',12),
     (94,'C^1172',13),
     (95,'C^1172',14),
     (96,'C^1172',15),
     (97,'C^1172',16),
     (98,'C^1172',17),
     (99,'C^1173',10),
     (100,'C^1173',11),
     (101,'C^1173',12),
     (102,'C^1173',13),
     (103,'C^1173',14),
     (104,'C^1173',15),
     (105,'C^1173',16),
     (106,'C^1173',17),
     (107,'C^1174',10),
     (108,'C^1174',11),
     (109,'C^1174',12),
     (110,'C^1174',13),
     (111,'C^1174',14),
     (112,'C^1174',15),
     (113,'C^1174',16),
     (114,'C^1174',17),
     (115,'C^1175',10),
     (116,'C^1175',11),
     (117,'C^1175',12),
     (118,'C^1175',13),
     (119,'C^1175',14),
     (120,'C^1175',15),
     (121,'C^1175',16),
     (122,'C^1175',17),
     (123,'C^1176',10),
     (124,'C^1176',11),
     (125,'C^1176',12),
     (126,'C^1176',13),
     (127,'C^1176',14),
     (128,'C^1176',15),
     (129,'C^1176',16),
     (130,'C^1176',17),
     (131,'C^1177',10),
     (132,'C^1177',11),
     (133,'C^1177',12),
     (134,'C^1177',13),
     (135,'C^1177',14),
     (136,'C^1177',15),
     (137,'C^1177',16),
     (138,'C^1177',17),
     (139,'C^1178',10),
     (140,'C^1178',11),
     (141,'C^1178',12),
     (142,'C^1178',13),
     (143,'C^1178',14),
     (144,'C^1178',15),
     (145,'C^1178',16),
     (146,'C^1178',17),
     (147,'C^1179',10),
     (148,'C^1179',11),
     (149,'C^1179',12),
     (150,'C^1179',13),
     (151,'C^1179',14),
     (152,'C^1179',15),
     (153,'C^1179',16),
     (154,'C^1179',17),
     (155,'C^1180',10),
     (156,'C^1180',11),
     (157,'C^1180',12),
     (158,'C^1180',13),
     (159,'C^1180',14),
     (160,'C^1180',15),
     (161,'C^1180',16),
     (162,'C^1180',17),
     (163,'C^1181',10),
     (164,'C^1181',11),
     (165,'C^1181',12),
     (166,'C^1181',13),
     (167,'C^1181',14),
     (168,'C^1181',15),
     (169,'C^1181',16),
     (170,'C^1181',17),
     (171,'C^1182',10),
     (172,'C^1182',11),
     (173,'C^1182',12),
     (174,'C^1182',13),
     (175,'C^1182',14),
     (176,'C^1182',15),
     (177,'C^1182',16),
     (178,'C^1182',17),
     (179,'C^1275',18),
     (180,'C^1276',18),
     (181,'C^1277',18),
     (182,'C^1278',18),
     (183,'C^1279',18),
     (184,'C^1280',18),
     (185,'C^1281',18),
     (186,'C^1282',18),
     (187,'C^1283',18),
     (188,'C^1284',18),
     (189,'C^1285',18),
     (190,'C^1316',22),
     (191,'C^1316',23),
     (192,'C^1316',24),
     (193,'C^1317',22),
     (194,'C^1317',23),
     (195,'C^1317',24),
     (196,'C^1318',22),
     (197,'C^1318',23),
     (198,'C^1318',24),
     (199,'C^1319',22),
     (200,'C^1319',23),
     (201,'C^1319',24),
     (202,'C^1320',22),
     (203,'C^1320',23),
     (204,'C^1320',24),
     (205,'C^1321',22),
     (206,'C^1321',23),
     (207,'C^1321',24),
     (208,'C^1322',22),
     (209,'C^1322',23),
     (210,'C^1322',24),
     (211,'C^1331',25),
     (212,'C^1449',32),
     (213,'C^1449',33),
     (214,'C^1450',32),
     (215,'C^1450',33),
     (216,'C^1451',32),
     (217,'C^1451',33),
     (218,'C^1452',32),
     (219,'C^1452',33),
     (220,'C^1453',32),
     (221,'C^1453',33),
     (222,'C^1454',32),
     (223,'C^1454',33),
     (224,'C^1455',32),
     (225,'C^1455',33),
     (226,'C^1456',32),
     (227,'C^1456',33),
     (228,'C^1457',32),
     (229,'C^1457',33),
     (230,'C^1458',32),
     (231,'C^1458',33),
     (232,'C^1459',32),
     (233,'C^1459',33),
     (234,'C^1460',32),
     (235,'C^1460',33),
     (236,'C^1461',32),
     (237,'C^1461',33),
     (238,'C^1462',32),
     (239,'C^1462',33),
     (240,'C^1463',32),
     (241,'C^1463',33),
     (242,'C^1464',32),
     (243,'C^1464',33),
     (244,'C^1465',32),
     (245,'C^1465',33),
     (246,'C^1466',32),
     (247,'C^1466',33),
     (248,'C^1467',32),
     (249,'C^1467',33),
     (250,'C^1468',32),
     (251,'C^1468',33),
     (252,'C^1571',32),
     (253,'C^1571',33),
     (254,'C^1622',39),
     (255,'C^1622',40),
     (256,'C^1622',41),
     (257,'C^1622',42),
     (258,'C^1622',43),
     (259,'C^1622',44),
     (260,'C^1622',45),
     (261,'C^1633',46),
     (262,'C^1633',47),
     (263,'C^1633',48),
     (264,'C^1633',49),
     (265,'C^1633',50),
     (266,'C^1633',51),
     (267,'C^1634',46),
     (268,'C^1634',47),
     (269,'C^1634',48),
     (270,'C^1634',49),
     (271,'C^1634',50),
     (272,'C^1634',51),
     (273,'C^1733',59),
     (274,'C^1733',60),
     (275,'C^1733',61),
     (276,'C^1733',62),
     (277,'C^1733',63),
     (278,'C^1734',59),
     (279,'C^1734',60),
     (280,'C^1734',61),
     (281,'C^1734',62),
     (282,'C^1734',63),
     (283,'C^1735',59),
     (284,'C^1735',60),
     (285,'C^1735',61),
     (286,'C^1735',62),
     (287,'C^1735',63),
     (288,'C^1736',59),
     (289,'C^1736',60),
     (290,'C^1736',61),
     (291,'C^1736',62),
     (292,'C^1736',63),
     (293,'C^1737',59),
     (294,'C^1737',60),
     (295,'C^1737',61),
     (296,'C^1737',62),
     (297,'C^1737',63),
     (298,'C^1738',59),
     (299,'C^1738',60),
     (300,'C^1738',61),
     (301,'C^1738',62),
     (302,'C^1738',63),
     (303,'C^1739',59),
     (304,'C^1739',60),
     (305,'C^1739',61),
     (306,'C^1739',62),
     (307,'C^1739',63),
     (308,'C^1740',59),
     (309,'C^1740',60),
     (310,'C^1740',61),
     (311,'C^1740',62),
     (312,'C^1740',63),
     (313,'C^1741',59),
     (314,'C^1741',60),
     (315,'C^1741',61),
     (316,'C^1741',62),
     (317,'C^1741',63),
     (318,'C^1742',59),
     (319,'C^1742',60),
     (320,'C^1742',61),
     (321,'C^1742',62),
     (322,'C^1742',63),
     (323,'C^1743',59),
     (324,'C^1743',60),
     (325,'C^1743',61),
     (326,'C^1743',62),
     (327,'C^1743',63),
     (328,'C^1744',59),
     (329,'C^1744',60),
     (330,'C^1744',61),
     (331,'C^1744',62),
     (332,'C^1744',63),
     (333,'C^1745',59),
     (334,'C^1745',60),
     (335,'C^1745',61),
     (336,'C^1745',62),
     (337,'C^1745',63),
     (338,'C^1746',59),
     (339,'C^1746',60),
     (340,'C^1746',61),
     (341,'C^1746',62),
     (342,'C^1746',63),
     (343,'C^1747',59),
     (344,'C^1747',60),
     (345,'C^1747',61),
     (346,'C^1747',62),
     (347,'C^1747',63),
     (348,'C^1748',59),
     (349,'C^1748',60),
     (350,'C^1748',61),
     (351,'C^1748',62),
     (352,'C^1748',63),
     (353,'C^1749',59),
     (354,'C^1749',60),
     (355,'C^1749',61),
     (356,'C^1749',62),
     (357,'C^1749',63),
     (358,'C^1750',59),
     (359,'C^1750',60),
     (360,'C^1750',61),
     (361,'C^1750',62),
     (362,'C^1750',63),
     (363,'C^1751',59),
     (364,'C^1751',60),
     (365,'C^1751',61),
     (366,'C^1751',62),
     (367,'C^1751',63),
     (368,'C^1752',59),
     (369,'C^1752',60),
     (370,'C^1752',61),
     (371,'C^1752',62),
     (372,'C^1752',63),
     (373,'C^1753',59),
     (374,'C^1753',60),
     (375,'C^1753',61),
     (376,'C^1753',62),
     (377,'C^1753',63),
     (378,'C^1754',59),
     (379,'C^1754',60),
     (380,'C^1754',61),
     (381,'C^1754',62),
     (382,'C^1754',63),
     (383,'C^1755',59),
     (384,'C^1755',60),
     (385,'C^1755',61),
     (386,'C^1755',62),
     (387,'C^1755',63),
     (388,'C^1756',59),
     (389,'C^1756',60),
     (390,'C^1756',61),
     (391,'C^1756',62),
     (392,'C^1756',63),
     (393,'C^1757',59),
     (394,'C^1757',60),
     (395,'C^1757',61),
     (396,'C^1757',62),
     (397,'C^1757',63),
     (398,'C^1758',59),
     (399,'C^1758',60),
     (400,'C^1758',61),
     (401,'C^1758',62),
     (402,'C^1758',63),
     (403,'C^1998',59),
     (404,'C^1998',60),
     (405,'C^1998',61),
     (406,'C^1998',62),
     (407,'C^1998',63),
     (408,'C^1999',59),
     (409,'C^1999',60),
     (410,'C^1999',61),
     (411,'C^1999',62),
     (412,'C^1999',63),
     (413,'C^2000',59),
     (414,'C^2000',60),
     (415,'C^2000',61),
     (416,'C^2000',62),
     (417,'C^2000',63),
     (418,'C^2299',59),
     (419,'C^2299',60),
     (420,'C^2299',61),
     (421,'C^2299',62),
     (422,'C^2299',63),
     (423,'C^1779',73),
     (424,'C^1831',81),
     (425,'C^1831',82),
     (426,'C^1916',83),
     (427,'C^1916',84),
     (428,'C^1917',83),
     (429,'C^1917',84),
     (430,'C^1918',83),
     (431,'C^1918',84),
     (432,'C^1919',83),
     (433,'C^1919',84),
     (434,'C^1920',83),
     (435,'C^1920',84),
     (436,'C^1921',83),
     (437,'C^1921',84),
     (438,'C^1922',83),
     (439,'C^1922',84),
     (440,'C^1923',83),
     (441,'C^1923',84),
     (442,'C^1924',83),
     (443,'C^1924',84),
     (444,'C^1925',83),
     (445,'C^1925',84),
     (446,'C^1926',83),
     (447,'C^1926',84),
     (448,'C^1927',83),
     (449,'C^1927',84),
     (450,'C^1928',83),
     (451,'C^1928',84),
     (452,'C^1929',83),
     (453,'C^1929',84),
     (454,'C^1930',83),
     (455,'C^1930',84),
     (456,'C^1931',83),
     (457,'C^1931',84),
     (458,'C^1988',85),
     (459,'C^1988',86),
     (460,'C^1988',87),
     (461,'C^1988',88),
     (462,'C^1989',85),
     (463,'C^1989',86),
     (464,'C^1989',87),
     (465,'C^1989',88),
     (466,'C^1990',85),
     (467,'C^1990',86),
     (468,'C^1990',87),
     (469,'C^1990',88),
     (470,'C^1991',85),
     (471,'C^1991',86),
     (472,'C^1991',87),
     (473,'C^1991',88),
     (474,'C^1992',85),
     (475,'C^1992',86),
     (476,'C^1992',87),
     (477,'C^1992',88),
     (478,'C^1993',85),
     (479,'C^1993',86),
     (480,'C^1993',87),
     (481,'C^1993',88),
     (482,'C^2046',89),
     (483,'C^2046',90),
     (484,'C^2046',91),
     (485,'C^2047',89),
     (486,'C^2047',90),
     (487,'C^2047',91),
     (488,'C^2048',89),
     (489,'C^2048',90),
     (490,'C^2048',91),
     (491,'C^2049',89),
     (492,'C^2049',90),
     (493,'C^2049',91),
     (494,'C^2050',89),
     (495,'C^2050',90),
     (496,'C^2050',91),
     (497,'C^2051',89),
     (498,'C^2051',90),
     (499,'C^2051',91),
     (500,'C^2052',89),
     (501,'C^2052',90),
     (502,'C^2052',91),
     (503,'C^2053',89),
     (504,'C^2053',90),
     (505,'C^2053',91),
     (506,'C^2054',89),
     (507,'C^2054',90),
     (508,'C^2054',91),
     (509,'C^2055',89),
     (510,'C^2055',90),
     (511,'C^2055',91),
     (512,'C^2056',89),
     (513,'C^2056',90),
     (514,'C^2056',91),
     (515,'C^2057',89),
     (516,'C^2057',90),
     (517,'C^2057',91),
     (518,'C^2058',89),
     (519,'C^2058',90),
     (520,'C^2058',91),
     (521,'C^2059',89),
     (522,'C^2059',90),
     (523,'C^2059',91),
     (524,'C^2060',89),
     (525,'C^2060',90),
     (526,'C^2060',91),
     (527,'C^2061',89),
     (528,'C^2061',90),
     (529,'C^2061',91),
     (530,'C^2062',89),
     (531,'C^2062',90),
     (532,'C^2062',91),
     (533,'C^2063',89),
     (534,'C^2063',90),
     (535,'C^2063',91),
     (536,'C^2064',89),
     (537,'C^2064',90),
     (538,'C^2064',91),
     (539,'C^2065',89),
     (540,'C^2065',90),
     (541,'C^2065',91),
     (542,'C^2307',97),
     (543,'C^2580',99),
     (544,'C^2580',100),
     (545,'C^2580',101),
     (546,'C^2580',102),
     (547,'C^2658',109),
     (548,'C^2658',115),
     (549,'C^2658',116),
     (550,'C^2658',117),
     (551,'C^2658',118),
     (552,'C^2659',109),
     (553,'C^2659',115),
     (554,'C^2659',116),
     (555,'C^2659',117),
     (556,'C^2659',118),
     (557,'C^2722',119),
     (558,'C^2722',120),
     (559,'C^2722',121),
     (560,'C^2723',119),
     (561,'C^2723',120),
     (562,'C^2723',121),
     (563,'C^2724',119),
     (564,'C^2724',120),
     (565,'C^2724',121),
     (566,'C^2725',119),
     (567,'C^2725',120),
     (568,'C^2725',121),
     (569,'C^2726',119),
     (570,'C^2726',120),
     (571,'C^2726',121),
     (572,'C^2727',119),
     (573,'C^2727',120),
     (574,'C^2727',121),
     (575,'C^2739',122),
     (576,'C^2739',123),
     (577,'C^2739',124),
     (578,'C^2739',125),
     (579,'C^2740',122),
     (580,'C^2740',123),
     (581,'C^2740',124),
     (582,'C^2740',125),
     (583,'C^2741',122),
     (584,'C^2741',123),
     (585,'C^2741',124),
     (586,'C^2741',125),
     (587,'C^2852',126),
     (588,'C^2898',127),
     (589,'C^2898',128),
     (590,'C^2898',129),
     (591,'C^2899',127),
     (592,'C^2899',128),
     (593,'C^2899',129),
     (594,'C^2900',127),
     (595,'C^2900',128),
     (596,'C^2900',129),
     (597,'C^2969',131),
     (598,'C^2969',132),
     (599,'C^2969',133),
     (600,'C^2969',134),
     (601,'C^2969',135),
     (602,'C^2969',136),
     (603,'C^2970',131),
     (604,'C^2970',132),
     (605,'C^2970',133),
     (606,'C^2970',134),
     (607,'C^2970',135),
     (608,'C^2970',136),
     (609,'C^3187',141),
     (610,'C^3191',142),
     (611,'C^3191',143),
     (612,'C^3191',144),
     (613,'C^3191',145),
     (614,'C^3191',146),
     (615,'C^3191',147),
     (616,'C^3191',148),
     (617,'C^3191',149),
     (618,'C^3191',150),
     (619,'C^3191',151),
     (620,'C^3192',142),
     (621,'C^3192',143),
     (622,'C^3192',144),
     (623,'C^3192',145),
     (624,'C^3192',146),
     (625,'C^3192',147),
     (626,'C^3192',148),
     (627,'C^3192',149),
     (628,'C^3192',150),
     (629,'C^3192',151),
     (630,'C^3193',142),
     (631,'C^3193',143),
     (632,'C^3193',144),
     (633,'C^3193',145),
     (634,'C^3193',146),
     (635,'C^3193',147),
     (636,'C^3193',148),
     (637,'C^3193',149),
     (638,'C^3193',150),
     (639,'C^3193',151),
     (640,'C^3194',142),
     (641,'C^3194',143),
     (642,'C^3194',144),
     (643,'C^3194',145),
     (644,'C^3194',146),
     (645,'C^3194',147),
     (646,'C^3194',148),
     (647,'C^3194',149),
     (648,'C^3194',150),
     (649,'C^3194',151),
     (650,'C^3195',142),
     (651,'C^3195',143),
     (652,'C^3195',144),
     (653,'C^3195',145),
     (654,'C^3195',146),
     (655,'C^3195',147),
     (656,'C^3195',148),
     (657,'C^3195',149),
     (658,'C^3195',150),
     (659,'C^3195',151),
     (660,'C^3462',155),
     (661,'C^3462',156),
     (662,'C^3462',157),
     (663,'C^3462',158),
     (664,'C^3462',159),
     (665,'C^3462',160),
     (666,'C^3462',161),
     (667,'C^3462',162),
     (668,'C^3462',163),
     (669,'C^3462',164),
     (670,'C^3462',165),
     (671,'C^3462',166),
     (672,'C^3462',167),
     (673,'C^3462',168),
     (674,'C^3463',155),
     (675,'C^3463',156),
     (676,'C^3463',157),
     (677,'C^3463',158),
     (678,'C^3463',159),
     (679,'C^3463',160),
     (680,'C^3463',161),
     (681,'C^3463',162),
     (682,'C^3463',163),
     (683,'C^3463',164),
     (684,'C^3463',165),
     (685,'C^3463',166),
     (686,'C^3463',167),
     (687,'C^3463',168),
     (688,'C^3464',155),
     (689,'C^3464',156),
     (690,'C^3464',157),
     (691,'C^3464',158),
     (692,'C^3464',159),
     (693,'C^3464',160),
     (694,'C^3464',161),
     (695,'C^3464',162),
     (696,'C^3464',163),
     (697,'C^3464',164),
     (698,'C^3464',165),
     (699,'C^3464',166),
     (700,'C^3464',167),
     (701,'C^3464',168),
     (702,'C^3510',169),
     (703,'C^3510',170),
     (704,'C^3511',169),
     (705,'C^3511',170),
     (706,'C^3512',169),
     (707,'C^3512',170)

----------------
--FK1-- Might not need this 
alter table authors_books 
    add CONSTRAINT fk_authors_books_ab_author_id foreign key (ab_author_id)
   REFERENCES authors (author_id)

GO

--FK3
alter table authors_books 
    add CONSTRAINT fk_authors_books_ab_book_id foreign key (ab_book_id)
    REFERENCES books (book_id)

GO

--- put challenges and reasons fill
INSERT into challenges
    (challenge_id, challenge_book_id, challenge_school_district, challenge_county, 
    challenge_state, challenge_last_modified, challenge_book_status)
    VALUES
         ('C^1015','B^1034','Bixby Public Schools','NULL','OK','2023-5-2','Retained'),
     ('C^1016','B^1034','Frisco ISD','NULL','TX','2023-5-2','Under Review'),
     ('C^1017','B^1034','North Smithfield School District','NULL','RI','2023-5-2','Unknown'),
     ('C^1021','B^1037','Fox C-6 School District','NULL','MO','2023-5-2','Under Review'),
     ('C^1022','B^1037','North Smithfield School District','NULL','RI','2023-5-2','Unknown'),
     ('C^1038','B^1048','Collier County Public Schools','NULL','FL','2023-5-2','Retained'),
     ('C^1039','B^1048','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^1087','B^3492','Walton County School District','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^1141','B^1093','Madison County Schools','NULL','MS','2023-5-2','Restricted (Pending Review)'),
     ('C^1166','B^3369','Madison County Schools','NULL','MS','2023-5-2','Restricted (Pending Review)'),
     ('C^1167','B^3369','Baldwinsville Central School District','NULL','NY','2023-5-2','Under Review'),
     ('C^1168','B^3369','Bristow Public Schools','NULL','OK','2023-5-2','Restricted'),
     ('C^1169','B^3369','Central York School District','York County','PE','2023-5-2','Returned'),
     ('C^1170','B^3369','Collier County Public Schools','NULL','FL','2023-5-2','Retained'),
     ('C^1171','B^3369','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1172','B^3369','Granbury Independent School District','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^1173','B^3369','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^1174','B^3369','Katy','NULL','TX','2023-5-2','Restricted'),
     ('C^1175','B^3369','Katy ISD','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1176','B^3369','McKinney Independent School District','Collin County','TX','2023-5-2','Under Review'),
     ('C^1177','B^3369','Middlebury Community Schools','NULL','IN','2023-5-2','Restricted'),
     ('C^1178','B^3369','Middlebury Community Schools','NULL','IN','2023-5-2','Restricted'),
     ('C^1179','B^3369','North East Independent School District','Bexar County','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1180','B^3369','Pitt County Schools','NULL','NC','2023-5-2','Restricted'),
     ('C^1181','B^3369','Rangeley Lakes Regional School District','NULL','MA','2023-5-2','Unknown'),
     ('C^1182','B^3369','Warwick School District','NULL','PA','2023-5-2','Under Review'),
     ('C^1275','B^1008','Fauquier County Public Schools','NULL','VA','2023-5-2','Under Review'),
     ('C^1276','B^1008','Granbury Independent School District','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^1277','B^1008','Iredell-Statesville Schools','NULL','NC','2023-5-2','Restricted'),
     ('C^1278','B^1008','Keystone School District','NULL','PA','2023-5-2','Under Review'),
     ('C^1279','B^1008','Lee County School ','NULL','FL','2023-5-2','Restricted'),
     ('C^1280','B^1008','McKinney Independent School District','Collin County','TX','2023-5-2','Under Review'),
     ('C^1281','B^1008','North East Independent School District','Bexar County','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1282','B^1008','Orange County','NULL','FL','2023-5-2','Under Review'),
     ('C^1283','B^1008','Pleasant Valley School District','NULL','PA','2023-5-2','Restricted'),
     ('C^1284','B^1008','Polk County Schools','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^1285','B^1008','Walton County School District','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^1316','B^1147','Broward County Public Schools','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^1317','B^1147','Lee County School ','NULL','FL','2023-5-2','Retained'),
     ('C^1318','B^1147','McKinney Independent School District','Collin County','TX','2023-5-2','Under Review'),
     ('C^1319','B^1147','North East Independent School District','Bexar County','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1320','B^1147','Pleasant Valley School District','NULL','PA','2023-5-2','Restricted'),
     ('C^1321','B^1147','St. Lucie Public Schools','NULL','FL','2023-5-2','Removed (Pending Review)'),
     ('C^1322','B^1147','Walton County School District','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^1331','B^1152','North East Independent School District','Bexar County','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1449','B^1010','Bedford','NULL','VA','2023-5-2','Removed (Pending Review)'),
     ('C^1450','B^1010','Bedford County School District ','NULL','VA','2023-5-2','Retained'),
     ('C^1451','B^1010','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1452','B^1010','Gladwin Community Schools','NULL','MI','2023-5-2','Banned/Removed'),
     ('C^1453','B^1010','Hillsborough','NULL','FL','2023-5-2','Unknown'),
     ('C^1454','B^1010','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^1455','B^1010','Jackson County School Board','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^1456','B^1010','Katy','NULL','TX','2023-5-2','Restricted'),
     ('C^1457','B^1010','Katy ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^1458','B^1010','Klein ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^1459','B^1010','Lee County School ','NULL','FL','2023-5-2','Restricted'),
     ('C^1460','B^1010','Littlestown Area School District','NULL','PA','2023-5-2','Retained'),
     ('C^1461','B^1010','Madison County Schools','NULL','MS','2023-5-2','Restricted (Pending Review)'),
     ('C^1462','B^1010','Murray City School District','NULL','UT','2023-5-2','Unknown'),
     ('C^1463','B^1010','Pleasant Valley School District','NULL','PA','2023-5-2','Restricted'),
     ('C^1464','B^1010','Polk County Schools','NULL','FL','2023-5-2','Returned'),
     ('C^1465','B^1010','Santa Rosa County District Schools','NULL','FL','2023-5-2','Removed (Pending Review)'),
     ('C^1466','B^1010','Spotsylvania County Public Schools','NULL','VA','2023-5-2','Retained'),
     ('C^1467','B^1010','St. Lucie Public Schools','NULL','FL','2023-5-2','Removed (Pending Review)'),
     ('C^1468','B^1010','Walton County School District','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^1571','B^1010','Keystone School District','NULL','PA','2023-5-2','Under Review'),
     ('C^1622','B^1275','Bristow Public Schools','NULL','OK','2023-5-2','Restricted'),
     ('C^1633','B^1285','Bristow Public Schools','NULL','OK','2023-5-2','Restricted'),
     ('C^1634','B^1285','Prosper ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^1733','B^3484','Brevard County Public Schools','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^1734','B^3484','Bristow Public Schools','NULL','OK','2023-5-2','Restricted'),
     ('C^1735','B^3484','Carmel  Clay Schools','NULL','IN','2023-5-2','Banned/Removed'),
     ('C^1736','B^3484','Cherokee County School District','NULL','GA','2023-5-2','Retained'),
     ('C^1737','B^3484','Collier County Public Schools','NULL','FL','2023-5-2','Retained'),
     ('C^1738','B^3484','Davis School District','NULL','UT','2023-5-2','Retained'),
     ('C^1739','B^3484','Davis School District','NULL','UT','2023-5-2','Retained'),
     ('C^1740','B^3484','Davis School District','NULL','UT','2023-5-2','Under Review'),
     ('C^1741','B^3484','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1742','B^3484','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1743','B^3484','Fauquier County Public Schools','NULL','VA','2023-5-2','Under Review'),
     ('C^1744','B^3484','Francis Howell','NULL','MO','2023-5-2','Restricted'),
     ('C^1745','B^3484','Gladwin Community Schools','NULL','MI','2023-5-2','Banned/Removed'),
     ('C^1746','B^3484','Goddard','NULL','KS','2023-5-2','Under Review'),
     ('C^1747','B^3484','Indian River County Schools ','NULL','FL','2023-5-2','Restricted'),
     ('C^1748','B^3484','Lindbergh School District','NULL','MO','2023-5-2','Retained'),
     ('C^1749','B^3484','Littlestown Area School District','NULL','PA','2023-5-2','Retained'),
     ('C^1750','B^3484','Murray City School District','NULL','UT','2023-5-2','Unknown'),
     ('C^1751','B^3484','Nampa School District','NULL','ID','2023-5-2','Banned/Removed'),
     ('C^1752','B^3484','Nixa Public Schools','NULL','MO','2023-5-2','Unknown'),
     ('C^1753','B^3484','Prosper ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^1754','B^3484','Rockwood','NULL','MO','2023-5-2','Retained'),
     ('C^1755','B^3484','St. Johns County School District','NULL','FL','2023-5-2','Unknown'),
     ('C^1756','B^3484','St. Louis Region Schools','NULL','MO','2023-5-2','Unknown'),
     ('C^1757','B^3484','Wilson County School Board','NULL','TN','2023-5-2','Restricted'),
     ('C^1758','B^3484','Fredericksburg ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^1779','B^1367','Walton County School District','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^1831','B^1398','North East Independent School District','Bexar County','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1874','B^1419','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^1916','B^1443','Catawba County Schools','NULL','NC','2023-5-2','Retained'),
     ('C^1917','B^1443','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1918','B^1443','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1919','B^1443','Fauquier County Public Schools','NULL','VA','2023-5-2','Under Review'),
     ('C^1920','B^1443','Fredericksburg ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^1921','B^1443','Indian River County Schools ','NULL','FL','2023-5-2','Restricted'),
     ('C^1922','B^1443','Littlestown Area School District','NULL','PA','2023-5-2','Retained'),
     ('C^1923','B^1443','Madison County Schools','NULL','MS','2023-5-2','Restricted (Pending Review)'),
     ('C^1924','B^1443','Metropolitan Nashville Public Schools','NULL','TN','2023-5-2','Unknown'),
     ('C^1925','B^1443','Murray City School District','NULL','UT','2023-5-2','Unknown'),
     ('C^1926','B^1443','Nampa School District','NULL','ID','2023-5-2','Banned/Removed'),
     ('C^1927','B^1443','St. Johns County School District','NULL','FL','2023-5-2','Unknown'),
     ('C^1928','B^1443','Union Academy','NULL','NC','2023-5-2','Under Review'),
     ('C^1929','B^1443','Wilson County School Board','NULL','TN','2023-5-2','Restricted'),
     ('C^1930','B^1443','Davis School District','NULL','UT','2023-5-2','Retained'),
     ('C^1931','B^1443','Davis School District','NULL','UT','2023-5-2','Under Review'),
     ('C^1988','B^1479','Fauquier County Public Schools','NULL','VA','2023-5-2','Under Review'),
     ('C^1989','B^1479','Gladwin Community Schools','NULL','MI','2023-5-2','Banned/Removed'),
     ('C^1990','B^1479','St. Johns County School District','NULL','FL','2023-5-2','Retained'),
     ('C^1991','B^1479','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1992','B^1479','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1993','B^1479','Fredericksburg ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^1998','B^3484','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^1999','B^3484','Gladwin Community Schools','NULL','MI','2023-5-2','Banned/Removed'),
     ('C^2000','B^3484','Prosper ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^2022','B^1498','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^2046','B^1513','Bixby Public Schools','NULL','OK','2023-5-2','Banned/Removed'),
     ('C^2047','B^1513','Clear Creek ISD','NULL','TX','2023-5-2','Restricted'),
     ('C^2048','B^1513','Cypress-Fairbanks','NULL','TX','2023-5-2','Retained'),
     ('C^2049','B^1513','Fauquier County Public Schools','NULL','VA','2023-5-2','Under Review'),
     ('C^2050','B^1513','Fauquier County Public Schools','NULL','VA','2023-5-2','Under Review'),
     ('C^2051','B^1513','Katy','NULL','TX','2023-5-2','Restricted'),
     ('C^2052','B^1513','Katy','NULL','TX','2023-5-2','Under Review'),
     ('C^2053','B^1513','Katy ISD','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^2054','B^1513','Keller','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^2055','B^1513','Klein ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^2056','B^1513','Lindbergh School District','NULL','MO','2023-5-2','Under Review'),
     ('C^2057','B^1513','McKinney Independent School District','Collin County','TX','2023-5-2','Under Review'),
     ('C^2058','B^1513','Newport-Mesa Unifed School District','NULL','CA','2023-5-2','Banned/Removed'),
     ('C^2059','B^1513','North East Independent School District','Bexar County','TX','2023-5-2','Removed (Pending Review)'),
     ('C^2060','B^1513','Rochester Community Schools','NULL','MI','2023-5-2','Unknown'),
     ('C^2061','B^1513','Rockwood','NULL','MO','2023-5-2','Unknown'),
     ('C^2062','B^1513','St. Louis Region Schools','NULL','MO','2023-5-2','Unknown'),
     ('C^2063','B^1513','Collierville School District','Shelby County','TN','2023-5-2','Returned'),
     ('C^2064','B^1513','Tulsa Public Schools','NULL','OK','2023-5-2','Banned/Removed'),
     ('C^2065','B^1513','Wallingford-Swarthmore','NULL','PA','2023-5-2','Under Review'),
     ('C^2299','B^3484','Prosper ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^2307','B^1594','Gladwin Community Schools','NULL','MI','2023-5-2','Banned/Removed'),
     ('C^2580','B^1737','North Lamar Independent School District','NULL','TX','2023-5-2','Retained'),
     ('C^2658','B^1772','Granbury Independent School District','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^2659','B^1772','Collierville School District','Shelby County','TN','2023-5-2','Returned'),
     ('C^2722','B^1012','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^2723','B^1012','Jackson County School Board','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^2724','B^1012','Lee County School ','NULL','FL','2023-5-2','Retained'),
     ('C^2725','B^1012','Pleasant Valley School District','NULL','PA','2023-5-2','Restricted'),
     ('C^2726','B^1012','St. Lucie Public Schools','NULL','FL','2023-5-2','Removed (Pending Review)'),
     ('C^2727','B^1012','Walton County School District','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^2739','B^1811','Bedford County School District ','NULL','VA','2023-5-2','Retained'),
     ('C^2740','B^1811','Birdville','NULL','TX','2023-5-2','Unknown'),
     ('C^2741','B^1811','Madison County Schools','NULL','MS','2023-5-2','Restricted (Pending Review)'),
     ('C^2852','B^1840','Moore County Schools','NULL','NC','2023-5-2','Banned/Removed'),
     ('C^2898','B^1863','Canyons School District','NULL','UT','2023-5-2','Removed (Pending Review)'),
     ('C^2899','B^1863','Catawba County Schools','NULL','NC','2023-5-2','Under Review'),
     ('C^2900','B^1863','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^2969','B^1894','Collier County Public Schools','NULL','FL','2023-5-2','Retained'),
     ('C^2970','B^1894','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^3005','B^1918','Alamance-Burlinton School District','NULL','VA','2023-5-2','Unknown'),
     ('C^3006','B^1918','Bixby Public Schools','NULL','OK','2023-5-2','Retained'),
     ('C^3007','B^1918','Collier County Public Schools','NULL','FL','2023-5-2','Retained'),
     ('C^3008','B^1918','Cypress-Fairbanks','NULL','TX','2023-5-2','Restricted'),
     ('C^3009','B^1918','Davis School District','NULL','UT','2023-5-2','Under Review'),
     ('C^3010','B^1918','Downington Area School District','NULL','PA','2023-5-2','Returned'),
     ('C^3011','B^1918','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^3012','B^1918','Eanes','NULL','TX','2023-5-2','Retained'),
     ('C^3013','B^1918','Elizabethtown Area School District','NULL','PA','2023-5-2','Retained'),
     ('C^3014','B^1918','Fredericksburg ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^3015','B^1918','Granbury Independent School District','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^3016','B^1918','Greenville County','NULL','SC','2023-5-2','Under Review'),
     ('C^3017','B^1918','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^3018','B^1918','Katy','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^3019','B^1918','Keller','NULL','TX','2023-5-2','Restricted'),
     ('C^3020','B^1918','Keystone School District','NULL','PA','2023-5-2','Under Review'),
     ('C^3021','B^1918','Lamar Consolidated ISD','NULL','TX','2023-5-2','Banned/Removed'),
     ('C^3022','B^1918','McKinney Independent School District','Collin County','TX','2023-5-2','Under Review'),
     ('C^3023','B^1918','Murray City School District','NULL','UT','2023-5-2','Unknown'),
     ('C^3024','B^1918','North East Independent School District','Bexar County','TX','2023-5-2','Removed (Pending Review)'),
     ('C^3025','B^1918','St. Johns County School District','NULL','FL','2023-5-2','Unknown'),
     ('C^3026','B^1918','Stillwater Public Schools','NULL','OK','2023-5-2','Under Review'),
     ('C^3031','B^1918','Forsyth County Schools','NULL','GA','2023-5-2','Banned/Removed'),
     ('C^3033','B^1918','Ankeny Community School District','NULL','IO','2023-5-2','Restricted'),
     ('C^3034','B^1918','Blount County Schools','NULL','TN','2023-5-2','Banned/Removed'),
     ('C^3035','B^1918','Catawba County Schools','NULL','NC','2023-5-2','Retained'),
     ('C^3036','B^1918','Osceola','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^3037','B^1918','Eanes','NULL','TX','2023-5-2','Retained'),
     ('C^3121','B^1944','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^3122','B^1944','Hamilton County Schools','NULL','TN','2023-5-2','Removed (Pending Review)'),
     ('C^3187','B^1978','Broward County Public Schools','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^3191','B^1980','Eanes','NULL','TX','2023-5-2','Removed (Pending Review)'),
     ('C^3192','B^1980','Hamilton County Schools','NULL','TN','2023-5-2','Removed (Pending Review)'),
     ('C^3193','B^1980','Hillsborough','NULL','FL','2023-5-2','Unknown'),
     ('C^3194','B^1980','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^3195','B^1980','Murray City School District','NULL','UT','2023-5-2','Unknown'),
     ('C^3231','B^1037','Catawba County Schools','NULL','NC','2023-5-2','Under Review'),
     ('C^3232','B^1037','Collier County Public Schools','NULL','FL','2023-5-2','Unknown'),
     ('C^3233','B^1037','Fauquier County Public Schools','NULL','VA','2023-5-2','Under Review'),
     ('C^3234','B^1037','Forsyth County Schools','NULL','GA','2023-5-2','Banned/Removed'),
     ('C^3235','B^1037','Gladwin Community Schools','NULL','MI','2023-5-2','Banned/Removed'),
     ('C^3236','B^1037','Indian River County Schools ','NULL','FL','2023-5-2','Restricted'),
     ('C^3237','B^1037','Jackson County School Board','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^3238','B^1037','Murray City School District','NULL','UT','2023-5-2','Unknown'),
     ('C^3239','B^1037','Pleasant Valley School District','NULL','PA','2023-5-2','Restricted'),
     ('C^3240','B^1037','Polk County Schools','NULL','FL','2023-5-2','Returned'),
     ('C^3241','B^1037','Santa Rosa County District Schools','NULL','FL','2023-5-2','Removed (Pending Review)'),
     ('C^3242','B^1037','St. Lucie Public Schools','NULL','FL','2023-5-2','Removed (Pending Review)'),
     ('C^3243','B^1037','Walton County School District','NULL','FL','2023-5-2','Banned/Removed'),
     ('C^3462','B^1019','Bossier Parish Schools','NULL','LA','2023-5-2','Banned/Removed'),
     ('C^3463','B^1019','Central York School District','York County','PA','2023-5-2','Returned'),
     ('C^3464','B^1019','Collier County Public Schools','NULL','FL','2023-5-2','Retained'),
     ('C^3510','B^2108','Indian River County Schools ','NULL','FL','2023-5-2','Returned'),
     ('C^3511','B^2108','Murray City School District','NULL','UT','2023-5-2','Unknown'),
     ('C^3512','B^2108','North East Independent School District','Bexar County','TX','2023-5-2','Removed (Pending Review)')


GO
---FK18
alter table challenges_reasons 
    add CONSTRAINT fk_challenges_reasons_cr_challenge_id foreign key (cr_challenge_id)
    REFERENCES challenges (challenge_id)
GO

INSERT into user_levels
    (user_level_id, user_level_name)
    VALUES
     (1,'In Process'),
     (2,'Active'),
     (3,'Suspended'),
     (4,'Inactive'),
     (5,'Locked'),
     (6,'Author'),
     (7,'Educator'),
     (8,'Admin')
GO

INSERT into users
    (user_id, user_firstname, user_lastname, user_email, user_level_id)
    VALUES
         (1,'Ben','Dieck','ben.dieck@fudgemail.com',8),
     (2,'Sarah','Rapp','sarah.rapp@fudgemail.com',8),
     (3,'Diganta','Rashed','diganta.rashed@fudgemail.com',8),
     (4,'Jacquenetta','Dyminczuk','jacquenetta.dyminczuk@fudgemail.com',1),
     (5,'Kelsey','Kiszkorno','kelsey.kiszkorno@fudgemail.com',1),
     (6,'Terri-Jo','Cygielman','terri-jo.cygielman@fudgemail.com',1),
     (7,'Golda','Brodalko','golda.brodalko@fudgemail.com',1),
     (8,'Giffie','Orzeszko-Ostrejko','giffie.orzeszko-ostrejko@fudgemail.com',1),
     (9,'Cam','SubotiÄ‡','cam.subotiä‡@fudgemail.com',2),
     (10,'Gabey','Suchta-Stasiak','gabey.suchta-stasiak@fudgemail.com',2),
     (11,'Wilona','Gunarys','wilona.gunarys@fudgemail.com',2),
     (12,'Anselm','StacjoÅ„ski','anselm.stacjoå„ski@fudgemail.com',2),
     (13,'Pavla','Szfran','pavla.szfran@fudgemail.com',2),
     (14,'Mirella','Gryc-LeÅ›niak','mirella.gryc-leå›niak@fudgemail.com',2),
     (15,'Roberto','Drwota','roberto.drwota@fudgemail.com',2),
     (16,'Piet','ZboÅ¼ek','piet.zboå¼ek@fudgemail.com',2),
     (17,'See','Orysiak-GÃ³rna','see.orysiak-gã³rna@fudgemail.com',2),
     (18,'Nelle','Nadolski-Szkotnicki','nelle.nadolski-szkotnicki@fudgemail.com',2),
     (19,'Rolando','GÃ³ralczyk-Pyka','rolando.gã³ralczyk-pyka@fudgemail.com',2),
     (20,'Nanice','Feldfeber','nanice.feldfeber@fudgemail.com',2),
     (21,'Pennie','Rozalew','pennie.rozalew@fudgemail.com',2),
     (22,'Sybille','Adamek-Kucharz','sybille.adamek-kucharz@fudgemail.com',2),
     (23,'Carrie','Karniszewski','carrie.karniszewski@fudgemail.com',2),
     (24,'Mag','Rzeszuttek','mag.rzeszuttek@fudgemail.com',2),
     (25,'Garrot','Sawoniewski-Zejer','garrot.sawoniewski-zejer@fudgemail.com',2),
     (26,'Rinaldo','WeretyÅ„ski-Wasilewski','rinaldo.weretyå„ski-wasilewski@fudgemail.com',2),
     (27,'Lamar','Niewojt','lamar.niewojt@fudgemail.com',3),
     (28,'Avraham','Karaban','avraham.karaban@fudgemail.com',3),
     (29,'Trevor','Walika','trevor.walika@fudgemail.com',4),
     (30,'Meridith','Fella','meridith.fella@fudgemail.com',4),
     (31,'Ace','ÅšwiÄ…tnicki-Pietrzak','ace.åšwiä…tnicki-pietrzak@fudgemail.com',6),
     (32,'Nathan','Dieck','nathan.dieck@fudgemail.com',7)

GO

INSERT into ratings
    (rating_id, rating_book_id, rating_review_score, rating_review_summary)
    VALUES
     (1,'B^1007',4,'Really weird book. Not sure why it’s a classic. Oddly quatable. '),
     (2,'B^2393',6,'Good overall read for any age group. Ending was a little weird. '),
     (3,'B^2208',8,'Good read. I think it mostly speaks to how ludicrous war is. '),
     (4,'B^2108',7,'Important perspective of coming of age and coming out at the same time. Good read. '),
     (5,'B^2465',6,'This book sure makes me want to question authority. '),
     (6,'B^2607',8,'Touching childrens book about how changes in family doesn''t change the bonds that make up family. '),
     (7,'B^1275',6,'Well composed. Great ideas about how to deal with growing up and dealing with loss. '),
     (8,'B^3680',7,'A narrative that might make youth not feel like they are the only ones that feel like self harming. '),
     (9,'B^1894',5,'Fairly depressing narrative but dealing with real circumstance of a girl with an alcoholic dad.  '),
     (10,'B^1737',9,'I thought it was chilling in the way that you  guess the narrative, and then are probably wrong. '),
     (11,'B^1513',8,'Cool comic about being gay at summer camp. 1.8 rating at target suggests something of an audience. '),
     (12,'B^1367',7,'Childrens book that assists talking about getting a divorce and moving in with your partner. '),
     (13,'B^3360',9,'Semi-Autobiographical book about coming of age and facing hard truths, and adult realities. '),
     (14,'B^1008',7,'Pretty emotional story about a friendship that falls apart because of transgender issues. '),
     (15,'B^1770',7,'Helpful book to assist in talking about a tough communication subject. ')

GO


-----------------------

--Verify

select * from books
select * from authors
select * from challenges
select * from authors_books
select * from challenges_reasons
select * from reasons
select * from ratings
select * from users
select * from banned_apps



--------------- Queries and procedures

GO

------------------------------------------------- CREATE USER


drop procedure if exists [dbo].[p_create_user]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[p_create_user]
(
	@user_firstname varchar(50),
	@user_lastname varchar(50),
    @user_email varchar(100)
)
as begin
begin transaction 
begin TRY
   


	    declare @user_level_id int
        declare @user_id int
	
	    -- User Level is In-Process
	    set @user_level_id = 1
	
	    -- Create new surrogate id for user id
	    set @user_id = (select max(user_id) from users) +1 
    -----Trying to see if this'll catch dupe accounts
	    if (@user_email = (select user_email from users where user_email = @user_email)) 
		    THROW 50001 , 'User account already exists.', 1; 
    
		
	    -- Insert statement		
	    insert into users (user_id, user_firstname, user_lastname, user_email, user_level_id)
		    values (@user_id, @user_firstname, @user_lastname, @user_email, @user_level_id)
           -- if @@ROWCOUNT <>1 throw 50006, 'p_place_bid: Insert error.',1
	    
	    -- 
    
    COMMIT TRANSACTION
    print 'It worked.'
    return  @@identity 
    end TRY
    
    begin CATCH
        ROLLBACK
        ;
        THROW
    end catch
END


GO

exec dbo.p_create_user @user_firstname = Jimmy, @user_lastname = Steffens, @user_email = 'Jimmy_Is_Cool@dogmail.com' 

GO

select * from users


----------------------------------------------------------- ANARCHY LIBRARY


drop procedure if exists [dbo].[p_anarchy_lib]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[p_anarchy_lib]
as begin
begin transaction 
begin TRY
   
        select top 1 b.book_title, a.author_firstname + ' ' + a.author_lastname as author_name
        from books as b 
        join authors_books as ab on ab.ab_book_id = b.book_id 
        join authors as a on ab.ab_author_id = a.author_id  
        order by NEWID()

        
    COMMIT TRANSACTION
    end TRY
    
    begin CATCH
        ROLLBACK
        ;
        THROW
    end catch
END


GO

exec dbo.p_anarchy_lib 

GO




-------------------------------------------------- Describe a book, tell me where it gets banned

drop procedure if exists [dbo].[p_concept_search]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[p_concept_search]
(
	@statement_1 varchar(100),
	@statement_2 varchar(100),
    @statement_3 varchar(100),
    @statement_4 varchar(100),
    @statement_5 varchar(100)
)
as begin
begin transaction 
begin TRY
   
    
    
     
     with reasons_list as (select reason_id from reasons 
                where reason_descriptor LIKE '%' + @statement_1 + '%'
                or reason_descriptor LIKE '%' + @statement_2 + '%'
                OR reason_descriptor LIKE '%' + @statement_3 + '%'
                or reason_descriptor LIKE '%' + @statement_4 + '%'
               or reason_descriptor LIKE '%' + @statement_5 + '%')

  
    SELECT count(c.challenge_id) as number_of_challenges, c.challenge_school_district, 
            c.challenge_county, c.challenge_state 
    FROM challenges as c 
    join challenges_reasons as cr on c.challenge_id = cr.cr_challenge_id
    join reasons_list as r on cr.cr_reason_id = r.reason_id
     where r.reason_id = cr.cr_reason_id
     group by challenge_school_district, challenge_county, challenge_state
     order by number_of_challenges desc

    
	    -- 
    
    COMMIT TRANSACTION
    print 'It worked.'
    return  @@identity 
    end TRY
    
    begin CATCH
        ROLLBACK
        ;
        THROW
    end catch
END


GO

exec dbo.p_concept_search @statement_1 = 'lgbt', @statement_2 = 'sex',  @statement_3 = 'alcohol', 
@statement_4 = 'profanity', @statement_5 ='mature'



------------------------------------- Most hostile states
use banned_app

go


select top 10 count(challenge_id) as number_challenges , challenge_state
from challenges
group by challenge_state
order by number_challenges desc


----------------------------------- What schools have challenged the most on a given topic. 
-- For instance, what schools have challenged the most books on lgbt issues? 

use banned_app

go



select top 10 count(c.challenge_id) as number_challenges , c.challenge_school_district ,c.challenge_state, r.reason_descriptor
from challenges as c 
    join challenges_reasons as cr on c.challenge_id = cr.cr_challenge_id
    join reasons as r on cr.cr_reason_id = r.reason_id
    where r.reason_descriptor like '%lgbt%'
group by c.challenge_state, c.challenge_school_district, r.reason_descriptor
order by number_challenges desc

-----------------Sarahs book recommender by topic

GO

drop procedure if exists dbo.p_book_recommender

GO

CREATE PROCEDURE dbo.p_book_recommender(

 @reason_descriptor varchar(100)

)as BEGIN

    BEGIN TRY

        BEGIN TRANSACTION

        select top 3 b.book_title, a.author_firstname + ' ' + a.author_lastname as author_name, 
        r.rating_review_score, max(re.reason_descriptor), max(c.challenge_state), max(c.challenge_school_district)

            from dbo.books as b

                JOIN dbo.ratings as r on b.book_id = r.rating_book_id

                JOIN dbo.challenges as c on b.book_id = c.challenge_book_id

                JOIN dbo.challenges_reasons as cr on cr.cr_challenge_id = c.challenge_id

                JOIN dbo.reasons as re on re.reason_id = cr.cr_reason_id

                join authors_books as ab on b.book_author_id= ab.ab_id

                join dbo.authors as a on ab.ab_author_id = a.author_id

                where re.reason_descriptor like @reason_descriptor

                GROUP BY r.rating_review_score, b.book_title, a.author_firstname, a.author_lastname

                ORDER BY r.rating_review_score

       COMMIT TRANSACTION
    print 'It worked.'
    return  @@identity 
    end TRY
    
    begin CATCH
        ROLLBACK
        ;
        THROW
    end catch
END


GO


exec dbo.p_book_recommender 'lgbt'


GO
---------------------------- Most Frequently Banned Topics, sorted by book.

drop procedure if exists [dbo].[p_freq_ban]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[p_freq_ban]
as BEGIN   
    BEGIN TRANSACTION
    BEGIN TRY
        select b.book_title, r.reason_descriptor, r.reason_freq
        FROM books as b 
            JOIN challenges as c on b.book_id = c.challenge_book_id
            JOIN challenges_reasons as cr on cr.cr_challenge_id = c.challenge_id
            JOIN reasons as re on re.reason_id = cr.cr_reason_id
            join reasons as r on r.reason_id = cr.cr_reason_id
        GROUP BY b.book_title, r.reason_descriptor, r.reason_freq
        ORDER BY r.reason_freq DESC
    COMMIT TRANSACTION
    END TRY

    BEGIN CATCH 
        ROLLBACK
        ;
    END CATCH

END

GO

EXEC [dbo].[p_freq_ban]

GO


---------------------------- Most Hostile States

drop procedure if exists [dbo].[p_hostile_state]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[p_hostile_state]
as begin 
    begin transaction 
    begin TRY 
        select challenge_state, COUNT(*) AS number_of_challenges 
        FROM challenges
        GROUP BY challenge_state
        ORDER by number_of_challenges  DESC
    COMMIT transaction 
    end TRY 

    begin CATCH
        ROLLBACK
        ;
    END CATCH
END

GO 

EXEC [dbo].[p_hostile_state]    
GO

-------------------------------- Auto calculate author age 

drop procedure if exists [dbo].[p_author_age]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[p_author_age]
as BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        SELECT author_firstname + ' ' + author_lastname AS author_name,
            ROUND((DATEDIFF(DAY, author_birthdate, GETDATE()) / 365.25), 0) AS AGE
        FROM authors
        WHERE author_birthdate IS NOT NULL
    COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        ROLLBACK
        ;
    END CATCH
END

GO 

EXEC [dbo].[p_author_age]

GO

---------------------- Most Hostile School Districts 

drop procedure if exists [dbo].[p_hostile_dist]
GO 
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER OFF 
GO 

create procedure [dbo].[p_hostile_dist]
as BEGIN
    BEGIN TRANSACTION 
    BEGIN TRY 
        select challenge_school_district, challenge_state,  COUNT(*) AS dist_count
        FROM challenges
        GROUP BY challenge_school_district, challenge_state
        ORDER BY dist_count DESC 
    COMMIT TRANSACTION
    END TRY 

    BEGIN CATCH 
        ROLLBACK
        ;
    END CATCH 
END 

GO 

exec [dbo].[p_hostile_dist]
GO 

---------------------------------------- Most Frequently Banned Keywords

drop PROCEDURE if exists [dbo].[p_freq_words]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER OFF 
GO 

create procedure [dbo].[p_freq_words]
as BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        select reason_descriptor, reason_freq as times_reason_challenged, COUNT(*) AS times_in_books
        FROM reasons 
        GROUP BY reason_freq, reason_descriptor
        ORDER BY times_reason_challenged DESC
    COMMIT TRANSACTION
    END TRY

    BEGIN CATCH 
        ROLLBACK
        ;
    END CATCH
END

GO 

exec [dbo].[p_freq_words]
GO


select * from reasons

------------- Most banned books

drop procedure if exists [dbo].[p_count_book_challenge]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[p_count_book_challenge]
as BEGIN   
    BEGIN TRANSACTION
    BEGIN TRY
        select b.book_title, count(c.challenge_id) as times_challenged
        FROM books as b 
            JOIN challenges as c on b.book_id = c.challenge_book_id
            JOIN challenges_reasons as cr on cr.cr_challenge_id = c.challenge_id
          
        GROUP BY b.book_title
        ORDER BY times_challenged DESC
    COMMIT TRANSACTION
    END TRY

    BEGIN CATCH 
        ROLLBACK
        ;
    END CATCH

END

GO

EXEC [dbo].[p_count_book_challenge]

GO

