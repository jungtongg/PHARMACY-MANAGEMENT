/* 1. Thực hiện câu truy vấn thông tin 3 nhân viên có mức lương 
cao nhất và lớn hơn 5000$. */

SELECT TOP(3)*FROM NhanVien
WHERE Luong > 5000
ORDER BY Luong DESC;

/* 2. Thực hiện truy vấn tính tổng số đơn hàng đã được bán trong
tháng 01/2023. */

SELECT COUNT(*) AS TongSoDonHang
FROM HoaDon
WHERE NgayBan BETWEEN '2023-01-01' AND '2023-01-31';

/* 3. Thực hiện câu truy vấn thống kê các đơn hàng do nhân viên 
có mã nhân viên là NV001 phục vụ. */

SELECT HD.MaHD, HD.MaNV
FROM HoaDon HD
WHERE HD.MaNV = 'NV001';

/* 4. Thực hiện câu truy vấn liệt kê hoá đơn có tổng giá lớn hơn
giá trị trung bình của các hoá hàng. */

SELECT HD.MaHD, HD.MaNV, HD.MaKH, HD.NgayBan, HD.TongGia
FROM HoaDon HD
WHERE HD.TongGia > (SELECT AVG(TongGia) FROM HoaDon);

/* 5. Thực hiện câu truy vấn liệt kê các loại thuốc có số lượng
còn nhỏ hơn 70. */

SELECT MaThuoc, TenThuoc, SoLuongThuocCon
FROM Thuoc
WHERE SoLuongThuocCon < 70
ORDER BY SoLuongThuocCon ASC;

/* 6. Thực hiện câu truy vấn cập nhật số lượng thuốc thuộc danh 
mục Thuốc giảm đau thành 200. */

UPDATE Thuoc
SET SoLuongThuocCon = 200
WHERE MaDanhMuc IN (
    SELECT MaDanhMuc
    FROM DanhMuc
    WHERE TenDanhMuc = 'Thuoc giam dau'
);

/* 7. Thực hiện câu truy vấn liệt kê các loại thuốc thuộc danh 
mục Thực phẩm chức năng chưa được cập nhật thông tin về nhà cung cấp. */

SELECT T.MaThuoc, T.TenThuoc
FROM Thuoc T
LEFT JOIN DanhMuc D ON T.MaDanhMuc = D.MaDanhMuc
LEFT JOIN NhaCungCap NCC ON T.MaNCC = NCC.MaNCC
WHERE D.TenDanhMuc = 'Thuc pham chuc nang' AND T.MaNCC IS NULL;

/* 8. Thực hiện câu truy vấn thông tin tất cả khách hàng mua hàng
từ ngày 01/01/2023 – 01/31/2023 và có tổng giá lớn hơn 200$. */

SELECT DISTINCT KH.MaKH, TenKH, SDT, HD.NgayBan, HD.TongGia
FROM KhachHang KH
INNER JOIN HoaDon HD ON KH.MaKH = HD.MaKH
WHERE HD.NgayBan BETWEEN '2023-01-01' AND '2023-01-31'
GROUP BY KH.MaKH, TenKH, SDT, HD.NgayBan, HD.TongGia
HAVING HD.TongGia > 200;

/* 9. Thực hiện câu truy vấn thông tin các khách hàng có giới tính
là nữ, có cùng địa chỉ ở Thái Bình, đã mua thuốc trong tháng 01/2023 và tháng 02/2023. */

SELECT KH.MaKH, KH.TenKH, KH.GT, KH.DiaChi, KH.SDT
FROM KhachHang KH
INNER JOIN HoaDon HD ON KH.MaKH = HD.MaKH
INNER JOIN ThuocTrongHoaDon TTHD ON HD.MaHD = TTHD.MaHD
WHERE KH.GT = 'Nu'
      AND KH.DiaChi LIKE '%Thai Binh%'
      AND HD.NgayBan BETWEEN '2023-01-01' AND '2023-02-28';

/* 10. Thực hiện câu truy vấn liệt kê các loại thuốc có hơn 6 
khách hàng mua. */

