-- Unique Constraint on Products name
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (product_name);;

-- Foreign Key Constraints for ProductReviews
ALTER TABLE ProductReviews
ADD CONSTRAINT FK_ProductReviews_Products FOREIGN KEY (product_id) REFERENCES Products(product_id);

-- Foreign Key Constraints for Addresses
ALTER TABLE Addresses
ADD CONSTRAINT FK_Addresses_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

-- Foreign Key Constraints for OrderItems
ALTER TABLE OrderItems
ADD CONSTRAINT FK_OrderItems_Products FOREIGN KEY (product_id) REFERENCES Products(product_id);

-- Indexes
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_product_category ON Products(category_id);
CREATE INDEX idx_order_user ON Orders(user_id);
CREATE INDEX idx_order_payment ON Orders(payment_id);
CREATE INDEX idx_orderitem_order ON OrderItems(order_id);
CREATE INDEX idx_orderitem_product ON OrderItems(product_id);