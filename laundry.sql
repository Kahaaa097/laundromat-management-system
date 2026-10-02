--1. Thêm dữ liệu vào bảng CUSTOMERORDER
--Giả sử khách hàng có mã C1234 tạo một đơn hàng mới.
INSERT INTO CUSTOMERORDER (orderID, customerID, OrderNote, OrderStatus)
VALUES ('O000001', 'C1234', 'Giặt nhẹ nhàng, ưu tiên giao sớm', 'pending')
--2. Xóa dữ liệu từ bảng PACKAGE
--Xóa một package có mã P000001 (cục đồ cụ thể trong đơn hàng).
DELETE FROM PACKAGE
WHERE packID = 'P000001'
--3. Cập nhật trạng thái của một đơn hàng
--Cập nhật trạng thái của đơn hàng O000001 từ "processing" thành "done".
UPDATE CUSTOMERORDER
SET OrderStatus = 'done'
WHERE orderID = 'O000001'
--4. Báo cáo tổng doanh thu theo tháng
--Truy vấn này tính tổng doanh thu từ các khoản thanh toán đã thực hiện theo từng tháng trong năm.
SELECT YEAR(DateTime) AS Year, MONTH(DateTime) AS Month, SUM(Amount) AS TotalRevenue
FROM PAYMENT
GROUP BY YEAR(DateTime), MONTH(DateTime)
ORDER BY Year, Month
--5. Báo cáo doanh thu theo loại dịch vụ
--Truy vấn này tính tổng doanh thu theo từng loại dịch vụ trong một khoảng thời gian nhất định.
SELECT S.ServiceName, SUM(P.Amount) AS TotalRevenue
FROM PAYMENTDETAIL PD
JOIN PAYMENT P ON PD.paymentID = P.paymentID
JOIN CUSTOMERORDER CO ON PD.orderID = CO.orderID
JOIN PACKAGE PK ON CO.orderID = PK.orderID
JOIN SERVICE S ON PK.serviceID = S.serviceID
WHERE P.DateTime BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY S.ServiceName
ORDER BY TotalRevenue DESC
--6. Hiệu suất hoạt động của nhân viên (số lượng đơn hàng xử lý)
--Liệt kê số lượng đơn hàng mà mỗi nhân viên đã xử lý, sắp xếp theo số lượng đơn hàng từ cao xuống thấp.
SELECT ST.StaffName, COUNT(OH.orderID) AS OrdersHandled
FROM STAFF ST
JOIN ORDERHANDLING OH ON ST.staffID = OH.staffID
GROUP BY ST.StaffName
ORDER BY OrdersHandled DESC
--7. Năng suất của nhân viên theo khối lượng đồ đã xử lý
--Truy vấn này tính tổng khối lượng đồ mà mỗi nhân viên đã xử lý.
SELECT ST.StaffName, SUM(PK.Weight) AS TotalWeightHandled
FROM STAFF ST
JOIN ORDERHANDLING OH ON ST.staffID = OH.staffID
JOIN PACKAGE PK ON OH.orderID = PK.orderID
GROUP BY ST.StaffName
ORDER BY TotalWeightHandled DESC
--8. Năng suất của máy giặt (số lượng và khối lượng đồ đã giặt)
--Báo cáo này hiển thị số lượng package và tổng khối lượng đồ giặt được xử lý bởi mỗi máy giặt.
SELECT M.machineID, M.Brand, M.Model, COUNT(PK.packID) AS TotalPackages, SUM(PK.Weight) AS TotalWeight
FROM MACHINE M
JOIN PACKAGE PK ON M.machineID = PK.machineID
GROUP BY M.machineID, M.Brand, M.Model
ORDER BY TotalWeight DESC
--9. Báo cáo khách hàng có tần suất giặt cao nhất
--Truy vấn này liệt kê các khách hàng có số lượng đơn hàng cao nhất, giúp tiệm nhận diện khách hàng thường xuyên.
SELECT C.CusName, C.Phone, COUNT(CO.orderID) AS OrdersCount
FROM CUSTOMER C
JOIN CUSTOMERORDER CO ON C.customerID = CO.customerID
GROUP BY C.CusName, C.Phone
ORDER BY OrdersCount DESC
--10. Kiểm tra trạng thái đơn hàng và tính năng suất của từng loại dịch vụ
--Hiển thị trạng thái của các đơn hàng và tính tổng số đơn hàng cho từng loại dịch vụ trong trạng thái cụ thể (ví dụ: "done").
SELECT S.ServiceName, CO.OrderStatus, COUNT(CO.orderID) AS OrdersCount
FROM CUSTOMERORDER CO
JOIN PACKAGE PK ON CO.orderID = PK.orderID
JOIN SERVICE S ON PK.serviceID = S.serviceID
WHERE CO.OrderStatus = 'done'
GROUP BY S.ServiceName, CO.OrderStatus
ORDER BY OrdersCount DESC