-- Create database if not exists
IF DB_ID('DuAnMau') IS NULL
    CREATE DATABASE DuAnMau;
GO
USE DuAnMau
GO
--=========================================================--
-- Drop tables in reverse dependency order (child → parent)
IF OBJECT_ID('LOAINHA', 'U') IS NOT NULL DROP TABLE LOAINHA;
IF OBJECT_ID('NGUOIDUNG', 'U') IS NOT NULL DROP TABLE NGUOIDUNG;
IF OBJECT_ID('NHATRO', 'U') IS NOT NULL DROP TABLE NHATRO;
IF OBJECT_ID('DANHGIA', 'U') IS NOT NULL DROP TABLE DANHGIA;
GO
--=========================================================--
-- Tạo bảng LOAINHA
CREATE TABLE LOAINHA (
    MaLoai INT IDENTITY(1,1) PRIMARY KEY,
    TenLoai NVARCHAR(100) NOT NULL
);
GO

-- Tạo bảng NGUOIDUNG
CREATE TABLE NGUOIDUNG (
    MaND INT IDENTITY(1,1) PRIMARY KEY,
    TenND NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nữ', N'Khác')),
    DienThoai VARCHAR(20) NOT NULL,
    Diachi NVARCHAR(100),
    Quan NVARCHAR(100),
    Email VARCHAR(100) NOT NULL UNIQUE
);
GO

-- Tạo bảng NHATRO
CREATE TABLE NHATRO (
    MaTro INT IDENTITY(1,1) PRIMARY KEY,
    MaLoai INT NOT NULL,
    DienTich FLOAT CHECK (DienTich > 0),
    GiaPhong DECIMAL(18,2) CHECK (GiaPhong > 0),
    Diachi NVARCHAR(100),
    Quan NVARCHAR(100),
    MoTa NVARCHAR(MAX),
    NgayDang DATE DEFAULT GETDATE(),
    MaNguoiLienHe INT NOT NULL,
    FOREIGN KEY (MaLoai) REFERENCES LOAINHA(MaLoai),
    FOREIGN KEY (MaNguoiLienHe) REFERENCES NGUOIDUNG(MaND)
);
GO

-- Tạo bảng DANHGIA
CREATE TABLE DANHGIA (
    MaDG INT IDENTITY(1,1) PRIMARY KEY,
    MaNgDG INT NOT NULL,       -- Người đánh giá
    MaTro INT NOT NULL,        -- Nhà trọ được đánh giá
    LikeDislike BIT NOT NULL,  -- 1 = Like, 0 = Dislike
    NoiDung NVARCHAR(MAX),
    NgayDG DATE DEFAULT GETDATE(),
    FOREIGN KEY (MaNgDG) REFERENCES NGUOIDUNG(MaND),
    FOREIGN KEY (MaTro) REFERENCES NHATRO(MaTro)
);
GO
--=========================================================--
-- Nhập dữ liệu cho LOAINHA (tối thiểu 3)
INSERT INTO LOAINHA (TenLoai)
VALUES (N'Nhà nguyên căn'),
       (N'Phòng trọ'),
       (N'Chung cư mini'),
       (N'Ký túc xá');

-- Nhập dữ liệu cho NGUOIDUNG (10 bản ghi)
INSERT INTO NGUOIDUNG (TenND, GioiTinh, DienThoai, Diachi, Quan, Email)
VALUES 
(N'Nguyễn Văn A', N'Nam', '0905123456', N'12 Lý Thường Kiệt', N'Tân Bình', 'vana@gmail.com'),
(N'Trần Thị B', N'Nữ', '0905123457', N'34 Cách Mạng Tháng 8', N'Quận 3', 'thib@gmail.com'),
(N'Lê Văn C', N'Nam', '0905123458', N'56 Nguyễn Trãi', N'Quận 5', 'vanc@gmail.com'),
(N'Phạm Thị D', N'Nữ', '0905123459', N'78 Lê Lợi', N'Quận 1', 'thid@gmail.com'),
(N'Hoàng Văn E', N'Nam', '0905123460', N'90 Hai Bà Trưng', N'Quận 3', 'vane@gmail.com'),
(N'Võ Thị F', N'Nữ', '0905123461', N'11 Nguyễn Đình Chiểu', N'Quận 1', 'thif@gmail.com'),
(N'Đỗ Văn G', N'Nam', '0905123462', N'22 Trần Hưng Đạo', N'Quận 5', 'vang@gmail.com'),
(N'Nguyễn Thị H', N'Nữ', '0905123463', N'33 Điện Biên Phủ', N'Bình Thạnh', 'thih@gmail.com'),
(N'Phan Văn I', N'Nam', '0905123464', N'44 Nguyễn Văn Cừ', N'Quận 10', 'vani@gmail.com'),
(N'Bùi Thị K', N'Nữ', '0905123465', N'55 Võ Văn Tần', N'Quận 3', 'thik@gmail.com');

