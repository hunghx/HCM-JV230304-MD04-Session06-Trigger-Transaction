-- Trigger 
-- CREATE TRIGGER trigger_name
-- (AFTER | BEFORE )  (INSERT | UPDATE | DELETE ) 
-- ON table_name FOR EACH ROW  
-- BEGIN 
--  .....
-- END;

-- Ví dụ xóa lop học có id =1 
delete from classes where id = 1;

-- sử dụng trigger để xóa các học sinh có trong lớp trước 
drop trigger before_delete_classes;
delimiter //
create trigger before_delete_classes 
before DELETE on classes
for each row 
begin
         set @id = OLD.id;
         -- OLD.id : id của classes cần xóa
         -- tien hành xóa học sinh thuoc class đay
         delete from student where class_id = @id;
end;
delimiter;

-- bài tập áp dụng : trong bảng classes có 1 cột là soluongsinhvien
-- sau khi them moi 1 sinh vien vao bảng sinh viên thi tang số lượng
-- sinh viên trong class đó lên 1;
delimiter //
create trigger after_insert_student
after INSERT on student
for each row 
begin
    -- cập nhật
    update classes set soluongsv = soluongsv+1 where id =  new.class_id;
end;
delimiter;

insert into student(name, phone, age, class_id) 
value ('hugnhx', '03054898',19, 2);


-- transation : gôm nhiều thao tác
-- Cú pháp
-- Start Transaction ;
-- COMMIT ; -- lưu thao tác
-- ROLLBACK ; -- hủy bỏ các thao tác và quay về thời điểm bắt đầu

-- ví dụ tạo 1 thủ tục chuyển tiền
-- trừ tiền tài khoản này và cộng tiền tài khoản khác 

drop procedure tranfer_money;
Delimiter //
create procedure tranfer_money
(sotien int, id_send int , id_receive int)
begin 
        start transaction;
        SET autocommit = 0;
        update account set balance = balance + sotien where id = id_receive;
        update account set balance = balance - sotien where id = id_send;
        commit;
end ;
delimiter;


call send_money(1, 2,200);