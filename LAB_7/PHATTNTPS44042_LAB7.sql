--LAB 7
USE QLDA
-- Bài 1.1- Nhập MaNV -> Biết tuổi 
SELECT * FROM NHANVIEN
GO
--Table Checking--
CREATE OR ALTER VIEW v_Tuoi_NV AS
SELECT 
    MANV,
    NGSINH,
    YEAR(GETDATE()) - YEAR(NGSINH)
        - CASE 
            WHEN (MONTH(GETDATE()) < MONTH(NGSINH)) 
                 OR (MONTH(GETDATE()) = MONTH(NGSINH) AND DAY(GETDATE()) < DAY(NGSINH))
            THEN 1 ELSE 0 
          END AS TUOI
FROM NHANVIEN;
GO
--Tester--
SELECT * FROM v_Tuoi_NV WHERE MANV = N'001'
GO
--=====================================================================================--
-- Bài 1.2 - Nhập MA_NVIEN -> Số lượng DA của nhân viên đó
SELECT * FROM PHANCONG
GO
--Table Checking--
CREATE OR ALTER VIEW v_SoLuongDA_NV AS
SELECT 
    MA_NVIEN,
    COUNT(MaDA) AS SoLuongDeAn
FROM PHANCONG
GROUP BY MA_NVIEN;
GO
--Tester--
SELECT * FROM v_SoLuongDA_NV WHERE MA_NVIEN = N'001'
GO
--=====================================================================================--
-- Bài 1.3 Nhập Nam/Nữ -> Tổng số nvien của phái đó
SELECT * FROM NHANVIEN
GO
--Table Checking--
CREATE OR ALTER VIEW v_SoLuongNVTheoPhai AS
SELECT
    PHAI,
    COUNT(PHAI) AS SoLuongNVTheoPhai
FROM NHANVIEN
GROUP BY PHAI;
GO
--Tester--
SELECT * FROM v_SoLuongNVTheoPhai WHERE PHAI =N'Nam'
SELECT * FROM v_SoLuongNVTheoPhai WHERE PHAI =N'Nữ'
--=====================================================================================--
-- Bài 1.4 Nhập tên phòng -> Tính mức lương TB phòng đó + Cho biết họ tên NV có mức lương > lương tb
SELECT * FROM NHANVIEN
GO
--Table Checkin--
CREATE OR ALTER VIEW v_NV_LuongTrenTrungBinh AS
SELECT 
    HONV,
    TENLOT,
    TENNV,
    LUONG,
    PHG,
    (SELECT AVG(LUONG)
     FROM NHANVIEN NV2
     WHERE NV2.PHG = NV1.PHG) AS LuongTBPhong
FROM NHANVIEN NV1
WHERE LUONG > (
    SELECT AVG(LUONG)
    FROM NHANVIEN NV3
    WHERE NV3.PHG = NV1.PHG
);
GO
--Tester--
SELECT * FROM v_NV_LuongTrenTrungBinh WHERE PHG = N'1';
SELECT * FROM v_NV_LuongTrenTrungBinh WHERE PHG = N'4';
SELECT * FROM v_NV_LuongTrenTrungBinh WHERE PHG = N'5';
--=====================================================================================--
-- Bài 1.5 Nhập Mã phòng -> Hiện tên phòng ban, mã người trưởng phòng , Số lượng đề án
SELECT * FROM PHONGBAN
SELECT * FROM DEAN
GO
--Table Checking--
CREATE OR ALTER VIEW v_PhongBan_DeAn AS
SELECT 
    PB.MAPHG AS MaPhong,
    PB.TRPHG AS TruongPhong,
    COUNT(DA.MADA) AS SoLuongDeAn
FROM PHONGBAN PB
LEFT JOIN DEAN DA ON PB.MAPHG = DA.PHONG   -- ✅ Match INT = INT
GROUP BY PB.MAPHG, PB.TRPHG;               -- ✅ Include both non-aggregated columns
GO
--Tester--
SELECT * 
FROM v_PhongBan_DeAn
WHERE MaPhong = 4;
GO
--=====================================================================================--
-- Bài 2.1 H.thị HoNV,TenNV,TenPHG,DiaDiemPhg
SELECT * FROM NHANVIEN
SELECT * FROM DIADIEM_PHG
SELECT * FROM PHONGBAN
GO
--Table Checking--
CREATE OR ALTER VIEW v_ThongTin_NV AS
SELECT
    NV.HONV AS HoNV,
    NV.TENNV AS TenNV,
    PB.TENPHG AS TenPhg,
    DP.DIADIEM AS DiaDiemPhg
FROM NHANVIEN NV
LEFT JOIN PHONGBAN PB ON PB.MAPHG = NV.PHG
LEFT JOIN DIADIEM_PHG DP ON DP.MAPHG = NV.PHG
GO
--Tester--
SELECT * FROM v_ThongTin_NV WHERE DiaDiemPhg = N'Hà Nội'
GO
--=====================================================================================--
-- Bài 2.2 H.thị TenNV,LUONG,Tuoi
SELECT * FROM NHANVIEN
GO
--Table Checking--
CREATE OR ALTER VIEW v_NV_Luong_Tuoi AS
SELECT
    MANV,
    TENNV,
    LUONG,
        YEAR(GETDATE()) - YEAR(NGSINH)
        - CASE 
            WHEN (MONTH(GETDATE()) < MONTH(NGSINH)) 
                 OR (MONTH(GETDATE()) = MONTH(NGSINH) AND DAY(GETDATE()) < DAY(NGSINH))
            THEN 1 ELSE 0 
          END AS TUOI
FROM NHANVIEN
GO
--Tester--
SELECT * FROM v_NV_Luong_Tuoi 
GO
--=====================================================================================--
-- Bài 2.3 H.thị tên PHONGBAN và Phòng ban có đông nhân viên nhất
SELECT * FROM PHONGBAN
SELECT * FROM NHANVIEN
GO
--Table Checking--
/*CREATE OR ALTER VIEW v_TenPhongBan_PhongNVCaoNhat AS
SELECT
    PB.TENPHG AS TenPHG,
    (SELECT COUNT(*) FROM NHANVIEN WHERE PB.TENPHG = NV.PHG) AS PhongNVCaoNhat
FROM PHONGBAN PB
LEFT JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GO*/
CREATE OR ALTER VIEW v_TenPhongBan_PhongNVCaoNhat AS
SELECT 
    PB.TENPHG AS TenPhongBan,
    COUNT(NV.MANV) AS SoNhanVien
FROM PHONGBAN PB
LEFT JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG
HAVING COUNT(NV.MANV) = (
    SELECT MAX(SoLuong)
    FROM (
        SELECT COUNT(*) AS SoLuong
        FROM NHANVIEN
        GROUP BY PHG
    ) AS SubQuery
);
GO
--Tester--
SELECT * FROM v_TenPhongBan_PhongNVCaoNhat
GO