SELECT T.MaThuoc, T.TenThuoc, COUNT(DISTINCT H.MaKH) AS SoLuotKHMua
FROM Thuoc T
INNER JOIN ThuocTrongHoaDon THD ON T.MaThuoc = THD.MaThuoc
INNER JOIN HoaDon H ON THD.MaHD = H.MaHD
GROUP BY T.MaThuoc, T.TenThuoc
HAVING COUNT(DISTINCT H.MaKH) > 6;

/* 11. Thực hiện câu truy vấn liệt kê các loại thuốc thuộc danh 
mục Thuốc hạ sốt, được nhập bởi nhà cung cấp có mã cung cấp là NCC001. */

SELECT Thuoc.MaThuoc, Thuoc.TenThuoc, Thuoc.GiaBan
FROM Thuoc
INNER JOIN NhaCungCap ON Thuoc.MaNCC = NhaCungCap.MaNCC
INNER JOIN DanhMuc ON Thuoc.MaDanhMuc = DanhMuc.MaDanhMuc
WHERE DanhMuc.TenDanhMuc = 'Thuoc ha sot' 
      AND NhaCungCap.MaNCC = 'NCC001';

/* 12. Thực hiện câu truy vấn liệt kê các loại thuốc trong thời 
gian 01/01/2023 - 30/06/2023 không có khách hàng nào mua. */

SELECT T.MaThuoc, T.TenThuoc
FROM Thuoc T
WHERE NOT EXISTS (
    SELECT 1
    FROM HoaDon HD
    INNER JOIN ThuocTrongHoaDon TTHD ON HD.MaHD = TTHD.MaHD
    WHERE TTHD.MaThuoc = T.MaThuoc 
	      AND HD.NgayBan BETWEEN '2023-01-01' AND '2023-06-30'
);

/* 13. Thực hiện câu truy vấn liệt kê các loại thuốc có giá lớn 
hơn 6$, được cung cấp bởi nhà cung cấp MaNCC = NCC001 sẽ hết hạn vào 01/12/2024. */

SELECT T.MaThuoc, T.TenThuoc, T.GiaBan, T.HSD
FROM Thuoc T
INNER JOIN NhaCungCap NCC ON T.MaNCC = NCC.MaNCC
WHERE T.GiaBan > 6 AND NCC.MaNCC = 'NCC001' 
      AND T.HSD <= '2024-12-01'
ORDER BY T.GiaBan ASC;

/* 14. Thực hiện câu truy vấn liệt kê khách hàng đã mua cả hai 
loại thuốc Paracetamol và Vitamin C trên cùng một đơn hàng vào ngày 05/01/2023. */

SELECT KH.MaKH, KH.TenKH, KH.SDT
FROM KhachHang KH
INNER JOIN HoaDon HD ON KH.MaKH = HD.MaKH
INNER JOIN ThuocTrongHoaDon TTHD ON HD.MaHD = TTHD.MaHD
INNER JOIN Thuoc T ON TTHD.MaThuoc = T.MaThuoc
WHERE T.TenThuoc IN ('Paracetamol', 'Vitamin C') 
      AND HD.NgayBan = '2023-01-05'
GROUP BY KH.MaKH, KH.TenKH, KH.SDT
HAVING COUNT(DISTINCT T.TenThuoc) = 2;

/* 15. Thực hiện câu truy vấn tính tổng số hoá đơn trong tháng 01/2023, tính giá trị trung bình, giá trị lớn 
nhất, giá trị nhỏ nhất số hoá đơn được xuất trong một ngày trong tháng 01/2023. */

SELECT 
    COUNT(TongSoHoaDonThang) AS TongSoHoaDonThang,
    AVG(TongSoHoaDonThang) AS TrungBinhSoHoaDon,
    MAX(TongSoHoaDonThang) AS SoHoaDonMax,
    MIN(TongSoHoaDonThang) AS SoHoaDonMin
FROM (
    SELECT COUNT(MaHD) AS TongSoHoaDonThang, NgayBan
    FROM HoaDon
    WHERE NgayBan >= '2023-01-01' AND NgayBan <= '2023-01-31'
    GROUP BY NgayBan
) AS TongSoHoaDonTheoNgay;