-- Nhập dữ liệu cho NHATRO (10 bản ghi)
INSERT INTO NHATRO (MaLoai, DienTich, GiaPhong, Diachi, Quan, MoTa, MaNguoiLienHe)
VALUES
(1, 60, 6000000, N'101 Lê Hồng Phong', N'Quận 10', N'Nhà nguyên căn rộng rãi, gần chợ', 1),
(2, 20, 2500000, N'202 CMT8', N'Quận 3', N'Phòng trọ sạch sẽ, có gác lửng', 2),
(3, 35, 3500000, N'303 Nguyễn Đình Chiểu', N'Quận 3', N'Chung cư mini tiện nghi', 3),
(2, 18, 2200000, N'404 Trần Hưng Đạo', N'Quận 5', N'Phòng giá rẻ, gần trường học', 4),
(1, 70, 7000000, N'505 Lý Thái Tổ', N'Quận 10', N'Nhà nguyên căn 2 tầng', 5),
(3, 40, 4000000, N'606 Điện Biên Phủ', N'Bình Thạnh', N'Chung cư mini có thang máy', 6),
(2, 22, 2700000, N'707 Võ Văn Tần', N'Quận 3', N'Phòng thoáng mát, có ban công', 7),
(1, 80, 8000000, N'808 Nguyễn Văn Cừ', N'Quận 5', N'Nhà nguyên căn 3 tầng', 8),
(2, 25, 3000000, N'909 Hai Bà Trưng', N'Quận 1', N'Phòng trọ mới xây, có wifi', 9),
(3, 38, 3800000, N'1001 Nguyễn Trãi', N'Quận 5', N'Chung cư mini đầy đủ nội thất', 10);

-- Nhập dữ liệu cho DANHGIA (10 bản ghi)
INSERT INTO DANHGIA (MaNgDG, MaTro, LikeDislike, NoiDung)
VALUES
(1, 1, 1, N'Nhà đẹp, rộng rãi, chủ thân thiện'),
(2, 2, 1, N'Phòng sạch sẽ, giá hợp lý'),
(3, 3, 0, N'Chung cư hơi ồn, nhưng tiện nghi'),
(4, 4, 1, N'Phòng giá rẻ, phù hợp sinh viên'),
(5, 5, 1, N'Nhà rộng, thoáng mát, rất ưng ý'),
(6, 6, 0, N'Chung cư mini nhỏ, hơi chật'),
(7, 7, 1, N'Phòng đẹp, ban công thoáng'),
(8, 8, 0, N'Nhà nguyên căn nhưng hơi cũ'),
(9, 9, 1, N'Phòng mới xây, có wifi mạnh'),
(10, 10, 1, N'Chung cư nội thất đầy đủ, an ninh tốt');

select * from LOAINHA
go
--=========================================================--
-------------------------------------------------------------
--*************************************************************
-------------------------------------------------------------
--YÊU CẦU 3:

-- SP: Thêm người dùng mới
CREATE OR ALTER PROC SP_ThemNguoiDung
    @TenND NVARCHAR(100),
    @GioiTinh NVARCHAR(10),
    @DienThoai VARCHAR(15),
    @DiaChi NVARCHAR(100),
    @Quan NVARCHAR(100),
    @Email VARCHAR(100)
AS
BEGIN
    -- Kiểm tra dữ liệu bắt buộc
    IF (@TenND IS NULL OR @GioiTinh IS NULL OR @DienThoai IS NULL OR @Email IS NULL)
    BEGIN
        PRINT N'❌ Vui lòng nhập đầy đủ: Tên, Giới tính, Điện thoại, Email!';
        RETURN;
    END

    -- Chèn dữ liệu
    INSERT INTO NGUOIDUNG (TenND, GioiTinh, DienThoai, DiaChi, Quan, Email)
    VALUES (@TenND, @GioiTinh, @DienThoai, @DiaChi, @Quan, @Email);

    PRINT N'✅ Thêm người dùng thành công!';
