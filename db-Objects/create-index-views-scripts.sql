-- Ürün satışları görünümü

CREATE VIEW ProductSales WITH SCHEMABINDING AS
SELECT
     oi.product_id,
     COUNT_BIG(*) AS sales_count,
     SUM(oi.total) AS total_sales
FROM
     ECommerceDB.dbo.OrderItems oi
GO

CREATE UNIQUE CLUSTERED INDEX idx_ProductSales ON ProductSales (product_id);
GO