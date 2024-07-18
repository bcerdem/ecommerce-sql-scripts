-- Create a new stored procedure called 'CreateOrder' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
     FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'CreateOrder'
     AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.CreateOrder
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.CreateOrder
    @user_id INT,
    @total_amount DECIMAL(10,2),
    @shipping_address_id INT,
    @billing_address_id INT,
    @payment_method VARCHAR(50),
    @product_ids VARCHAR(MAX),
    @quantities VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @order_id INT;
    DECLARE @payment_id INT;

    -- Kullanıcı ID'sinin geçerli olup olmadığını kontrol et
    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @user_id)
    BEGIN
        RAISERROR('Geçersiz user_id: %d', 16, 1, @user_id);
        RETURN;
    END

    -- Sipariş Oluştur
    INSERT INTO Orders (user_id, total_amount, shipping_address_id, billing_address_id, order_status)
    VALUES (@user_id, @total_amount, @shipping_address_id, @billing_address_id, 'Pending');

    SET @order_id = SCOPE_IDENTITY();

    -- Ödeme Oluştur
    INSERT INTO Payments (order_id, payment_method, amount, payment_status)
    VALUES (@order_id, @payment_method, @total_amount, 'Pending');

    SET @payment_id = SCOPE_IDENTITY();

    -- Sipariş öğelerini ekle
    INSERT INTO OrderItems (order_id, product_id, quantity, price, total)
    SELECT @order_id, p.product_id, oi.quantity, p.price, p.price * oi.quantity
    FROM Products p
    JOIN (
        SELECT
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
            CAST(value AS INT) AS product_id
        FROM STRING_SPLIT(@product_ids, ',')
    ) pid ON p.product_id = pid.product_id
    JOIN (
        SELECT
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
            CAST(value AS INT) AS quantity
        FROM STRING_SPLIT(@quantities, ',')
    ) oi ON pid.rn = oi.rn;

    -- Ödeme kimliğini siparişe ekle
    UPDATE Orders
    SET payment_id = @payment_id
    WHERE order_id = @order_id;

    -- Çıktı olarak sipariş ID'si döndür
    SELECT @order_id as OrderID;
END
GO

-- example to execute the stored procedure we just created
EXECUTE dbo.CreateOrder 1, 100.00, 2, 3, 'Credit Card', '1,2,3', '10,20,30'
GO