END
GO

-- ✅ Thành công
EXEC SP_ThemNguoiDung 
    @TenND = N'Nguyễn Văn M', 
    @GioiTinh = N'Nam',
    @DienThoai = '0905123477',
    @DiaChi = N'12 Hoàng Sa',
    @Quan = N'Phú Nhuận',
    @Email = 'vanm@gmail.com';
    go

-- ❌ Lỗi (thiếu Email)
EXEC SP_ThemNguoiDung 
    @TenND = N'Lê Thị N', 
    @GioiTinh = N'Nữ',
    @DienThoai = '0905123478',
    @DiaChi = N'45 Trường Sa',
    @Quan = N'Bình Thạnh',
    @Email = NULL;
    go

    --------------------------------------
    -- SP: Thêm nhà trọ mới
CREATE OR ALTER PROC SP_ThemNhaTro
    @MaLoai INT,
    @DienTich FLOAT,
    @GiaPhong DECIMAL(18,2),
    @DiaChi NVARCHAR(100),
    @Quan NVARCHAR(100),
    @MoTa NVARCHAR(MAX),
    @MaNguoiLienHe INT
AS
BEGIN
    -- Kiểm tra dữ liệu bắt buộc
    IF (@MaLoai IS NULL OR @DienTich IS NULL OR @GiaPhong IS NULL OR @MaNguoiLienHe IS NULL)
    BEGIN
        PRINT N'❌ Thiếu thông tin bắt buộc: Mã loại, Diện tích, Giá phòng, Người liên hệ!';
        RETURN;
    END

    IF (@DienTich <= 0 OR @GiaPhong <= 0)
    BEGIN
        PRINT N'❌ Diện tích và giá phòng phải lớn hơn 0!';
        RETURN;
    END

    INSERT INTO NHATRO (MaLoai, DienTich, GiaPhong, DiaChi, Quan, MoTa, MaNguoiLienHe)
    VALUES (@MaLoai, @DienTich, @GiaPhong, @DiaChi, @Quan, @MoTa, @MaNguoiLienHe);

    PRINT N'✅ Thêm nhà trọ thành công!';
END
GO


-- ✅ Thành công
EXEC SP_ThemNhaTro 
    @MaLoai = 2,
    @DienTich = 24,
    @GiaPhong = 2800000,
    @DiaChi = N'99 Phan Xích Long',
    @Quan = N'Phú Nhuận',
    @MoTa = N'Phòng trọ thoáng, có máy lạnh',
    @MaNguoiLienHe = 3;

-- ❌ Lỗi (thiếu Giá phòng)
EXEC SP_ThemNhaTro 
    @MaLoai = 1,
    @DienTich = 50,
    @GiaPhong = NULL,
    @DiaChi = N'11 Nguyễn Thị Minh Khai',
    @Quan = N'Quận 1',
    @MoTa = N'Nhà nguyên căn mới xây',
    @MaNguoiLienHe = 2;
    GO


    -----------------------------------------------------
    -- SP: Thêm đánh giá mới
CREATE OR ALTER PROC SP_ThemDanhGia
    @MaNgDG INT,
    @MaTro INT,
    @LikeDislike BIT,
    @NoiDung NVARCHAR(MAX)
AS
BEGIN
    -- Kiểm tra dữ liệu bắt buộc
    IF (@MaNgDG IS NULL OR @MaTro IS NULL OR @LikeDislike IS NULL)
    BEGIN
        PRINT N'❌ Thiếu thông tin bắt buộc: Người đánh giá, Mã trọ, Like/Dislike!';
        RETURN;
    END

    INSERT INTO DANHGIA (MaNgDG, MaTro, LikeDislike, NoiDung)
    VALUES (@MaNgDG, @MaTro, @LikeDislike, @NoiDung);

    PRINT N'✅ Thêm đánh giá thành công!';
END
GO


