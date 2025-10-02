USE QLDA;
------------------------------------------------------1.1
SELECT nv.TENNV,
       CASE 
         WHEN nv.LUONG < (SELECT AVG(LUONG) 
                          FROM NHANVIEN 
                          WHERE PHG = nv.PHG)
         THEN N'TangLuong'
         ELSE N'KhongTangLuong'
       END AS TrangThai
FROM NHANVIEN nv;
------------------------------------------------------1.2
SELECT nv.TENNV,
       CASE 
         WHEN nv.LUONG < (SELECT AVG(LUONG) 
                          FROM NHANVIEN 
                          WHERE PHG = nv.PHG)
         THEN N'NhanVien'
         ELSE N'TruongPhong'
       END AS LoaiNV
FROM NHANVIEN nv;
------------------------------------------------------1.3
SELECT CASE 
         WHEN PHAI LIKE N'Nam' THEN N'Ông ' + TENNV
         WHEN PHAI LIKE N'N?'  THEN N'Bà ' + TENNV
         ELSE TENNV
       END AS HoTenTheoPhai
FROM NHANVIEN;
------------------------------------------------------1.4
SELECT TENNV, LUONG,
       CASE 
         WHEN LUONG > 0     AND LUONG < 25000 THEN LUONG * 0.10
         WHEN LUONG >=25000 AND LUONG < 30000 THEN LUONG * 0.12
         WHEN LUONG >=30000 AND LUONG < 40000 THEN LUONG * 0.15
         WHEN LUONG >=40000 AND LUONG < 50000 THEN LUONG * 0.20
         WHEN LUONG >=50000 THEN LUONG * 0.25
         ELSE 0
       END AS Thue
FROM NHANVIEN;
------------------------------------------------------2.1
DECLARE @i int = 0;

WHILE @i <= (SELECT MAX(CAST(MANV AS int)) FROM NHANVIEN)
BEGIN
    SET @i = @i + 1;

    IF @i % 2 = 0
       SELECT HONV, TENLOT, TENNV
       FROM NHANVIEN
       WHERE MANV = RIGHT('000' + CAST(@i AS varchar(3)),3); -- MANV dạng chuỗi
END
------------------------------------------------------2.2
DECLARE @i int = 0;

WHILE @i <= (SELECT MAX(CAST(MANV AS int)) FROM NHANVIEN)
BEGIN
    SET @i = @i + 1;

    IF @i % 2 = 0 AND @i <> 4
       SELECT HONV, TENLOT, TENNV
       FROM NHANVIEN
       WHERE MANV = RIGHT('000' + CAST(@i AS varchar(3)),3);
END
------------------------------------------------------3.1
BEGIN TRY
    INSERT INTO PHONGBAN(TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
    VALUES (N'TestPhong', 99, NULL, GETDATE());

    PRINT N'Thêm dữ liệu thành công';
END TRY
BEGIN CATCH
    PRINT N'Thêm dữ liệu thất bại';
END CATCH;
------------------------------------------------------3.2
DECLARE @chia int = 10, @mau int = 0;

BEGIN TRY
    DECLARE @kq int;
    SET @kq = @chia / @mau;  -- l?i chia 0
END TRY
BEGIN CATCH
    RAISERROR(N'Lỗi: phép chia cho 0 không hợp lệ',16,1);
END CATCH;
