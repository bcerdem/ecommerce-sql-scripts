-- Kullanıcı Güncellemeleri İçin Denetim Tetikleyicisi

CREATE TABLE UserAudit (
    audit_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    change_type VARCHAR(10),
    change_date DATETIME DEFAULT GETDATE(),
    old_email VARCHAR(100),
    new_email VARCHAR(100),
    old_phone VARCHAR(15),
    new_phone VARCHAR(15)
);
GO

CREATE TRIGGER trg_UserUpdateAudit
ON Users
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO UserAudit (user_id, change_type, old_email, new_email, old_phone, new_phone)
    SELECT 
        i.user_id,
        'UPDATE',
        d.email AS old_email,
        i.email AS new_email,
        d.phone AS old_phone,
        i.phone AS new_phone
    FROM Inserted i
    JOIN Deleted d ON i.user_id = d.user_id;
END;
GO