-- ✅ Thành công
EXEC SP_ThemDanhGia 
    @MaNgDG = 5,
    @MaTro = 3,
    @LikeDislike = 1,
    @NoiDung = N'Phòng sạch, chủ vui vẻ';

-- ❌ Lỗi (thiếu LikeDislike)
EXEC SP_ThemDanhGia 
    @MaNgDG = 6,
    @MaTro = 2,
    @LikeDislike = NULL,
    @NoiDung = N'Không có chỗ gửi xe';
    GO


    ------------------------------------------------------------
  -- 3.2  Truy vấn thông tin 
--a. Viết một SP với các tham số đầu vào phù hợp.
--SP thực hiện tìm kiếm thông tin các phòng trọ thỏa mãn điều kiện tìm kiếm theo: 
--Quận, phạm vi diện tích, phạm vi ngày đăng tin, khoảng giá tiền, loại hình nhà trọ. 
--SP này trả về thông tin các phòng trọ, gồm các cột có định dạng sau: 
--o Cột thứ nhất: có định dạng ‘Cho thuê phòng  trọ tại’
--+ <Địa chỉ phòng trọ> + <Tên quận/Huyện> 
--o Cột thứ hai: Hiển thị diện tích phòng trọ
--dưới định dạng số theo chuẩn Việt Nam + m2. Ví dụ 30,5 m2 
--o Cột thứ ba: Hiển thị thông tin giá phòng dưới định dạng số theo định dạng chuẩn 
--Việt Nam. Ví dụ 1.700.000 
--o Cột thứ tư: Hiển thị thông tin mô tả của phòng trọ 
--o Cột thứ năm: Hiển thị ngày đăng tin dưới định dạng chuẩn Việt Nam. 
--Ví dụ: 27-02-2012 
--o Cột thứ sáu: Hiển thị thông tin người liên hệ dưới định dạng sau: 
--▪ Nếu giới tính là Nam. Hiển thị: A. + tên người liên hệ. Ví dụ A. Thắng 
--▪ Nếu giới tính là Nữ. Hiển thị: C. + tên người liên hệ. Ví dụ C. Lan 
--o Cột thứ bảy: Số điện thoại liên hệ 
--o Cột thứ tám:  Địa chỉ người liên hệ - 
--Viết hai lời gọi cho SP này 



CREATE OR ALTER PROC SP_TimKiemNhaTro
    @Quan NVARCHAR(100) = NULL,
    @DienTichMin FLOAT = NULL,
    @DienTichMax FLOAT = NULL,
    @NgayDangTu DATE = NULL,
    @NgayDangDen DATE = NULL,
    @GiaMin DECIMAL(18,2) = NULL,
    @GiaMax DECIMAL(18,2) = NULL,
    @MaLoai INT = NULL
AS
BEGIN
    SET DATEFORMAT DMY;

    SELECT
        N'Cho thuê phòng trọ tại ' + NT.DiaChi + N', ' + NT.Quan AS [Thông tin phòng trọ],
        FORMAT(NT.DienTich, 'N1', 'vi-VN') + N' m²' AS [Diện tích],
        FORMAT(NT.GiaPhong, 'N0', 'vi-VN') AS [Giá phòng],
        NT.MoTa AS [Mô tả],
        FORMAT(NT.NgayDang, 'dd-MM-yyyy') AS [Ngày đăng],
        CASE ND.GioiTinh
            WHEN N'Nam' THEN N'A. ' + ND.TenND
            WHEN N'Nữ' THEN N'C. ' + ND.TenND
            ELSE N'Ng. ' + ND.TenND
        END AS [Người liên hệ],
        ND.DienThoai AS [SĐT liên hệ],
        ND.DiaChi AS [Địa chỉ người liên hệ]
    FROM NHATRO NT
    JOIN NGUOIDUNG ND ON NT.MaNguoiLienHe = ND.MaND
    JOIN LOAINHA LN ON NT.MaLoai = LN.MaLoai
    WHERE 
        (@Quan IS NULL OR NT.Quan LIKE N'%' + @Quan + N'%')
        AND (@DienTichMin IS NULL OR NT.DienTich >= @DienTichMin)
        AND (@DienTichMax IS NULL OR NT.DienTich <= @DienTichMax)
        AND (@NgayDangTu IS NULL OR NT.NgayDang >= @NgayDangTu)
        AND (@NgayDangDen IS NULL OR NT.NgayDang <= @NgayDangDen)
        AND (@GiaMin IS NULL OR NT.GiaPhong >= @GiaMin)
        AND (@GiaMax IS NULL OR NT.GiaPhong <= @GiaMax)
        AND (@MaLoai IS NULL OR NT.MaLoai = @MaLoai);
