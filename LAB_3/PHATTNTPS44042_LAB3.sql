USE QLDA;
------------------------------------------------------1.1
-- Dùng CAST
SELECT MA_NVIEN, MADA, STT, 
       CAST(THOIGIAN AS varchar(10)) AS ThoiGian_text
FROM PHANCONG;

-- Dùng CONVERT
SELECT MA_NVIEN, MADA, STT, 
       CONVERT(varchar(10), THOIGIAN) AS ThoiGian_text
FROM PHANCONG;
------------------------------------------------------1.2
-- Dùng CAST (decimal 10,2)
SELECT d.TENDEAN,
       CAST(SUM(p.THOIGIAN) AS decimal(10,2)) AS TongGio
FROM DEAN d
JOIN PHANCONG p ON d.MADA = p.MADA
GROUP BY d.TENDEAN;

-- Dùng CONVERT (decimal 10,2)
SELECT d.TENDEAN,
       CONVERT(decimal(10,2), SUM(p.THOIGIAN)) AS TongGio
FROM DEAN d
JOIN PHANCONG p ON d.MADA = p.MADA
GROUP BY d.TENDEAN;

-- Xuất dạng varchar
SELECT d.TENDEAN,
       CAST(CAST(SUM(p.THOIGIAN) AS decimal(10,2)) AS varchar(20)) AS TongGio_varchar
FROM DEAN d
JOIN PHANCONG p ON d.MADA = p.MADA
GROUP BY d.TENDEAN;
------------------------------------------------------1.3
-- decimal(10,2)
SELECT pb.TENPHG,
       CAST(AVG(nv.LUONG) AS decimal(10,2)) AS LuongTB
FROM PHONGBAN pb
JOIN NHANVIEN nv ON pb.MAPHG = nv.PHG
GROUP BY pb.TENPHG;

-- varchar có phân cách hàng nghìn
SELECT pb.TENPHG,
       FORMAT(AVG(nv.LUONG), 'N2', 'vi-VN') AS LuongTB_varchar
FROM PHONGBAN pb
JOIN NHANVIEN nv ON pb.MAPHG = nv.PHG
GROUP BY pb.TENPHG;
------------------------------------------------------2.1
SELECT d.TENDEAN,
       CEILING(SUM(p.THOIGIAN)) AS Gio_Ceiling,
       FLOOR(SUM(p.THOIGIAN))   AS Gio_Floor,
       ROUND(SUM(p.THOIGIAN),2) AS Gio_Rounded
FROM DEAN d
JOIN PHANCONG p ON d.MADA = p.MADA
GROUP BY d.TENDEAN;
------------------------------------------------------2.2
SELECT nv.HONV, nv.TENLOT, nv.TENNV, nv.LUONG
FROM NHANVIEN nv
JOIN PHONGBAN pb ON nv.PHG = pb.MAPHG
WHERE nv.LUONG > (
    SELECT ROUND(AVG(LUONG),2)
    FROM NHANVIEN nv2
    JOIN PHONGBAN pb2 ON nv2.PHG = pb2.MAPHG
    WHERE pb2.TENPHG = N'Nghiên Cứu'
);
------------------------------------------------------3.1
SELECT 
  UPPER(nv.HONV) AS HoNV,
  LOWER(nv.TENLOT) AS TenLot,
  CASE
    WHEN LEN(nv.TENNV) >= 2
    THEN LOWER(LEFT(nv.TENNV,1)) 
         + UPPER(SUBSTRING(nv.TENNV,2,1)) 
         + LOWER(SUBSTRING(nv.TENNV,3,100))
    ELSE UPPER(nv.TENNV)
  END AS TenNV_custom,
  -- Lấy phần tên đường trong địa chỉ (sau số nhà, trước dấu ',')
  LTRIM(RTRIM(
     SUBSTRING(nv.DCHI, CHARINDEX(' ', nv.DCHI)+1, 
       CHARINDEX(',', nv.DCHI+',')-CHARINDEX(' ', nv.DCHI))
  )) AS TenDuong
FROM NHANVIEN nv
WHERE nv.MANV IN (
  SELECT MA_NVIEN 
  FROM THANNHAN 
  GROUP BY MA_NVIEN
  HAVING COUNT(*) > 2
);
------------------------------------------------------3.2
WITH CountNV AS (
    SELECT PHG, COUNT(*) AS SoNV
    FROM NHANVIEN
    GROUP BY PHG
),
MaxPhong AS (
    SELECT TOP 1 PHG FROM CountNV ORDER BY SoNV DESC
)
SELECT pb.TENPHG,
       ISNULL(nv.HONV + ' ' + nv.TENLOT + ' ' + nv.TENNV, '(Chưa có)') AS TruongPhong,
       'Fpoly' AS TruongPhong_Fpoly
FROM PHONGBAN pb
JOIN MaxPhong mp ON pb.MAPHG = mp.PHG
LEFT JOIN NHANVIEN nv ON pb.TRPHG = nv.MANV;

------------------------------------------------------4.1
SELECT HONV, TENLOT, TENNV, NGSINH
FROM NHANVIEN
WHERE YEAR(NGSINH) BETWEEN 1960 AND 1965;
------------------------------------------------------4.2
SELECT HONV, TENLOT, TENNV, NGSINH,
       DATEDIFF(year, NGSINH, GETDATE())
         - CASE WHEN DATEADD(year, DATEDIFF(year, NGSINH, GETDATE()), NGSINH) > GETDATE() 
                THEN 1 ELSE 0 END AS Tuoi
FROM NHANVIEN;
------------------------------------------------------4.3
SELECT HONV, TENLOT, TENNV, NGSINH,
       FORMAT(NGSINH, 'dddd', 'vi-VN') AS ThuSinh
FROM NHANVIEN;

------------------------------------------------------4.4
SELECT pb.TENPHG,
       COUNT(nv.MANV) AS SoNhanVien,
       ISNULL(tp.HONV + ' ' + tp.TENLOT + ' ' + tp.TENNV, '(Chưa có)') AS TruongPhong,
       CONVERT(varchar(8), pb.NG_NHANCHUC, 5) AS NgayNhanChuc_ddmmyy
FROM PHONGBAN pb
LEFT JOIN NHANVIEN nv ON pb.MAPHG = nv.PHG
LEFT JOIN NHANVIEN tp ON pb.TRPHG = tp.MANV
GROUP BY pb.TENPHG, pb.NG_NHANCHUC, tp.HONV, tp.TENLOT, tp.TENNV;
