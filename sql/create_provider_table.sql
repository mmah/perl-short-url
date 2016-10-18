drop table if exists short_url_log;
create table short_url_log (
   short_url_id         serial primary key,
   short_url            text not null,
   long_url             text not null,
   create_time          timestamp default now(),
   created_by           text,
   expires              timestamp default (now()+'1 year'::interval
);