END
GO   -- 🔥 Phải có dòng này để kết thúc định nghĩa SP

-- ✅ Gọi thực thi thủ tục
EXEC SP_TimKiemNhaTro
    @Quan = N'Quận 3',
    @DienTichMin = 15,
    @DienTichMax = 40,
    @NgayDangTu = '2024-01-01',
    @NgayDangDen = GETDATE(),
    @GiaMin = 2000000,
    @GiaMax = 4000000,
    @MaLoai = 2;
GO

--?????????????????????????????????????????????????????????//
    ----------------------------------------------------------------------
   -- b. Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng 
--NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng 
--NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số. 

CREATE OR ALTER FUNCTION FN_TimMaNguoiDung
(
    @TenND NVARCHAR(100),
    @GioiTinh NVARCHAR(10),
    @DienThoai VARCHAR(15),
    @DiaChi NVARCHAR(100),
    @Quan NVARCHAR(100),
    @Email VARCHAR(100)
)
RETURNS INT
AS
BEGIN
    DECLARE @MaND INT;

    SELECT @MaND = MaND
    FROM NGUOIDUNG
    WHERE 
        TenND = @TenND
        AND GioiTinh = @GioiTinh
        AND DienThoai = @DienThoai
        AND ISNULL(DiaChi, '') = ISNULL(@DiaChi, '')
        AND ISNULL(Quan, '') = ISNULL(@Quan, '')
        AND Email = @Email;

    RETURN @MaND;
END
GO


--vd Tìm người dùng có tồn tại
SELECT dbo.FN_TimMaNguoiDung
(
    N'Nguyễn Văn A',
    N'Nam',
    '0905123456',
    N'12 Lý Thường Kiệt',
    N'Tân Bình',
    'vana@gmail.com'
) AS MaNguoiDung;

--Ví dụ 2: Không tìm thấy (email sai)
SELECT dbo.FN_TimMaNguoiDung
(
    N'Nguyễn Văn A',
    N'Nam',
    '0905123456',
    N'12 Lý Thường Kiệt',
    N'Tân Bình',
    'saiemail@gmail.com'
) AS MaNguoiDung;
GO

-----------------------------------
--c. Viết một hàm có tham số đầu vào là mã nhà trọ (cột khóa chính của bảng 
--NHATRO). Hàm này trả về tổng số LIKE và DISLIKE của nhà trọ này. 
CREATE OR ALTER FUNCTION FN_ThongKeLikeDislike(@MaTro INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        SUM(CASE WHEN LikeDislike = 1 THEN 1 ELSE 0 END) AS TongLike,
        SUM(CASE WHEN LikeDislike = 0 THEN 1 ELSE 0 END) AS TongDislike
    FROM DANHGIA
    WHERE MaTro = @MaTro
);
GO




SELECT * FROM dbo.FN_ThongKeLikeDislike(1);


SELECT * FROM dbo.FN_ThongKeLikeDislike(999);
GO


-------------------------------------------------------------------
--d. Tạo một View lưu thông tin của TOP 10 nhà trọ có số người dùng LIKE nhiều nhất gồm 
--các thông tin sau: - Diện tích - Giá - Mô tả - Ngày đăng tin
-- - Tên người liên hệ - Địa chỉ - Điện thoại - Email 

CREATE OR ALTER VIEW V_Top10NhaTroLikeNhieuNhat
AS
SELECT TOP 10 
    NT.MaTro,
    NT.DienTich,
    NT.GiaPhong,
    NT.MoTa,
    NT.NgayDang,
    ND.TenND AS TenNguoiLienHe,
    ND.DiaChi,
    ND.DienThoai,
    ND.Email,
    LN.TenLoai,
    COUNT(DG.MaNgDG) AS SoLuongLike
