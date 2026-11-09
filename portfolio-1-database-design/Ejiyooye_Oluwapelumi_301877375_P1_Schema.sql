-- E-commerce Platform: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customer" (
  "customer_id" bigint NOT NULL,
  "email" text NOT NULL,
  "display_name" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_customer" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."product" (
  "product_id" bigint NOT NULL,
  "sku" text NOT NULL,
  "name" text NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_product" PRIMARY KEY ("product_id"),
  CONSTRAINT "uq_product_0" UNIQUE ("sku")
);
CREATE TABLE portfolio."order_header" (
  "order_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "ordered_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_order_header" PRIMARY KEY ("order_id")
);
CREATE TABLE portfolio."order_item" (
  "order_item_id" bigint NOT NULL,
  "order_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "quantity" bigint NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_order_item" PRIMARY KEY ("order_item_id")
);
ALTER TABLE portfolio."order_header" ADD CONSTRAINT "fk_order_header_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customer" ("customer_id");
ALTER TABLE portfolio."order_item" ADD CONSTRAINT "fk_order_item_0" FOREIGN KEY ("order_id") REFERENCES portfolio."order_header" ("order_id");
ALTER TABLE portfolio."order_item" ADD CONSTRAINT "fk_order_item_1" FOREIGN KEY ("product_id") REFERENCES portfolio."product" ("product_id");
ALTER TABLE portfolio."order_item" ADD CONSTRAINT "item_quantity_positive" CHECK ("quantity" > 0);
ALTER TABLE portfolio."order_item" ADD CONSTRAINT "item_price_nonnegative" CHECK ("unit_price" >= 0);
ALTER TABLE portfolio."order_header" ADD CONSTRAINT "order_status_allowed" CHECK (("status" = 'pending') OR ("status" = 'paid') OR ("status" = 'cancelled') OR ("status" = 'shipped'));
COMMIT;
