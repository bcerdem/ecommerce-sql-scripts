CREATE VIEW UserOrders AS
SELECT 
     u.user_id,
     u.first_name,
     u.last_name,
     o.order_id,
     o.order_date,
     o.order_status,
     o.total_amount,
     p.payment_method,
     p.payment_status
FROM 
     Users u
JOIN
     Orders o ON u.user_id = o.user_id
JOIN
     Payments p ON o.payment_id = p.payment_id