FROM NHATRO NT
JOIN NGUOIDUNG ND ON NT.MaNguoiLienHe = ND.MaND
JOIN LOAINHA LN ON NT.MaLoai = LN.MaLoai
LEFT JOIN DANHGIA DG ON NT.MaTro = DG.MaTro AND DG.LikeDislike = 1
GROUP BY 
    NT.MaTro, NT.DienTich, NT.GiaPhong, NT.MoTa, NT.NgayDang,
    ND.TenND, ND.DiaChi, ND.DienThoai, ND.Email, LN.TenLoai
ORDER BY COUNT(DG.MaNgDG) DESC;
GO


SELECT * FROM V_Top10NhaTroLikeNhieuNhat;
GO

---------------------------------------------------------------
--e. Viết một Stored Procedure nhận tham số đầu vào là mã nhà trọ (cột khóa chính của 
--bảng NHATRO). SP này trả về tập kết quả gồm các thông tin sau: - Mã nhà trọ - Tên người đánh giá - Trạng thái LIKE hay DISLIKE - Nội dung đánh g

CREATE OR ALTER PROCEDURE SP_ThongTinDanhGiaTheoNhaTro
    @MaTro INT
AS
BEGIN
    -- Kiểm tra mã nhà trọ có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM NHATRO WHERE MaTro = @MaTro)
    BEGIN
        PRINT N'Mã nhà trọ không tồn tại. Vui lòng nhập lại.';
        RETURN;
    END;

    -- Trả về thông tin đánh giá
    SELECT 
        NT.MaTro,
        ND.TenND AS [Tên người đánh giá],
        CASE 
            WHEN DG.LikeDislike = 1 THEN N'LIKE'
            WHEN DG.LikeDislike = 0 THEN N'DISLIKE'
            ELSE N'Không xác định'
        END AS [Trạng thái],
        DG.NoiDung AS [Nội dung đánh giá]
    FROM DANHGIA DG
    JOIN NGUOIDUNG ND ON DG.MaNgDG = ND.MaND
    JOIN NHATRO NT ON DG.MaTro = NT.MaTro
    WHERE NT.MaTro = @MaTro;
END;
GO



EXEC SP_ThongTinDanhGiaTheoNhaTro @MaTro = 3;
GO
----------------------------------------------------------------------------
--3. Xóa thông tin 
--1. Viết một SP nhận một tham số đầu vào kiểu int là số lượng DISLIKE. SP này thực hiện 
--thao tác xóa thông tin của các nhà trọ và thông tin đánh giá của chúng, nếu tổng số lượng 
--DISLIKE tương ứng với nhà trọ này lớn hơn giá trị tham số được truyền vào. 
--Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác 
--xóa thực hiện không thành công. 
CREATE OR ALTER PROCEDURE SP_XoaNhaTro_DislikeQuaNhieu
    @SoLuongDislike INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Bước 1: Lấy danh sách các nhà trọ có số DISLIKE > @SoLuongDislike
        DECLARE @TableNhaTro TABLE (MaTro INT);

        INSERT INTO @TableNhaTro(MaTro)
        SELECT MaTro
        FROM DANHGIA
        WHERE LikeDislike = 0
        GROUP BY MaTro
        HAVING COUNT(*) > @SoLuongDislike;

        -- Bước 2: Xóa thông tin trong bảng DANHGIA trước (do có khóa ngoại)
        DELETE FROM DANHGIA
        WHERE MaTro IN (SELECT MaTro FROM @TableNhaTro);

        -- Bước 3: Xóa thông tin trong bảng NHATRO
        DELETE FROM NHATRO
        WHERE MaTro IN (SELECT MaTro FROM @TableNhaTro);

        -- Nếu mọi thứ thành công
        COMMIT TRANSACTION;
        PRINT N'Đã xóa thành công các nhà trọ có số lượng DISLIKE vượt quá ' 
              + CAST(@SoLuongDislike AS NVARCHAR(10));
    END TRY

    BEGIN CATCH
        -- Nếu lỗi, quay lui toàn bộ thao tác
        ROLLBACK TRANSACTION;
        PRINT N'Lỗi khi xóa dữ liệu: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


EXEC SP_XoaNhaTro_DislikeQuaNhieu @SoLuongDislike = 5;
GO

