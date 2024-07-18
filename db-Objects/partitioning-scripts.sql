-- Sipariş Tablosu Bölümleme
-- Partition Function
CREATE PARTITION FUNCTION OrderDateRangePF (DATETIME)
AS RANGE RIGHT FOR VALUES ('2023-01-01', '2024-01-01', '2025-01-01');
GO

-- Partition Scheme
CREATE PARTITION SCHEME OrderDateRangePS
AS PARTITION OrderDateRangePF
ALL TO ([PRIMARY]);
GO

-- Orders Tablosunu Yeniden Oluşturma
CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    shipping_address_id INT,
    billing_address_id INT,
    payment_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (shipping_address_id) REFERENCES Addresses(address_id),
    FOREIGN KEY (billing_address_id) REFERENCES Addresses(address_id),
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
) ON OrderDateRangePS(order_date);
GO
