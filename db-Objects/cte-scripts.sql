-- Son 30 gündeki siparişler
WITH RecentOrders AS (
     SELECT
          o.order_id,
          o.order_date,
          u.first_name,
          u.last_name,
          o.total_amount
     FROM
          Orders o
     JOIN
          Users u ON o.user_id = u.user_id
     WHERE
          o.order_date >= DATEADD(DAY, -30, GETDATE())
)
SELECT *
FROM RecentOrders
ORDER BY order_date DESC;