-----------------------------------------------------------------
--2. Viết một SP nhận hai tham số đầu vào là khoảng thời gian đăng tin. SP này thực hiện 
--thao tác xóa thông tin những nhà trọ được đăng trong khoảng thời gian được truyền vào 
--qua các tham số. 
--Lưu ý: SP cũng phải thực hiện xóa thông tin đánh giá của các nhà trọ này. 
--Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác 
--xóa thực hiện không thành công. 
CREATE OR ALTER PROCEDURE SP_XoaNhaTro_TheoKhoangThoiGian
    @NgayBatDau DATE,
    @NgayKetThuc DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @NgayBatDau IS NULL OR @NgayKetThuc IS NULL
        BEGIN
            PRINT N'Vui lòng nhập đầy đủ ngày bắt đầu và ngày kết thúc.';
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        IF @NgayBatDau > @NgayKetThuc
        BEGIN
            PRINT N'Ngày bắt đầu không được lớn hơn ngày kết thúc.';
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        DECLARE @TableNhaTro TABLE (MaTro INT);

        INSERT INTO @TableNhaTro(MaTro)
        SELECT MaTro
        FROM NHATRO
        WHERE NgayDang BETWEEN @NgayBatDau AND @NgayKetThuc;

        IF NOT EXISTS (SELECT 1 FROM @TableNhaTro)
        BEGIN
            PRINT N'Không có nhà trọ nào được đăng trong khoảng thời gian này.';
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        DELETE FROM DANHGIA
        WHERE MaTro IN (SELECT MaTro FROM @TableNhaTro);

        DELETE FROM NHATRO
        WHERE MaTro IN (SELECT MaTro FROM @TableNhaTro);

        COMMIT TRANSACTION;

        PRINT N'Đã xóa thành công các nhà trọ được đăng từ ' 
              + CONVERT(NVARCHAR(10), @NgayBatDau, 105)
              + N' đến ' 
              + CONVERT(NVARCHAR(10), @NgayKetThuc, 105);
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT N'Lỗi khi xóa dữ liệu: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO



----------------------------------------
--****************************************
----------------------------------------
--Y4. Yêu cầu quản trị CSDL - 
--Tạo hai người dùng CSDL. 

 --Một người dùng với vai trò nhà quản trị CSDL. Phân quyền cho người dùng 
--này chỉ được phép thao tác trên CSDL quản lý nhà trọ cho thuê và có toàn 
--quyền thao tác trên CSDL đó 
--o Một người dùng thông thường. Phân cho người dùng này toàn bộ quyền thao 
--tác trên các bảng của CSDL và quyền thực thi các SP và các hàm được tạo ra từ 
--các yêu cầu trên - 
--Kết nối tới Server bằng tài khoản của người dùng thứ nhất. Thực hiện tạo một bản sao 
--CSDL. 

CREATE LOGIN QLNhaTro_Admin
WITH PASSWORD = 'Admin@123';
GO

USE QLNhaTroThinhNg;
GO

CREATE USER QLNhaTro_Admin FOR LOGIN QLNhaTro_Admin;
GO

ALTER ROLE db_owner ADD MEMBER QLNhaTro_Admin;
GO


CREATE LOGIN QLNhaTro_User
WITH PASSWORD = 'User@123';
GO

USE QLNhaTroThinhNg;
GO

CREATE USER QLNhaTro_User FOR LOGIN QLNhaTro_User;
GO

-- Cho phép SELECT, INSERT, UPDATE, DELETE trên toàn bộ bảng
GRANT SELECT, INSERT, UPDATE, DELETE ON DATABASE::QLNhaTroThinhNg TO QLNhaTro_User;
GO

-- Cho phép thực thi tất cả Stored Procedure và Function
GRANT EXECUTE TO QLNhaTro_User;
GO

BACKUP DATABASE QLNhaTroThinhNg
TO DISK = 'C:\Backup\QLNhaTroThinhNg_Full.bak'
WITH FORMAT,
     INIT,
     NAME = 'Backup Full QLNhaTroThinhNg',
     STATS = 10;
GO

USE master;
GO

RESTORE DATABASE QLNhaTroThinhNg_Copy
FROM DISK = 'C:\Backup\QLNhaTroThinhNg_Full.bak'
WITH MOVE 'QLNhaTroThinhNg' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\QLNhaTroThinhNg_Copy.mdf',
     MOVE 'QLNhaTroThinhNg_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\QLNhaTroThinhNg_Copy.ldf',
     REPLACE;
GO


