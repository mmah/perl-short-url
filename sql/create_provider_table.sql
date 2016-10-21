drop table if exists sand_box.short_url_log;
create table sand_box.short_url_log (
   short_url            text primary key,
   long_url             text not null,
   create_time          timestamp default now(),
   created_by           text not null,
   expires              timestamp default (now()+'1 year'::interval)
);
