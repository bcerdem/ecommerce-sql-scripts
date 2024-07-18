CREATE FUNCTION CalculateDiscontedPrice
(
     @product_id INT,
     @discount_rate DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
     DECLARE @original_price DECIMAL(10,2);

     SELECT @original_price = price
     FROM Products
     WHERE product_id = @product_id

     RETURN @original_price -  (@original_price * @discount_rate / 100);
END;