/* 16. Thực hiện câu truy vấn liệt kê số lượng tổng thuốc đã bán trong mỗi tháng trong năm 2023. */

SELECT 
    MONTH(HD.NgayBan) AS Thang, 
    YEAR(HD.NgayBan) AS Nam, 
    COUNT(HT.MaThuoc) AS TongSoLuongBan
FROM HoaDon HD
INNER JOIN ThuocTrongHoaDon HT ON HD.MaHD = HT.MaHD
GROUP BY MONTH(HD.NgayBan), YEAR(HD.NgayBan)
ORDER BY Nam, Thang;

/* 17. Thực hiện câu truy vấn liệt kê các loại thuốc đã được bán trong tháng 05/2023 và có tổng số lượng bán 
lớn hơn 10. */

SELECT T.MaThuoc, T.TenThuoc, SUM(TTHD.SoLuongBan) AS TongSoLuongBan
FROM Thuoc T
LEFT JOIN ThuocTrongHoaDon TTHD ON T.MaThuoc = TTHD.MaThuoc
LEFT JOIN HoaDon HD ON TTHD.MaHD = HD.MaHD
WHERE HD.NgayBan >= '2023-05-01' AND HD.NgayBan <= '2023-05-31'
GROUP BY T.MaThuoc, T.TenThuoc
HAVING SUM(TTHD.SoLuongBan) > 10
ORDER BY TongSoLuongBan DESC;

/* 18. Thực hiện câu truy vấn liệt kê các khách hàng có 4 lần trở lên mua thuốc ở cửa hàng.*/

SELECT KH.MaKH, KH.TenKH
FROM KhachHang KH
WHERE 
     EXISTS( SELECT 1
	         FROM HoaDon HD
			 WHERE KH.MaKH = HD.MaKH AND HD.MaHD IN (
                   SELECT MaHD
                   FROM ThuocTrongHoaDon TTHD
                   GROUP BY MaHD
                   HAVING COUNT(MaThuoc) >= 4)
);

/* 19. Thực hiện câu truy vấn liệt kê thông tin khách hàng mua loại thuốc có mã là TH001 với số lượng nhiều nhất trên 1 đơn hàng
trong ngày 05/01/2023. */

WITH XepHangKhachHang AS (
    SELECT KH.MaKH,
           KH.TenKH,
           SUM(TTH.SoLuongBan) AS TongSoLuongMua,
           RANK() OVER (ORDER BY SUM(TTH.SoLuongBan) DESC) AS XepHangSLM
    FROM KhachHang KH
    JOIN HoaDon HD ON KH.MaKH = HD.MaKH
    JOIN ThuocTrongHoaDon TTH ON HD.MaHD = TTH.MaHD
    JOIN Thuoc T ON TTH.MaThuoc = T.MaThuoc
    WHERE T.MaThuoc = 'TH001' AND HD.NgayBan = '2023-01-05'
    GROUP BY KH.MaKH, KH.TenKH
)
SELECT MaKH, TenKH, TongSoLuongMua
FROM XepHangKhachHang
WHERE XepHangSLM = 1;


/* 20. Thực hiện câu truy vấn lấy thông tin về các hóa đơn và tên khách hàng tương ứng trong tháng 01/2023, các khách hàng này có địa chỉ ở Hà Nội, cùng với giá bán thấp nhất và cao nhất của 
các loại thuốc được mua trong mỗi hóa đơn. */

SELECT HD.MaHD, KH.TenKH, 
       MIN(T.GiaBan) AS GiaThuocThapNhat, 
       MAX(T.GiaBan) AS GiaThuocCaoNhat
FROM HoaDon HD
JOIN KhachHang KH ON HD.MaKH = KH.MaKH
JOIN ThuocTrongHoaDon TTH ON HD.MaHD = TTH.MaHD
JOIN Thuoc T ON TTH.MaThuoc = T.MaThuoc
WHERE KH.DiaChi LIKE '%Ha Noi%' AND MONTH(HD.NgayBan) = '1' 
      AND YEAR(HD.NgayBan) = '2023'
GROUP BY HD.MaHD, KH.TenKH
ORDER BY KH.TENKH ASC;














 
      











