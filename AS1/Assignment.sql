-- 1️⃣ Create the database
CREATE DATABASE NhaTroDB;
GO

USE NhaTroDB;
GO

-- 2️⃣ Table: LOAINHA (Type of house/room)
CREATE TABLE LOAINHA (
    MaLoaiNha INT IDENTITY(1,1) PRIMARY KEY,
    TenLoaiNha NVARCHAR(100) NOT NULL,  -- e.g., "Phòng trọ khép kín", "Nhà riêng", etc.
    MoTa NVARCHAR(255)
);
GO

-- 3️⃣ Table: NGUOIDUNG (Users / Members)
CREATE TABLE NGUOIDUNG (
    MaNguoiDung INT IDENTITY(1,1) PRIMARY KEY,
    TenNguoiDung NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nữ', N'Khác')),
    DienThoai VARCHAR(15),
    SoNha NVARCHAR(50),
    TenDuong NVARCHAR(100),
    TenPhuong NVARCHAR(100),
    Quan NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE
);
GO

-- 4️⃣ Table: NHATRO (Rental listings)
CREATE TABLE NHATRO (
    MaNhaTro INT IDENTITY(1,1) PRIMARY KEY,
    MaLoaiNha INT NOT NULL,
    DienTich DECIMAL(6,2) CHECK (DienTich > 0),
    GiaPhong DECIMAL(12,2) CHECK (GiaPhong >= 0),
    SoNha NVARCHAR(50),
    TenDuong NVARCHAR(100),
    TenPhuong NVARCHAR(100),
    Quan NVARCHAR(100),
    MoTa NVARCHAR(MAX),
    NgayDang DATE DEFAULT GETDATE(),
    MaNguoiLienHe INT NOT NULL,

    CONSTRAINT FK_NhaTro_LoaiNha FOREIGN KEY (MaLoaiNha) REFERENCES LOAINHA(MaLoaiNha),
    CONSTRAINT FK_NhaTro_NguoiDung FOREIGN KEY (MaNguoiLienHe) REFERENCES NGUOIDUNG(MaNguoiDung)
);
GO

-- 5️⃣ Table: DANHGIA (Reviews)
CREATE TABLE DANHGIA (
    MaDanhGia INT IDENTITY(1,1) PRIMARY KEY,
    MaNguoiDung INT NOT NULL,
    MaNhaTro INT NOT NULL,
    Thich BIT NOT NULL,  -- 1 = LIKE, 0 = DISLIKE
    NoiDung NVARCHAR(500),

    CONSTRAINT FK_DanhGia_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NGUOIDUNG(MaNguoiDung),
    CONSTRAINT FK_DanhGia_NhaTro FOREIGN KEY (MaNhaTro) REFERENCES NHATRO(MaNhaTro)
);
GO
////////////////////////////////////////////////////////////////////////////////////////
INSERT INTO LOAINHA (TenLoaiNha, MoTa)
VALUES
(N'Phòng trọ khép kín', N'Phòng riêng có nhà vệ sinh, khu vực nấu ăn.'),
(N'Căn hộ chung cư', N'Phòng hiện đại, có ban công và thang máy.'),
(N'Nhà nguyên căn', N'Cho thuê toàn bộ nhà riêng, phù hợp gia đình.'),
(N'Phòng trọ mini', N'Phòng nhỏ gọn, giá rẻ, phù hợp sinh viên.'),
(N'Chung cư mini', N'Căn hộ nhỏ có sẵn nội thất cơ bản.');
/////////////////////////////////////////////
INSERT INTO NGUOIDUNG (TenNguoiDung, GioiTinh, DienThoai, SoNha, TenDuong, TenPhuong, Quan, Email)
VALUES
(N'Nguyễn Minh Tâm', N'Nam', '0905123456', N'12', N'Trần Phú', N'Phường 3', N'Hà Đông', 'tam.nguyen@example.com'),
(N'Lê Thảo Nhi', N'Nữ', '0987654321', N'45', N'Láng Hạ', N'Phường Thành Công', N'Đống Đa', 'nhi.le@example.com'),
(N'Phạm Anh Quân', N'Nam', '0912345678', N'22', N'Nguyễn Trãi', N'Thượng Đình', N'Thanh Xuân', 'quan.pham@example.com'),
(N'Trần Diệu Linh', N'Nữ', '0978123456', N'68', N'Giải Phóng', N'Phương Liệt', N'Hai Bà Trưng', 'linh.tran@example.com'),
(N'Hoàng Quốc Bảo', N'Nam', '0907896543', N'19', N'Xuân Thủy', N'Dịch Vọng Hậu', N'Cầu Giấy', 'bao.hoang@example.com');
/////////////////////////////////////////////
INSERT INTO NHATRO (MaLoaiNha, DienTich, GiaPhong, SoNha, TenDuong, TenPhuong, Quan, MoTa, MaNguoiLienHe)
VALUES
(1, 25.0, 2500000, N'12', N'Trần Phú', N'Phường 3', N'Hà Đông', N'Phòng sạch sẽ, có gác xép, gần bến xe bus.', 1),
(2, 45.5, 5500000, N'45', N'Láng Hạ', N'Thành Công', N'Đống Đa', N'Căn hộ đầy đủ nội thất, có điều hòa và máy giặt.', 2),
(3, 90.0, 9000000, N'22', N'Nguyễn Trãi', N'Thượng Đình', N'Thanh Xuân', N'Nhà riêng 3 tầng, sân để xe, bếp riêng.', 3),
(4, 18.5, 1800000, N'68', N'Giải Phóng', N'Phương Liệt', N'Hai Bà Trưng', N'Phòng nhỏ, thoáng mát, có chỗ phơi đồ.', 4),
(5, 35.0, 3700000, N'19', N'Xuân Thủy', N'Dịch Vọng Hậu', N'Cầu Giấy', N'Chung cư mini tiện nghi, gần Đại học Quốc Gia.', 5);
/////////////////////////////////////////////
INSERT INTO DANHGIA (MaNguoiDung, MaNhaTro, Thich, NoiDung)
VALUES
(2, 1, 1, N'Phòng đẹp, chủ nhà thân thiện, gần trường học.'),
(1, 2, 1, N'Căn hộ sạch sẽ, nội thất như hình, đáng tiền.'),
(3, 3, 0, N'Nhà hơi xa trung tâm nhưng rộng rãi.'),
(4, 4, 1, N'Phòng nhỏ nhưng yên tĩnh, phù hợp sinh viên.'),
(5, 5, 0, N'Giá hơi cao so với khu vực Cầu Giấy.');
/////////////////////////////////////////////
