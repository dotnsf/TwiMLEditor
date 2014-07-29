
create table twimls(id int not null generated always as identity(start with 1 increment by 1 no cache), title varchar(255), userid varchar(20), username varchar(255), is_public int, twiml xml, created timestamp, updated timestamp)

insert into twimls( '', '', '', 1, '<Response><Say language="ja-JP" voice="alice">お も て な し</Say></Response>', 0, 0 );
insert into twimls( '', '', '', 1, '<Response><Say language="ja-JP" voice="alice">倍返しだ！</Say></Response>', 0, 0 );
insert into twimls( '', '', '', 1, '<Response><Say language="en" voice="man">Hello. What are you going do today?</Say></Response>', 0, 0 );
insert into twimls( '', '', '', 1, '<Response><Say language="en" voice="woman">Hello. What are you going do today?</Say></Response>', 0, 0 );
insert into twimls( '', '', '', 1, '<Response><Say language="ja-JP" voice="alice">もももすもももももはもも</Say></Response>', 0, 0 );
insert into twimls( '', '', '', 1, '<Response><Say language="fr" voice="woman">Je t'aime.</Say></Response>', 0, 0 );

