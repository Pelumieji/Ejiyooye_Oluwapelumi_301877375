-- Use two psql terminals connected to the same exercise database.
-- Follow the numbered order across Session A and Session B.

-- 2. Session B: also read 1 before A writes.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "product_id", "p3_processed_count" FROM portfolio."product" WHERE "product_id" IS NOT DISTINCT FROM 2;

-- 4. Session B: write its stale value. The final count is 2, so one increment is lost.
UPDATE portfolio."product" SET "p3_processed_count" = 2 WHERE "product_id" IS NOT DISTINCT FROM 2 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "product_id", "p3_processed_count" FROM portfolio."product" WHERE "product_id" IS NOT DISTINCT FROM 2;

-- 7. Session B: request the same row lock. This statement waits.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "product_id", "p3_processed_count" FROM portfolio."product" WHERE "product_id" IS NOT DISTINCT FROM 2 FOR UPDATE;

-- 9. Session B: its SELECT now returns 2. Apply the second increment and commit.
UPDATE portfolio."product" SET "p3_processed_count" = 3 WHERE "product_id" IS NOT DISTINCT FROM 2 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "product_id", "p3_processed_count" FROM portfolio."product" WHERE "product_id" IS NOT DISTINCT FROM 2;
