-- Table: short_url_lookup

-- DROP TABLE short_url_lookup;

CREATE TABLE short_url_lookup
(
  id serial NOT NULL,
  short_url text NOT NULL,
  long_url text NOT NULL,
  app_name text NOT NULL,
  expire_date timestamp without time zone NOT NULL DEFAULT (now() + '1 year'::interval),
  create_user text NOT NULL DEFAULT "current_user"(),
  create_date timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT short_url_lookup_pkey PRIMARY KEY (id),
  CONSTRAINT short_url_lookup_uniq1 UNIQUE (short_url),
  CONSTRAINT short_url_lookup_app_name_check CHECK (app_name = ANY (ARRAY['HCRE'::text, 'HCRP'::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE short_url_lookup
  OWNER TO vidb;
GRANT ALL ON TABLE short_url_lookup TO vidb;
GRANT ALL ON TABLE short_url_lookup TO perl_app;

-- Index: short_url_lookup_idx1

-- DROP INDEX short_url_lookup_idx1;

CREATE UNIQUE INDEX short_url_lookup_idx1
  ON short_url_lookup
  USING btree
  (short_url);

