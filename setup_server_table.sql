-- Kiểm tra xem tblServer đã có dữ liệu không
SELECT COUNT(*) as server_count FROM tblServer;
SELECT * FROM tblServer;

-- Nếu chưa có, thêm nhân viên vào tblServer
-- Lấy ID của nhân viên Server (username: server001, server002, v.v)
SELECT id, fullName, username FROM tblUser WHERE username LIKE 'server%' OR username LIKE 'staff%';

-- Thêm vào tblServer (nếu chưa có)
INSERT IGNORE INTO tblServer (tblStafftblUserId)
SELECT id FROM tblUser 
WHERE username IN ('server001', 'server002', 'staff001', 'staff002', 'staff003')
  AND role = 'STAFF';

-- Kiểm tra kết quả
SELECT * FROM tblServer;
SELECT s.tblUserId, u.fullName, u.username FROM tblStaff s 
JOIN tblUser u ON s.tblUserId = u.id;
