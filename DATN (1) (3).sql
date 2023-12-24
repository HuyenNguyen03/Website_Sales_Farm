
DROP DATABASE IF EXISTS greenfarm;
CREATE DATABASE greenfarm;
USE greenfarm;

-- Tạo bảng Users để lưu trữ thông tin người dùng và liên kết với UserRoles
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Password NVARCHAR(255) NULL,
    Email NVARCHAR(255)NOT NULL,
    FirstName NVARCHAR(255)NOT NULL,
    LastName NVARCHAR(255)NOT NULL,
    PhoneNumber NVARCHAR(15)NOT NULL,
	Image NVARCHAR(255) NULL ,
	Gender BIT NULL,
	Birthday DATE NULL,
	CreatedDate DATE NOT NULL, -- Ngày tạo
    account_verified TINYINT DEFAULT false,
    isDeleted bit default false,
    provider nvarchar(255) null
);

CREATE TABLE Address (
	AddressID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    UserID INT  NOT NULL,
    Street NVARCHAR(255) NOT NULL,
     Ward NVARCHAR(255) NOT NULL,
    District NVARCHAR(255) NOT NULL,
    City NVARCHAR(255) NOT NULL,
    Phonenumber NVARCHAR(10) NOT NULL,
    Fullname NVARCHAR(45) NOT NULL,
    Active BIT DEFAULT FALSE,
    constraint FK_ADDRESS_USER foreign key(UserID) references Users(UserID)
);

CREATE TABLE Roles(
	ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	Name NVARCHAR(50) NOT NULL
);
-- Tạo bảng UserRoles để lưu trữ quyền của người dùng
CREATE TABLE UserRoles (
    UserRoleID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    RoleID INT,
	UserID INT NOT NULL,
    constraint FK_USERROLES_USER foreign key(UserID) references Users(UserID),
    constraint FK_USERROLES_ROLE foreign key(RoleID) references Roles(ID)
);

-- Tạo bảng loại sản phẩm
CREATE TABLE ProductCategories (
    CategoryID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    CategoryName NVARCHAR(255) NOT NULL,
    Descriptions NVARCHAR(1000) NULL,
     isdeleted bit default false
);

-- Tạo bảng Products để lưu trữ thông tin sản phẩm nông sản và liên kết với Users và ProductCategories
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ProductName NVARCHAR(255),
    Description NVARCHAR(1000) NULL,
    Price DECIMAL(10, 3),
	Image NVARCHAR(255),
    QuantityAvailable INT,
    CategoryID INT NOT NULL,
    isDeleted bit default false,
    constraint FK_PRODUCTS_CATEGORY foreign key(CategoryID) references ProductCategories(CategoryID)
);

-- Tạo bảng Lưu trữ các hình ảnh của sản phẩm
CREATE TABLE ProductImages (
    ProductImageID INT PRIMARY KEY AUTO_INCREMENT NOT NULL ,
    ProductID INT NOT NULL,
    ImageURL NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_PRODUCT_IMAGES FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);
-- Tạo bảng tình trạng đơn đặt hàng
CREATE TABLE StatusOrders (
    StatusOrderID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Name NVARCHAR(50) NOT NULL
);

-- Tạo bảng tình trạng booking
CREATE TABLE StatusBookings (
    StatusBookingID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Name NVARCHAR(50) NOT NULL
);

-- Tạo bảng PaymentMethods để lưu trữ thông tin phương thức thanh toán
CREATE TABLE PaymentMethods (
    PaymentMethodID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    MethodName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(1000)NOT NULL
);

-- Tạo bảng Orders để lưu trữ thông tin đơn hàng và liên kết với Users
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    UserID INT NOT NULL,
    OrderDate DATETIME,
    StatusOrderID INT NOT NULL,
	AddressID INT NOT NULL,
	PaymentMethodID INT NULL,
	constraint FK_ORDERS_STATE foreign key(StatusOrderID) references StatusOrders(StatusOrderID),
    constraint FK_ORDERS_USER foreign key(UserID) references Users(UserID),
	constraint FK_ORDERDETAILS_PAYMENTMETHODS foreign key(PaymentMethodID) references PaymentMethods(PaymentMethodID),
    constraint FK_ORDERD_ADDRESS foreign key(AddressID) references  Address(AddressID)
);

-- Tạo bảng OrderDetails để lưu trữ chi tiết đơn hàng và liên kết với Orders và Products
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    QuantityOrdered Float NOT NULL,
    TotalPrice LONG NOT NULL,
    constraint FK_ORDERDETAILS_ODERS foreign key(OrderID) references Orders(OrderID),
    constraint FK_ORDERDETAILS_PRODUCTS foreign key(ProductID) references Products(ProductID)

);
-- Tạo bảng Tours để lưu trữ thông tin tour tham quan
CREATE TABLE Tours (
    TourID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    TourName NVARCHAR(255),
    Description NVARCHAR(1000) NULL, -- Mô tả tour sáng trưa chiều
	Image NVARCHAR(255) NULL,
    Departureday NVARCHAR(50) NULL,
    Location NVARCHAR(255) NULL,
    isdeleted bit default false
);	

-- Tạo bảng giá cho người lớn, trẻ em và trẻ dưới 4 tuổi
CREATE TABLE Pricings (
    PricingID INT PRIMARY KEY AUTO_INCREMENT  NOT NULL,
    TourID INT  UNIQUE, 
    AdultPrice Float NULL, -- Giá cho người lớn
    ChildPrice Float NULL, -- Giá cho trẻ em
    FOREIGN KEY(TourID) REFERENCES Tours(TourID)
);


-- Tạo bảng Tổng quan tour
CREATE TABLE TourOverviews (
	TourOverviewID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    TourID INT UNIQUE NULL,
    Title NVARCHAR(255) NULL,
    Content TEXT NULL,
    CONSTRAINT FK_TOUR_OVERVIEW FOREIGN KEY (TourID) REFERENCES Tours (TourID)
);
-- Tạo bảng Điều kiện tour
CREATE TABLE TourConditions (
    TourConditionID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    TourID INT UNIQUE NULL,
	Conditions TEXT NULL,
    CONSTRAINT FK_TOUR_CONDITIONS FOREIGN KEY (TourID) REFERENCES Tours (TourID)
);
-- Tạo bảng Hình ảnh tour - chứa nhiều hình ảnh của Tour
CREATE TABLE TourImages (
    TourImageID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    TourID INT NULL,
    ImageURL NVARCHAR(255) NULL,
    CONSTRAINT FK_TOUR_IMAGES FOREIGN KEY (TourID) REFERENCES Tours (TourID)
);

-- Tạo bảng ngày giờ Tour - chứa ngày giờ tour và số lượng chỗ
CREATE TABLE Tourdates (
    TourdateID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    TourID INT not NULL,
    Tourdates DATE not NULL,
    AvailableSlots INT NULL,
    CONSTRAINT FK_TOUR_DATES FOREIGN KEY (TourID) REFERENCES Tours (TourID)
);

-- Tạo bảng Bookings để lưu trữ thông tin đặt tour và liên kết với Users và Tours
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    TourID INT NOT NULL,
    BookingDate DATETIME NOT NULL,
    TotalPrice float NOT NULL,
	AdultTicketNumber INT NULL default 1,
    ChildTicketNumber INT NULL default 0,
	StatusBookingID INT NOT NULL,
    PaymentMethodID INT NULL,
    qrcode text null,
    usedate DateTime null,
    constraint FK_BOOKING_TOURS foreign key(TourID) references Tours(TourID),
    constraint FK_BOOKING_USERS foreign key(UserID) references Users(UserID),
    constraint FK_BOOKING_STATUS foreign key(StatusBookingID) references StatusBookings(StatusBookingID),
    constraint FK_BOOKINGS_PAYMENTMETHODS foreign key(PaymentMethodID) references PaymentMethods(PaymentMethodID)
);

-- Tạo bảng luu tru thoi gian - chứa ngày giờ và list đặt
CREATE TABLE TourDatebookings (
    TourDatebookingID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    TourdateID INT not NULL,
    BookingID INT not NULL,
    CONSTRAINT FK_TOURDatebooking_Tourdates FOREIGN KEY (TourdateID) REFERENCES Tourdates (TourdateID),
    CONSTRAINT FK_TOURDatebooking_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings (BookingID)
);

-- Tạo bảng Comments cho phép người dùng bình luận theo tour
CREATE TABLE Comments (
    CommentID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    UserID INT NOT NULL,
    TourID INT  NOT NULL,
    CommentText NVARCHAR(1000) NOT NULL,
    CommentDate DATETIME NOT NULL,
    isdeleted bit default false,
    CONSTRAINT FK_Comments_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Comments_Tours FOREIGN KEY (TourID) REFERENCES Tours(TourID)
);

-- Tạo bảng ReComments cho phép admin trả lời bình luận tour
CREATE TABLE ReComments (
    ReCommentID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    UserID INT NOT NULL,
    CommentID INT  NOT NULL,
    ReCommentText NVARCHAR(1000) NOT NULL,
    ReCommentDate DATETIME NOT NULL,
    CONSTRAINT FK_ReComments_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_ReComments_Comments FOREIGN KEY (CommentID) REFERENCES Comments(CommentID)
);


-- Tạo bảng ratings cho phép người dùng bình luận theo tour
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    content NVARCHAR(1000)  NULL,
    datepost DATETIME NOT NULL,
    rating Int NOT NULL,
	UserID INT NOT NULL,
    ProductID INT NOT NULL,
    CONSTRAINT FK_Reviews_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Reviews_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Cart (
 	CartID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	UserID  int not null,
	ProductID int not null,
    Quantity float not null,
     CONSTRAINT FK_Carts_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Carts_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
 );
 
CREATE TABLE securetokens (
  id int NOT NULL AUTO_INCREMENT,
  token varchar(255) NOT NULL,
  time_stamp timestamp NULL DEFAULT NULL,
  userid int DEFAULT NULL,
  expire_at datetime NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY token_UNIQUE (token),
  CONSTRAINT FK_USID_TKUSID FOREIGN KEY (userid) REFERENCES Users(UserID)
) ;

-- Tạo bảng Voucher
CREATE TABLE Vouchers (
    VoucherID INT  PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Code VARCHAR(20) NOT NULL,
    Discount Float NOT NULL,
    ExpirationDate DATETIME,
    isDeleted bit default false
);
-- Bảng
CREATE TABLE VoucherUsers(
	VoucherUserID INT  PRIMARY KEY AUTO_INCREMENT NOT NULL,
	ExpirationDate DATETIME,
	UserID INT,
    VoucherID INT,
 	FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (VoucherID) REFERENCES Vouchers(VoucherID)
);

CREATE TABLE VoucherOrders(
	VoucherOrderID INT  PRIMARY KEY AUTO_INCREMENT NOT NULL,
    OrderID INT,
	VoucherID INT,
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (VoucherID) REFERENCES Vouchers(VoucherID)
);

CREATE TABLE provider (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Contacts (
    contactid INT  PRIMARY KEY AUTO_INCREMENT NOT NULL,
    email VARCHAR(255) NOT NULL,
    fullname VARCHAR(255) NOT NULL,
    phonenumber NVARCHAR(15)NOT NULL,
    content NVARCHAR(15)NOT NULL,
    createddate Date not null
);




INSERT INTO provider (name) VALUES ('LOCAL'), ('GOOGLE'), ('FACEBOOK'), ('GITHUB');

-- /////////////////////////////////////////////////////////////////////////////////////
--
--
--
--
--
--
--
--
-- /////////////////////////////////////////////////////////////////////////////////////

INSERT INTO Roles (ID, Name) VALUES 
(1,'Administrator'),
(2,'User');

INSERT INTO Users (UserID, Password, Email, FirstName, LastName, PhoneNumber, Image,Gender, Birthday, CreatedDate , account_verified) VALUES 
(1,'$2a$12$LLyq6PvG.ziWt99pxJo/d.ZGrphlK6iz2fnpp4NLPd3fuChjMTckO','phongvo@gmail.com','Phong','Võ','0969023190','https://i.imgur.com/O6oIKZp.jpg',1,'2003-04-10','2019-03-29',1),
(2,'$2a$12$LLyq6PvG.ziWt99pxJo/d.ZGrphlK6iz2fnpp4NLPd3fuChjMTckO','huyen03@gmail.com','Huyền','Nguyễn','0844831357','https://nhadepso.com/wp-content/uploads/2023/02/anh-gai-xinh-han-quoc_2.jpg',0,'2003-12-28','2020-09-23',1),
(3,'$2a$12$LLyq6PvG.ziWt99pxJo/d.ZGrphlK6iz2fnpp4NLPd3fuChjMTckO','chau01@gmail.com','Châu','Lê Nguyễn','0904071234','https://allimages.sgp1.digitaloceanspaces.com/photographereduvn/2022/07/1656721586_688_Top-99-hinh-anh-hot-girl-xinh-me-hon-quen.jpg',1,'2003-10-28','2021-11-01',1),
(4,'$2a$12$LLyq6PvG.ziWt99pxJo/d.ZGrphlK6iz2fnpp4NLPd3fuChjMTckO','hungnvps20689@fpt.edu.vn','Hưng','Nguyễn Văn','0908765437','https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/3/6/1020690/7173C8ac5ff2c2d12a58.jpg',0,'2003-09-18','2019-04-19',1),
(5,'$2a$12$LLyq6PvG.ziWt99pxJo/d.ZGrphlK6iz2fnpp4NLPd3fuChjMTckO','dat01@gmail.com','Đạt','Nguyễn','0355204677','https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/3/6/1020690/20190323154558-D7c4.jpg',0,'2003-01-01','2023-05-15',1),
(6,'$2a$04$Apxw1BIhRVGwCb8eZlVn2.6KN2OY.JuPvA68EKq2uNxseUwhRmiS.','duc01@gmail.com','Đức','Phúc','0932012782','https://bloghomestay.vn/wp-content/uploads/2023/01/49-hinh-anh-trai-dep-han-quoc-lam-rung-rinh-trai-tim-cac-co-gai_6.jpg',0,'2003-01-01','2023-01-29',1),
(7,'$2a$04$Apxw1BIhRVGwCb8eZlVn2.6KN2OY.JuPvA68EKq2uNxseUwhRmiS.','duy02@gmail.com','Duy','Trần','0923674674','https://toigingiuvedep.vn/wp-content/uploads/2021/06/hinh-anh-trai-dep-han-quoc-sieu-cute.jpg',0,'1995-07-10','2022-07-21',1),
(8,'$2a$04$Apxw1BIhRVGwCb8eZlVn2.6KN2OY.JuPvA68EKq2uNxseUwhRmiS.','duyt@gmail.com','Duy','Thanh','0932012782','https://nhadepso.com/wp-content/uploads/2023/02/hinh-anh-trai-dep-han-quoc_5.jpg',0,'1985-03-20','2023-03-30',1),
(9,'$2a$04$Apxw1BIhRVGwCb8eZlVn2.6KN2OY.JuPvA68EKq2uNxseUwhRmiS.','vien05@gmail.com','Viện','Ngô','0977108584','https://kenh14cdn.com/thumb_w/660/2018/5/14/screen-shot-2018-05-14-at-95102-pm-15263096678601566792350.png',0,'1957-05-07','2021-10-13',1),
(10,'$2a$04$Apxw1BIhRVGwCb8eZlVn2.6KN2OY.JuPvA68EKq2uNxseUwhRmiS.','khaihc@gmail.com','Khải','Hoàng','0374567239','https://kenh14cdn.com/2018/5/14/screen-shot-2018-05-14-at-95026-pm-1526309638534871393209.png',0,'1990-01-15','2023-01-28',1),
(11,'$2a$04$Apxw1BIhRVGwCb8eZlVn2.6KN2OY.JuPvA68EKq2uNxseUwhRmiS.','vothanhphong2000bt@gmail.com','Admin','admin','0909099991','https://kenh14cdn.com/thumb_w/660/2018/5/14/screen-shot-2018-05-14-at-95102-pm-15263096678601566792350.png',0,'1990-01-15','2023-01-28',1),
(12 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'thanhhong@gmail.com', 'Thanh','Hồng', '0123456789','https://cdn.sforum.vn/sforum/wp-content/uploads/2023/11/avatar-dep-60.jpg',0,'2000-02-02','2019-01-28',1 ),
(13 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'anhkhoi@gmail.com', 'Anh','Khôi', '0123456745','https://img.lovepik.com/free-png/20210926/lovepik-cartoon-avatar-png-image_401440426_wh1200.png',0,'2000-02-02','2019-01-28',1),
(14 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'thanhdat@gmail.com', 'Thanh','Đạt', '0123453589','https://img.lovepik.com/free-png/20211206/lovepik-cartoon-avatar-png-image_401349915_wh1200.png',0,'2000-02-02','2019-01-28',1),
(15 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'anhtuyetg@gmail.com', 'Ánh','Tuyết', '0123442789','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnleBhLkx-MF1dYvUMIkZQo8ekNW7ZYgJ7jA&usqp=CAU',0,'2000-02-02','2019-01-28',1 ),
(16 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'tuananh@gmail.com', 'Kim','Tuyền', '0123456619','https://luatdainam.vn/wp-content/uploads/2023/08/50-avatar-cap-anime-cho-2-nguoi-dep-nhat-hien-nay-2020.jpg',0,'2000-02-02','2019-01-28',1),
(17 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'trancong@gmail.com', 'Trần Văn','Công', '0198456788','https://luatdainam.vn/wp-content/uploads/2023/08/50-avatar-cap-anime-cho-2-nguoi-dep-nhat-hien-nay-2020-45.jpg',0,'2000-02-02','2019-01-28',1 ),
(18 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'ducanh@gmail.com', 'Đức','Anh', '0123456469','https://i.pinimg.com/236x/70/ce/09/70ce09f77dcb00f296498d1b89df35cf.jpg',0,'2000-02-02','2019-01-28',1),
(19 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'pampam@gmail.com', 'Pé','Pam', '0123456399','https://luatdainam.vn/wp-content/uploads/2023/08/1767.jpg',0,'2000-02-02','2019-01-28',1 ),
(20 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'hihi@gmail.com', 'Minh','Minh', '0123458389','https://symbols.vn/wp-content/uploads/2021/12/Hinh-Anime-nu-toc-ngan-xinh-dep.jpg',0,'2000-02-02','2019-01-28',1),
(21 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'kieudiem@gmail.com', 'Kiều','Diễm', '0198456789','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGtTeRiQCdEmxHankqo_eH351jBS-U8oh-QA&usqp=CAU',0,'2000-02-02','2019-01-28',1),
(22 ,'$2a$12$DCVuWZ.xwKpbBn8jXnAYtePYw2fq3EhHUBpLdyAVDN4D3vQYKoSfu', 'theanh@gmail.com', 'Thế','Anh', '0123459589','https://anhcuoiviet.vn/wp-content/uploads/2023/02/avatar-ngau-anime-1.jpg',0,'2000-02-02','2019-01-28',1),
(23 ,'$2a$12$6LpPO.adm6U1Q84aKLfcbuJ4m0C3063RM1ztuvBaMzqaLqnFUzJbK', 'greenfarmcompany2023@gmail.com', 'Nghĩa','Hoàng', '0123459588','https://i.imgur.com/EulC0tm.jpg',0,'2000-02-02','2019-01-28',1);
INSERT INTO Address(AddressID,UserID,Street, Ward,District,City,Phonenumber,Fullname,Active) VALUES
(1,1,'356/20G, Xô viết nghệ tinh','Phường 25','Quận Bình Thạnh','Tp Hồ Chí Minh','0914453588','Hiền',1),
(12,1,'Hoàng Văn Thụ','Phường Phước Ninh','Quận Hải Châu','Đà Nẵng','0948157159','Hậu',0),
(13,2,'356/20G, Xô viết nghệ tinh', 'Phường 25','Quận Bình Thạnh','Tp Hồ Chí Minh','0912300247','Huế',1),
(2,2,'Hoàng Văn Thụ', 'Phường Phước Ninh','Quận Hải Châu','Đà Nẵng','0915133607','Hà',0),
(3,3,'Xô Viết Nghệ Tĩnh', 'Phường 25','Quận Bình Thạnh','Tp Hồ Chí Minh','0915391312','Huỳnh',1),
(4,4,'Đường 79', 'Phường Tân Quy','Quận 7','Tp Hồ Chí Minh','0913602103','Hùng',1),
(5,5,'Trần Não', 'Phường An Khánh','(Quận 2 cũ), Thành phố Thủ Đức','Tp Hồ Chí Minh','0905372666','Huy',1),
(6,6,'Đường Số 6', 'Phường 5','Quận 8','Tp Hồ Chí Minh','0949234388','Hảo',1),
(7,7,'234, Hẻm 243 Đường Nguyễn Đức Thiệu', 'Phường Dĩ An','Thành phố Dĩ An','Bình Dương','0911375199','Hát',1),
(8,8,'Đht 08', 'Phường Đông Hưng Thuận','Quận 12','Tp Hồ Chí Minh','0949522905','Học',0),
(9,9,'207/44/6, Phạm Văn Hai', 'Phường 5',' Quận Tân Bình','Tp Hồ Chí Minh','0914500150','Duy Minh',1),
(10,10,'Đường Huỳnh Tấn Phát', 'Phường Bình Thuận','Quận 7','Tp Hồ Chí Minh','0912222798','Vũ',1),
(11,11,'338, An dương vương', 'Phường 4','Quận 5','Tp Hồ Chí Minh','0944747978','Tài',1),
(14,14,'Phường Phúc Xá,Quận Ba Đình', 'Phường Phúc Xá','Quận Ba Đình','Hà Nội','0789456123','Hạnh',0),
(15,15,'Xã Lugx Cú, huyện ĐỒng Văn', 'Xã Lũng Xá','Huyện Đồng Văn','Tình Hà Giang','0123456789','Anh',0),
(16,16,'Phường Quang Trung', 'Phường Quang Trung','Thị xã Duy Tiên','Tỉnh Hà Nam','0789545688','Hồng',0),
(17,17,'Xã Nguyễn Úy', 'xã Nguyễn Úy','Huyện Kin Bảng','Tỉnh Hà Nam','0236541255','Minh',0),
(18,18,'Thị trấn Hưng Hà', 'Thị trấn Hưng Hà','Huyện Hưng Hà','Tỉnh Thái Bình','0985751452','Minh',0),
(19,19,'Xã Điệp Nông', 'Xã Điệp Nông','Huyện Hưng Hà','Tỉnh Thái Binhd','0869974456','Bình Mình',0),
(20,20,'Xã Khánh Vân', 'Xã Khánh Vân','Huyện Yên Khánh','Tỉnh Ninh Bình','0897745562','Tuyết',0),
(21,21,'Thị trấn Nho Quan', 'Thị Trấn Nho Quan','Huyện Nho Quan','Tỉnh Ninh Bình','0985574462','Hạnh',0),
(22,22,'Phường Tích Sơn', 'Phường Tích Sơn','Thành Phố Vĩnh Yên','Tỉnh Vĩnh Phúc','0986657746','Thế Anh',0),
(23,12,'Xã Điệp Nông', 'Xã Điệp Nông','Huyện Hưng Hà','Tỉnh Thái Binhd','0869974456','Bình Mình',0),
(24,13,'Xã Khánh Nhạc', 'Xã Khánh Nhạc','Huyện Yên Khánh','Tỉnh Ninh Bình','0897745562','Tuyết',0);

INSERT INTO UserRoles (UserRoleID, RoleID, UserID) VALUES 
(1,2,1),
(2,2,2),
(3,2,3),
(4,2,4),
(5,2,5),
(6,2,6),
(7,2,7),
(8,2,8),
(9,2,9),
(10,2,10),
(11,2,11),
(12,2,12),
(13,2,13),
(14,2,14),
(15,2,15),
(16,2,16),
(17,2,17),
(18,2,18),
(19,2,19),
(20,2,20),
(21,2,21),
(22,2,22),
(23,1,23);

INSERT INTO ProductCategories (CategoryID, CategoryName, Descriptions) VALUES 
(1,'Nhóm lá','Nhóm lá bao gồm các lá rau, lá cây và các loại lá khác. Các lá trong nhóm này mang lại màu sắc tươi tắn, hương vị đặc trưng và chứa nhiều chất dinh dưỡng quan trọng. Chúng không chỉ tạo nên hương vị và hấp dẫn cho các món ăn, mà còn cung cấp các dưỡng chất quan trọng cho sức khỏe.'),
(2,'Nhóm củ – rễ','Nhóm này bao gồm các loại củ và rễ như cà rốt, khoai tây, củ hành và củ cải. Các củ - rễ này là nguồn cung cấp dinh dưỡng quan trọng, chứa nhiều chất xơ và vitamin. Chúng thường được sử dụng trong nhiều món ăn để tăng cường hương vị và giá trị dinh dưỡng.'),
(3,'Nhóm trái cây','Nhóm này bao gồm các loại trái cây như táo, cam, chuối, dứa và nhiều loại trái cây khác. Các trái cây là nguồn cung cấp chất chống oxy hóa, vitamin và khoáng chất. Chúng có hương vị ngọt ngào và tươi mát, được sử dụng trong nhiều món tráng miệng, nước ép và món ăn chay.'),
(4,'Nhóm mầm','Nhóm này bao gồm các loại mầm như mầm đậu, mầm lúa mạch, mầm hạt và các loại mầm khác. Các mầm là nguồn cung cấp protein, chất xơ và các chất dinh dưỡng thiết yếu khác. Chúng thường được sử dụng trong các món salad, mì và món ăn chay.'),
(5,'Hạt','Nhóm này bao gồm các loại hạt như hạt chia, hạt lanh, hạt bí, hạt hướng dương và các loại hạt khác. Các hạt là nguồn cung cấp chất béo lành mạnh, vitamin và khoáng chất. Chúng thường được sử dụng trong nhiều món ăn như bánh mì, mứt và món tráng miệng.');

INSERT INTO Products (ProductID, ProductName, Description, Price, Image, QuantityAvailable, CategoryID) VALUES 
(1,'Bắp cải tím','Bắp cải tím mua về tách từng bẹ lá ra sau đó đem đi ngâm muối khoảng 2-5 phút rồi rửa lại với nước và để ráo. Tùy vào cách sử dụng mà cắt nhỏ bẹ lá hay cắt sợi Không cần rửa nếu chưa sử dụng vì làm cải nhanh hư, các bạn chỉ nên bỏ vào túi ni lông có đục lỗ sau đó để vào tủ lạnh bảo quản trong khoảng 1 tuần.',94000,'https://product.hstatic.net/200000240163/product/0d8048e4e3_4bfd26a97b2142e6a59272580174ca7e_master.png',300,1),
(2,'Bông cải baby','Súp lơ baby (Bông caiđược biết đến là loại thực phẩm giàu dinh dưỡng và có thể dùng chế biến rất nhiều món ăn dinh dưỡng cho con người. Vậy loại thực phẩm mang đến những lợi ích gì cho sức khỏe con người? Phải chế biến thế nào để giữ nguyên chất dinh dưỡng của nó và cách thức bảo quản ra sao? Tất cả những thắc mắc này sẽ được giải đáp qua bài viết sau đây, mời bạn đọc tham khảo.',129000,'https://product.hstatic.net/200000240163/product/bongcaibaby_f5a4a44605684db4a49bf9cd9780863b_master.jpg',250,1),
(3,'Bông cải trắng','Súp lơ trắng là một loại rau thuộc họ cải và đây cũng là loại rau chứa hàm lượng dinh dưỡng rất cao. Loại rau này thuộc họ Brassica oleracea và có thể mọc quanh năm. Toàn bộ phần hoa đều được sử dụng để chế biến thành những món ăn thơm ngon, hấp dẫn.',100000,'https://product.hstatic.net/200000240163/product/bongcaitrang_1419fe6f195d461a8df8c3deb071f77d_master.png',150,1),
(4,'Bông Cải Xanh','Bông cải xanh còn được gọi là Súp lơ xanh hoặc Cải bông xanh (tên tiếng Anh là Broccoli) là loại cây thuộc loài Cải bắp dại, họ Brassica oleracea có nguồn gốc từ Ý. Hiện nay, ở Việt Nam, bông cải xanh được trồng ở những vùng có khí hậu mát mẻ như Đà Lạt và một số khu vực Tây Nguyên.',105000,'https://product.hstatic.net/200000240163/product/suploxanh_e0ecdc2b57994d548490c6bbc80fea5f_master.jpg',187,1),
(5,'Cà chua beef','Cà chua Beef còn gọi là cà chua thịt bò, thuộc họ Cà (Solanaceae), có nguồn gốc từ Hà Lan, được ghép trên cà dại nhằm hạn chế sâu bệnh có hại. Giống cà chua này mang lại giá trị kinh tế cao hơn nhờ sự tối ưu so với cà chua thông thường.Khí hậu mát mẻ ở những vùng đất của tỉnh Lâm Đồng hoặc vùng núi phía Bắc là điều kiện tốt để giống cà chua beef phát triển khỏe, ra trái đồng đều.',69000,'https://product.hstatic.net/200000240163/product/cachuabeef_3d01b72995f1421c9b203049c5811f81_master.jpg',213,3),
(6,'Cà chua bi socola','Cà chua bi socola hay còn gọi là cà chua cherry socola, có xuất xứ từ Đà Lạt. Loại cà chua bé tý này có màu sắc vô cùng độc đáo. Tên gọi cà chua bi socola xuất phát lớp vỏ màu nâu bên ngoài giống màu socola.Giống cà chua này sinh trưởng và phát triển tốt trong điều kiện khí hậu mát mẻ. Quả mọc theo chùm rất đẹp mắt.',89000,'https://product.hstatic.net/200000240163/product/cachuassocola2_b0a149cf0e8e415bba8a3f09c3b2255d_master.jpg',0,3),
(7,'Cà chua bi vàng','Cà chua bi vàng là loại quả có màu vàng cam, nhỏ và da trơn bóng, bên trong quả có những hạt nhỏ mọng nước. Vị chua, ngọt khá ngon so với cà chua thông thường.',70000,'https://product.hstatic.net/200000240163/product/b-cachuabivang_8a41f52a0ffd4acfae3ef98a6e66aa64_master.jpg',0,3),
(8,'Cà rốt cọng tím hữu cơ','Cà rốt cọng tím có tên khoa học chung là Daucus carota. Đây là phiên bản đặc biệt, được phối giống từ Trung tâm Cải tiến Rau và Quả A&M AgriLife (Bang Texas, Hoa Kỳ).Ở Đà Lạt, cà rốt cuống tím được trồng hữu cơ, đảm bảo giữ được chất lượng và an toàn cho sức khỏe người tiêu dùng.',89000,'https://product.hstatic.net/200000240163/product/ca_rot_cong_tim_66d0e35aea50418985745406d20c64c1_master.jpg',321,2),
(9,'Cà rốt mini','Cà rốt mini (hay còn gọi là cà rốt baby, cà rốt tí hon) có tên khoa học là Daucus carota, chúng còn một cái tên khác là Carrot Baby Pak. Đây là loại cà rốt dại, có kích thước nhỏ hơn gấp 3 lần so với cà rốt thông thường.Cây có nguồn gốc xuất xứ từ châu Âu và được ưa chuộng ở Việt Nam trong những năm trở lại đây. Những vùng có khí hậu mát lạnh như Đà Lạt là nơi thích hợp để trồng loại củ này.Cà rốt mini được trồng ở các trang trại theo tiêu chuẩn VietGAP, đảm bảo an toàn và đầy đủ chất dinh dưỡng cho người tiêu dùng.',129000,'https://product.hstatic.net/200000240163/product/carotbaby_d5548354ce4444a785a9b85926e5a703_master.jpg',443,2),
(10,'Cải bó xôi hữu cơ','Cải bó xôi hữu cơ chứa nhiều nước, giàu vitamin A, B, C, Kali, chất xơ, khoáng chất, ít calo và hầu như không có chất béo, hợp để ăn kiêng. Bên cạnh đó, hàm lượng sắt khá cao có trong cải bó xôi hữu cơ sẽ giúp ích rất nhiều cho bệnh thiếu máu.',108000,'https://product.hstatic.net/200000240163/product/bo_xoi_huu_co_e2d3e5b65de54573afc90c0484bb4611_master.jpg',125,1),
(11,'Cải cầu vồng','Công dụng Phòng chống ung thư,Giảm cân,Ngăn ngừa táo bón,Tốt cho quá trình đông máu',105000,'https://product.hstatic.net/200000240163/product/caicauvong_3766c6e05d034ebb9ffe26fcc9c6f417_master.png',50,1),
(12,'Cải Kale','Công dụng của cải Kale: Thải độc, căn cường thị giác, hỗ trợ giảm cân, tăng cường miễn dịch, giúp thai ngi khỏe mạnh, làm đẹp ra, tóc óng ả bóng khỏe, ngăn ngữa lão hóa, phòng chống ung thư,  bảo vệ tim mạch',95000,'https://product.hstatic.net/200000240163/product/caikheoorganic_786f325d427d4137acf2d68174c2088e_master.jpg',100,1),
(13,'Cần tây','Công dụng: ngừa bệnh ung thư, Giúp kháng viêm hiệu quả,Giải quyết các vấn đề tiêu hóa, lợi tiểu, Giảm cân, làm đẹp da,Tạo giấc ngủ sâu và ngon,Phòng ngừa cao huyết áp',109000,'https://bizweb.dktcdn.net/thumb/grande/100/390/808/products/165707b495b7c2d.jpg?v=1591870722910',0,1),
(14,'Củ cải đường hữu cơ','Công dụng: Giúp thanh lọc máu,Tốt cho hệ tim mạch, Ngăn chặn quá trình não lão hóa, Giúp kiểm soát bệnh tiểu đường',28700,'https://product.hstatic.net/200000240163/product/spnt_-_cu_cai_do_5fa85c3d441c4062ab88828fa3aaeff7_master.jpg',100,2),
(15,'Củ dền baby','Công dụng: Điều hòa huyết áp, Chữa chứng thiếu máu,Giảm cân,Ngăn ngừa tĩnh mạch, Chữa táo bón,Phòng chống xơ vữa động mạch, Ổn định tinh thần, Tăng cường hệ miễn dịch, Cải thiện tình trạng loét dạ dày, Ngăn ngừa ung thư',68000,'https://product.hstatic.net/200000240163/product/a-cuden_37baa35d05f24eba81382848c67da72d_master.jpg',65,2),
(16,'Củ hồi hữu cơ','Củ Hồi là loại thảo dược tốt cho sức khỏe đã được sử dụng làm vị thuốc từ rất lâu đời trong Trung y và y học Hindu truyền thống Ayurvedic có tác dụng hỗ trợ chữa nhiều bệnh khó tiêu, táo bón, lợi tiểu, giúp lợi sữa và điều hòa kinh nguyệt, ... Đặc biệt củ hồi còn giúp giải độc gan do uống nhiều rượu bia.',95000,'https://product.hstatic.net/200000240163/product/b894945a8053750d2c42_7e3d9361321642de84391e1faeb581cd_master.jpg',40,2),
(17,'Đậu cove','Đậu cove cũng mang đến nhiều lợi ích cho sức khỏe:Tăng cường sức khỏe tim mạch,Hỗ trợ tiêu hóa, Ngăn ngừa ung thư, Giúp xương chắc khỏe,Giúp xương chắc khỏe, Hỗ trợ giảm cân',69000,'https://product.hstatic.net/200000240163/product/daucove_958a1121359c43fa91013e6842404bd8_febc0a289da04b42be3f96bc593feecc_master.jpg',100,1),
(18,'Đậu Hà Lan','Đậu Hà Lan với lượng chất chống oxy hóa cao, các hợp chất như saponin, vitamin , chất xơ,... giúp hỗ trợ sức khỏe cho cơ thể. Đậu Hà Lan giúp ngăn ngừa ung thư, giảm lượng đường trong máu, tốt cho sức khỏe tim mạch, tốt cho mắt, tăng cường hệ miễn dịch,....',180000,'https://product.hstatic.net/200000240163/product/dauhalan_d1e15712ade14d07b29ff83a9e08104f_master.png',50,1),
(19,'Dền tía','Rau dền tía chứa nhiều vitamin C, B2, sắt, acid nicotic, hàm lượng canxi cao, cao gấp 3 lần trong cải bó xôi, hàm lượng chất xơ gấp 3 lần lúa mì,... giúp cho cơ thể hoạt động tốt các chức năng và ngăn ngừa được một số bệnh. Giúp xương khớp chắc khỏe, giảm viêm, tốt cho người tiểu đường, tốt cho tim mạch, cải thiện tiêu hóa, ngăn ngừa ung thư,...',65000,'https://product.hstatic.net/200000240163/product/dentia_702ddfb8256449698d47f5f0ddcd9c93_master.png',100,1),
(20,'Dền xanh','Rau dền xanh chứa nhiều vitamin C, B2, sắt, acid nicotic, hàm lượng canxi cao, cao gấp 3 lần trong cải bó xôi,... giúp cho cơ thể hoạt động tốt các chức năng và ngăn ngừa được một số bệnh. Giúp xương khớp chắc khỏe, giảm viêm, tốt cho người tiểu đường, tốt cho tim mạch, cải thiện tiêu hóa, ngăn ngừa ung thư,...',65000,'https://product.hstatic.net/200000240163/product/raudenxanh_4df418f46cee4370976896c735237339_master.jpg',120,1),
(21,'Đọt su su','Đọt su su là thực phẩm giàu folate, chất xơ, chất đồng, chất kẽm và vitamin B, giúp ngăn chặn sự hình thành của Homocystein, là chất có khả năng gây nên bệnh tim và đột quỵ. Vitamin C, K có trong su su giúp chống ô xy hóa, loãng xương. Ngoài ra, đọt su su còn tốt cho tim mạch, ngăn ngừa ung thư, làm đẹp da,...',60000,'https://product.hstatic.net/200000240163/product/dotsusu_7ac84379996d4f5cab937a35dcb3e4b8_master.png',330,1),
(22,'Hạt đậu hà lan','Đậu Hà Lan với lượng chất chống oxy hóa cao, các hợp chất như saponin, vitamin , chất xơ,... giúp hỗ trợ sức khỏe cho cơ thể. Đậu Hà Lan giúp ngăn ngừa ung thư, giảm lượng đường trong máu, tốt cho sức khỏe tim mạch, tốt cho mắt, tăng cường hệ miễn dịch,....',200000,'https://product.hstatic.net/200000240163/product/72b48b14e23a16644f2b_5c3d7779ccdd4e119910b3911ae7a104_1024x1024.jpg',0,5),
(23,'Khoai lang Nhật','Khoai lang Nhật mang đến nguồn dinh dưỡng lớn cho cơ thể, cung cấp lượng lớn tinh bột, chất xơ, các loại vitamin: A, C, B6, E,... các khoáng chất: kali, mangan,... giúp cơ thể giảm cân hiệu quả, làm mềm da, da giảm mụn, căng sáng, giảm cholesterol, giảm huyết áp, ngăn ngừa đột quỵ, hỗ trợ sức khỏe tim mạch,...',65000,'https://product.hstatic.net/200000240163/product/khoailangnhat_40271421acca429c8db108de9c1c6b7e_master.png',100,2),
(24,'Khoai tây','Khoai tây y giàu vitamin và khoáng chất, đặc biệt là vitamin C và kali. Lượng vitamin C dồi dào giúp tăng cường hệ miễn dịch, thúc đẩy quá trình tái tạo tế bào và tăng khả năng hấp thụ chất sắt. Trong khi đó, Kali tốt cho huyết áp và giảm nguy cơ đột quỵ. Ngoài ra, khoai tây còn hỗ trợ đẩy nhanh quá trình tiêu hóa, làm đẹp da, tốt cho tim mạch,...',62000,'https://product.hstatic.net/200000240163/product/a-khoaitay_509f054d5c4a4bad9c5a29622491a9d5_master.jpg',50,2),
(25,'Khoai tây baby hữu cơ','Trong khoai tây chứa đa số là nước, ngoài ra có các thành phần chủ yếu bao gồm: carb, protein và lượng chất xơ vừa đủ. Đặc biệt trong tất cả các loại khoai tây và khoai tây baby đều không có chất béo.',68000,'https://product.hstatic.net/200000240163/product/khoai_tay_mini_2e3a0975239441dc836626d8e3b2b223_master.jpg',50,2),
(26,'Măng tây hữu cơ','Công dụng:Tốt cho thai nhi,Làm đẹp da,Giúp giảm cân,Hỗ trợ vấn đề về tình dục,Tốt cho tim mạch,Tốt cho đường ruột',95000,'https://product.hstatic.net/200000240163/product/_san_pham_nen_trang__-_mang_tay_c116607bb24b4ce79abf154c1e4266a7_master.png',130,1),
(27,'Mồng tơi','Rau mồng tơi giàu chất xơ, chất nhầy, đặc biệt giàu vitamin A, canxi, và các chất chống oxy hóa như beta carotene, lutein và zeaxanthin… giúp cơ thể giảm cân, hỗ trợ tiêu hóa, nhuận trường tốt, làm da mịn màng, cải thiện thị lực, tốt cho xương khớp,...',58000,'https://product.hstatic.net/200000240163/product/mong_toi_fb10a6da277542a1aff6dadb870a4673_master.png',25,1),
(28,'Mồng tơi Hữu Cơ','Rau mồng tơi giàu chất xơ, chất nhầy, đặc biệt giàu vitamin A, canxi, và các chất chống oxy hóa như beta carotene, lutein và zeaxanthin… giúp cơ thể giảm cân, hỗ trợ tiêu hóa, nhuận trường tốt, làm da mịn màng, cải thiện thị lực, tốt cho xương khớp,...',58000,'https://product.hstatic.net/200000240163/product/tano2_da3b454701694479867e9fc0b0612f96_master.png',50,1),
(29,'Nấm đùi gà','Công dụng:Kiểm soát bệnh tiểu đường,Tốt cho hệ đường ruột,Ức chế sự phát triển của các khối u,Khả năng kháng khuẩn hiệu quả, Hỗ trợ điều trị loãng xương,Giảm Cholesterol trong máu',195000,'https://product.hstatic.net/200000240163/product/b-namduiga_38180895783e41b28d43cf526d922138_master.jpg',130,4),
(30,'Nấm hương','Công dụng: Tốt cho tim mạch,Kháng viêm,Ngăn ngừa ung thư,Chống oxy hóa,Giảm stress,Giúp cho da đẹp',195000,'https://product.hstatic.net/200000240163/product/namhuong_5ce67a2c85d04a6c99f4d2db3948626e_master.png',130,4),
(31,'Rau cải xanh',' Rất giàu chất dinh dưỡng, đặc biệt là vitamin K, A, và C.',70000 ,'https://cdn.tgdd.vn/Files/2022/06/03/1436833/cach-chon-cai-be-xanh-an-toan-tuoi-ngon-202206040725163215.jpg', 50,1),
(32,'Rau bina','Chứa nhiều sắt và canxi, là nguồn vitamin K và A tốt.',65000 ,'https://cdn.tgdd.vn/Files/2017/08/23/1015484/rau-bina-la-rau-gi-2_800x447.jpg',100 ,1),
(33,'Rau cải bó xôi','Cung cấp vitamin A, C, và K.',10000 ,'https://hatgiongdalat.com/asset/editor/ResponsiveFilemanager-master/source/bai-tin-tuc-trong-rau/hat-giong-rau-cai/hat-giong-rau-cai%20(4).jpg',100 ,1),
(34,'Rau bina Trung Quốc','Rất giàu vitamin C và K',70000 ,'https://cdn.tgdd.vn/2021/08/CookProduct/dau-do-52-1200x676.jpg',100 ,1),
(35,'Rau diếp','Chất dinh dưỡng cao, chủ yếu là vitamin A, C, và K.',60000 ,'https://hongngochospital.vn/wp-content/uploads/2013/11/rau-diep-ca-chua-8-loai-benh.jpg',130,1),
(36,'Củ hành','Chứa nhiều vitamin và khoáng chất, thường được sử dụng trong nấu ăn.',50000 ,'https://images2.thanhnien.vn/zoom/736_460/528068263637045248/2023/5/20/hanh-tim-16845872503721349076964-28-0-630-963-crop-1684587255911263843502.jpg',100 ,2),
(37,'Củ tỏi','Có tính chất chống vi khuẩn và chống ung thư.',90000 ,'https://topcargo.vn/wp-content/uploads/2022/10/toi-moc-mam-co-an-duoc-khong-1.jpg',0,2),
(38,'Củ nghệ','Có tác dụng chống vi khuẩn và chống viêm.',85000 ,'https://nghehoangminhchauhungyen.com/wp-content/uploads/2017/11/nghe-nep-do-1-nghehoangminhchauhungyen.com_.jpg',100 ,2),
(39,'Củ cải trắng','Cung cấp nhiều vitamin C và chất xơ.', 75000,'https://bazaarvietnam.vn/wp-content/uploads/2023/06/harper-bazaar-cu-cai-trang-ky-voi-gi-1-e1685860435941.jpg',100 ,2),
(40,'Quả táo','Chứa nhiều chất xơ và vitamin C.', 150000,'https://seotrends.com.vn/wp-content/uploads/2023/05/photo-1-1574415918938570279854-1024x574.webp',500 ,3),
(41,'Quả chuối','Là nguồn kali tốt và chứa nhiều chất xơ.',20000 ,'https://topcargo.vn/wp-content/uploads/2022/10/An-chuoi-nhieu-co-tot-khong-4.png',125 ,3),
(42,'Quả nho','Chứa nhiều chất chống ô nhiễm và resveratrol.',200000 ,'https://cayantraidetrong.com/wp-content/uploads/2021/05/goc-cay-nho-ninh-thuan-5.jpg',130 ,3),

(43,'Quả lựu','Cung cấp nhiều chất chống ô nhiễm và vitamin C.',150000 ,'https://c.pxhere.com/photos/b9/e2/photo-1613654.jpg!d', 150,3),
(44,'Quả ổi','Rất giàu vitamin C và chứa enzyme papain.',18000 ,'https://cdnphoto.dantri.com.vn/pL0OII2EUk-u5_LaWqKA--gWAYQ=/thumb_w/990/2021/07/07/8f81b63a0c2f6b5347a013e59f4621ce-1625664963034.jpg',180 ,3),
(45,'Quả mang cầu','Chứa nhiều vitamin A và C.',60000 ,'https://tramangcaucamthieu.vn/wp-content/uploads/2018/03/cach-mang-cau-voi-cong-dung-giam-can-hieu-qua-1-1.jpg',150,3),
(46,'Nấm mèo',' Nấm nhỏ, phổ biến và thường được sử dụng trong nhiều loại món.',200000 ,'https://i.pinimg.com/564x/72/84/d0/7284d09f32f6557f9de529d50a8c3214.jpg',150,4),
(47,'Nấm Maitake','Còn được gọi là "nấm rơm," thường được sử dụng trong y học dân dụ vì các tính chất chống ung thư.',350000 ,'https://thegioinam.files.wordpress.com/2012/09/maitake.jpg',10 ,4),
(48,'Nấm oyster','Có nhiều loại nấm oyster khác nhau được sử dụng, có hình dạng giống tai nước và hương vị đặc trưng.',150000 ,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCq7pGpBbel754qVTvig6ibXdabIXuPvhh_g&usqp=CAU',100 ,4),
(49,'Nấm hương','Nấm có mùi hương đặc trưng, thường được sử dụng để chế biến các món hương vị.',500000 ,'https://cdnphoto.dantri.com.vn/1ACjrmSDrFEvN1NlNnqINoFSvrg=/thumb_w/990/2021/08/19/bai-pr-so-6nam-1docx-1629387351241.jpeg',100 ,4),
(50,'Nấm rơm','Còn được biết đến là nấm chum, là một trong những loại nấm có hình dạng độc đáo và thơm ngon.',450000 ,'https://cdn.tgdd.vn/Files/2021/07/29/1371665/cac-loai-nam-an-duoc-va-nhung-tac-dung-than-ky-cua-nam-202107291856422662.jpg',150,4),
(51,'hạt sen','Sử dụng trong nấu chè và các món tráng miệng.',130000 ,'https://cdn.tgdd.vn/2021/03/content/hatsen(1)-800x480.jpeg',125 ,5),
(52,'Đậu phộng','Nguyên liệu chính để sản xuất dầu đậu phộng và được ăn như một loại gia vị.', 360000,'http://vinhphuctv.vn/upload/2014/PHOTOS/THANG3/01032014/SK1lacnhan-7fb9a.jpg',200,5),
(53,'Đậu đỏ','Sử dụng rộng rãi trong nấu chè và các món ngọt truyền thống.',99000 ,'https://cdn.tuoitre.vn/thumb_w/730/2017/hinh-1-1504689783852.jpg',155 ,5),
(54,'Đậu đen','Được sử dụng trong nấu canh, xào, và làm bánh.',155000 ,'https://www.thuocdantoc.org/wp-content/uploads/2021/02/tac-dung-cua-dau-den-xanh-long.jpg',25 ,5),
(55,'Đậu nành',' Nguyên liệu chính để sản xuất đậu hủ, nước đậu nành, và nhiều sản phẩm khác.',120000 ,'https://suckhoedoisong.qltns.mediacdn.vn/Images/duylinh/2018/11/25/1_VF445_HNMR.jpg',256 ,5);


INSERT INTO ProductImages (ProductImageID, ProductID, ImageURL) VALUES
(1,1,'https://product.hstatic.net/200000240163/product/0d8048e4e3_4bfd26a97b2142e6a59272580174ca7e_master.png'),
(2,1,'https://cdn-www.vinid.net/2020/05/bf78fb73-bap-cai-tim-1024x683.jpg'),
(3,1,'https://product.hstatic.net/200000240163/product/bapcaitim_eacc0f102c09406494c06d4e151fe824_master.png'),

(4,2,'https://product.hstatic.net/200000240163/product/bongcaibaby_f5a4a44605684db4a49bf9cd9780863b_master.jpg'),
(5,2,'https://bizweb.dktcdn.net/100/390/808/products/bong-cai-xanh-baby.jpg?v=1592644471407'),
(6,2,'https://product.hstatic.net/200000240163/product/bongcaibaby_1_278c19f8420d4cf1ba70d8ef3a0d9852_master.jpg'),
(7,2,'https://product.hstatic.net/200000240163/product/bongcaibaby_e5ab188499fb4ef590b3d38d7d64edc3_master.jpg'),

(8,3,'https://product.hstatic.net/200000240163/product/bongcaitrang_1419fe6f195d461a8df8c3deb071f77d_master.png'),
(9,3,'https://cdn.youmed.vn/tin-tuc/wp-content/uploads/2021/05/bong-cai-trang-1-e1622340437826.jpeg'),
(10,3,'https://product.hstatic.net/200000240163/product/bongcaitrang_9e15a0d34f6c4da29f4b0178cdc21f16_master.jpg'),

(11,4,'https://product.hstatic.net/200000240163/product/suploxanh_e0ecdc2b57994d548490c6bbc80fea5f_master.jpg'),
(12,4,'https://bizweb.dktcdn.net/thumb/grande/100/390/808/products/sup-lo.png?v=1592640869563'),
(13,4,'https://product.hstatic.net/200000240163/product/bongcaixanh_28b319355a694268bd17bfd7959a1097_master.jpg'),

(14,5,'https://product.hstatic.net/200000240163/product/cachuabeef_3d01b72995f1421c9b203049c5811f81_master.jpg'),
(15,5,'https://product.hstatic.net/200000459373/product/ca-chua-beef-hop-500g-202101071041037134_c05a68b6faf246c48e9ce89a2d4edc5a.jpg'),
(16,5,'https://product.hstatic.net/200000240163/product/cachuabeef2_77b65bd9ece54483b375e3a3abaa88c9_master.jpg'),
(17,5,'https://product.hstatic.net/200000240163/product/cachuabeef3_6012d5f12f4645198fe1c071281995bc_master.png'),
(18,5,'https://product.hstatic.net/200000240163/product/cachuabeef_94afddf63faf49cda3d1e77e491a4a0f_master.png'),

(19,6,'https://product.hstatic.net/200000240163/product/cachuassocola2_b0a149cf0e8e415bba8a3f09c3b2255d_master.jpg'),
(20,6,'https://www.specialtyproduce.com/produce/sppics/4363.png'),
(21,6,'https://product.hstatic.net/200000240163/product/cachuasocola2_768d0c31af314c07a1d162cdb3afe4ea_master.jpg'),
(22,6,'https://product.hstatic.net/200000240163/product/cachuasocola_da27cabf53554ed3a96632082457bac4_master.png'),

(23,7,'https://product.hstatic.net/200000240163/product/b-cachuabivang_8a41f52a0ffd4acfae3ef98a6e66aa64_master.jpg'),
(24,7,'https://hatgiongphuongnam.com/asset/upload/image/hat-giong-ca-chua-bi-vang-lun.jpg?v=20190410'),
(25,7,'https://product.hstatic.net/200000240163/product/cachuavang_dac7a3220abf4a6999d95048452b80d6_master.png'),

(26,8,'https://product.hstatic.net/200000423303/product/ca-rot-huu-co_051657cb99144443bac8015f6dd34dae.jpg'),
(27,8,'https://icdn.dantri.com.vn/thumb_w/770/2022/06/13/carot1-1655080697519.jpeg'),

(28,9,'https://e.khoahoc.tv/photos/image/2016/05/06/ca-rot-1.jpg'),
(29,9,'https://noitronhanh.com/wp-content/uploads/2021/04/unnamed-1.jpg?v=1619280191'),

(30,10,'https://anhoafood.com/wp-content/uploads/2018/08/caiboxoi-huuco-dalat-2-600x600.jpg'),
(31,10,'https://product.hstatic.net/200000423303/product/cai-bo-xoi-huu-co_dcef0c0e1fc1491599583cc06a19b830_1024x1024.jpg'),

(32,11,'https://dalatfarm.net/wp-content/uploads/2021/06/cai-cau-vong.jpg'),
(33,11,'https://anhoafood.com/wp-content/uploads/2018/08/rau-cai-cauvong-huuco-dalat-anhoafood-1.jpg'),

(34,12,'https://nongsandalat.vn/wp-content/uploads/2021/10/curlykale-compressed.jpg'),
(35,12,'https://img.meta.com.vn/Data/image/2020/05/09/cai-kale-la-cai-gi-3.jpg'),

(36,13,'https://www.shutterstock.com/image-photo/bunch-fresh-celery-stalk-leaves-600nw-601032998.jpg'),
(37,13,'https://www.thuocdantoc.org/wp-content/uploads/2019/07/cay-can-tay1.jpg'),

(38,14,'https://png.pngtree.com/thumb_back/fw800/background/20220705/pngtree-organic-beetroot-gardening-growth-domestic-garden-photo-image_1118959.jpg'),
(39,14,'https://image-us.eva.vn/upload/1-2020/images/2020-02-08/tac-dung-va-tac-hai-cua-cu-cai-do-khi-an-can-luu-y-ccd1-1581179474-145-width800height533.jpg'),

(40,15,'https://vietmaximart.com/wp-content/uploads/2021/08/baby_beetroot_38e479970df648978dbb8b28dceabb85_large.jpg'),
(41,15,'https://bizweb.dktcdn.net/100/390/808/products/cu-den-do-baby-large.jpg?v=1593855273587'),

(42,16,'https://admin.nongsandungha.com/uploads/uploads/2018/10/ban-cu-hoi-da-lat.jpg'),
(43,16,'https://admin.nongsandungha.com/img/C%E1%BB%A6%20H%E1%BB%92I/fennel__preludio__070813__6__master-min.jpg'),

(44,17,'https://cdn.tgdd.vn/Files/2021/11/30/1401515/cach-trong-dau-que-trong-chau-nang-suat-cao-it-sau-benh-202111301957004233.jpg'),
(45,17,'https://down-vn.img.susercontent.com/file/0782af8046b5570aeaba3862dbb81d16'),

(46,18,'https://dalatfarm.net/wp-content/uploads/2021/06/hat-dau-ha-lan.jpg'),
(47,18,'https://hatgiongphuongnam.com/asset/upload/image/hat-giong-dau-ha-lan-xanh.jpg?v=20190410'),

(48,19,'https://vfa.gov.vn/data/2017/rau%20den.jpg'),
(49,19,'https://hatgiongdalat.com/asset/upload/image/hat-giong-rau-den_(3).jpg?v=20190410'),

(50,20,'https://product.hstatic.net/200000240163/product/raudenxanh2_9a39f9f11fcd44069c389b648f03e5e3_master.jpg'),
(51,20,'https://product.hstatic.net/200000240163/product/denxanh_370afc0f043a4f1facc76e63aedacd3c_master.png'),

(52,21,'https://product.hstatic.net/200000240163/product/dotsusu2_fc5f795914a247279b2a5d608084cc99_master.jpg'),
(53,21,'https://product.hstatic.net/200000240163/product/dotsusu2_f25eaddd04fc42d4b2a4687134acd0bf_master.jpg'),

(54,22,'https://goce.vn/files/common/hat-dau-ha-lan-co-tac-dung-gi-an-dau-ha-lan-co-beo-khong-qlnl9.png'),
(55,22,'https://originvn.com/wp-content/uploads/2022/05/DAU-PEA.png'),

(56,23,'https://product.hstatic.net/200000240163/product/khoainhat_a8c5b835d9ff40ada638e8a2418b1c75_master.png'),

(57,24,'https://product.hstatic.net/200000240163/product/khoaitay_2ed3c4e4754e4cb1a756bf44502bde32_master.png'),

(58,25,'https://media.istockphoto.com/id/610765164/vi/anh/khoai-t%C3%A2y-m%E1%BB%9Bi.jpg?s=612x612&w=0&k=20&c=mPmD29ThDgtrOAjXI4FYwVunp8bWRmRvPPpHtmGBGag='),
(59,26,'https://cdn.tgdd.vn/2020/08/CookProduct/16-tac-dung-tuyet-voi-cua-mang-tay-va-tac-dung-phu-co-the-ban-chua-biet-1-1200x676.jpg'),

(60,27,'https://tancang-catering.com.vn/wp-content/uploads/2020/09/39fSD0027MALABARSPINACHSEEDSFreshLiveVegetableSeeds90Germination550Seedslotfreeshipping.jpg'),

(61,28,'https://product.hstatic.net/200000240163/product/tano_87127f6fc4324e10a5f7fd2fdf0bab24_master.png'),
(62,28,'https://product.hstatic.net/200000240163/product/mongtoi_b984c89783c946ff987a4c24d961cabb_master.png'),
(63,28,'https://bizweb.dktcdn.net/thumb/1024x1024/100/390/808/products/1-101-a84348debba24fcd95719a117b6ff32d-master.jpg?v=1592900299463'),

(64,29,'https://product.hstatic.net/200000240163/product/namduiga_63a319ca770b4e66b9b73fa8ef7f1f8f_master.jpg'),
(65,30,'https://product.hstatic.net/200000240163/product/namhuong_71a39319dd274a8bba6ab787f9b8912f_master.jpg'),

(66,31,'https://img.dantocmiennui.vn/t620/uploaddtmn//2017/6/19/17c7253a5639582e41ea8f9be4d6dd5b-1.jpg'),
(67,32,'https://cdn.tgdd.vn/2021/08/CookProductThumb/dau-do-53-620x620.jpg'),

(68,33,'https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2021/10/8/image-500x500-16336805084271469691744.jpg'),
(69,34,'https://cdn.tgdd.vn/Files/2017/08/23/1015484/rau-bina-la-gi-cong-dung-va-5-cach-che-bien-rau-bina-202112141115593124.jpg'),

(70,35,'https://www.thuocdantoc.org/wp-content/uploads/2019/10/tac-dung-rau-diep.jpg'),
(71,36,'https://www.huongnghiepaau.com/wp-content/uploads/2020/10/hanh-tay.jpg'),

(72,37,'https://cokhidongnam.vn/wp-content/uploads/2022/02/hinh-anh-cu-toi.jpg'),
(73,38,'https://myphamthuanchay.com/images/news/tin-tuc-hinh-anh-ve-cay-nghe-va-cu-nghe.jpg'),

(74,39,'https://media.istockphoto.com/id/158690297/vi/anh/c%E1%BB%A7-c%E1%BA%A3i-daikon-%C4%91%C6%B0%E1%BB%A3c-ph%C3%A2n-l%E1%BA%ADp-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng.jpg?s=612x612&w=0&k=20&c=25DzGCUtSFFEEZBPxq26JnFm4pgIC9Mb9_YZ3nJjFHY='),
(75,40,'https://daknong.1cdn.vn/thumbs/720x480/2023/09/29/469-202309291412364.png');


INSERT INTO StatusOrders (StatusOrderID, Name) VALUES
(1,'Chờ xác nhận'),
(2,'Đang giao'),
(3,'Giao hàng thành công'),
(4,'Đã hủy');

INSERT INTO StatusBookings (StatusBookingID, Name) VALUES
(1,'Chờ xác nhận'),
(2,'Đặt tour thành công'),
(3,'Tour bị hủy'),
(4,'Khách hàng cancel'),
(5,'Vé đã được sử dụng');


INSERT INTO PaymentMethods (PaymentMethodID, MethodName, Description) VALUES
(1,'Tiền mặt',''),
(2,'VNPAY',''),
(3,'Paypal','');


INSERT INTO Orders (OrderID, UserID, OrderDate, StatusOrderID,PaymentMethodID,AddressID) VALUES
(1,1,'2023-03-12',3,3,1),
(2,1,'2022-09-15',3,3,1),
(3,1,'2023-09-19',3,3,12),
(4,2,'2023-07-18',1,1,13),
(5,2,'2020-11-03',1,1,2),
(6,2,'2023-11-07',2,3,2),
(7,2,'2023-09-18',3,3,2),
(8,3,'2023-10-18',2,3,3),
(9,3,'2023-09-15',3,3,3),
(10,4,'2023-09-18',4,3,4),
(11,4,'2020-08-27',3,1,4),
(12,4,'2021-04-17',3,3,4),
(13,5,'2022-05-29',4,3,5),
(14,5,'2023-10-05',1,1,5),
(15,5,'2023-04-11',3,3,5),
(16,6,'2022-10-24',3,3,6),
(17,6,'2023-09-15',4,1,6),
(18,6,'2023-09-19',3,3,6),
(19,7,'2023-01-28',3,3,7),
(20,7,'2022-06-06',4,3,7),
(21,8,'2023-09-20',3,1,8),
(22,8,'2023-10-30',1,1,8),
(23,9,'2023-09-17',3,3,9),
(24,9,'2021-08-27',3,1,9),
(25,9,'2023-10-12',1,1,9),
(26,10,'2023-10-28',1,1,10),
(27,10,'2023-04-22',3,3,10),
(28,10,'2023-11-16',3,3,10),
(29,10,'2023-11-17',3,3,10),
(30,10,'2023-11-18',3,3,10),
(31,10,'2023-11-19',3,3,10),
(32,10,'2023-11-20',3,3,10),
(33,10,'2023-11-21',3,3,10),
(34,10,'2023-11-22',3,3,10),
(35,10,'2023-11-23',3,3,10),
(36,4,'2023-12-13',1,1,10),
(37,4,'2023-12-14',3,2,10),
(38,4,'2023-12-15',1,1,10),
(39,2,'2023-12-16',3,2,10),
(40,4,'2023-12-17',4,3,10),
(41,2,'2023-12-18',1,1,10),
(42,3,'2023-12-19',3,2,10),
(43,12,'2019-08-09',3,1,23),
(44,13,'2019-07-09',3,2,24),
(45,14,'2019-06-18',3,3,14),
(46,15,'2019-10-20',3,1,15),
(47,16,'2019-05-18',4,1,16),
(48,17,'2019-10-15',4,2,17),
(49,18,'2019-10-02',3,2,18),
(50,19,'2019-04-19',3,3,19),
(51,20,'2019-03-20',3,2,20),
(52,21,'2019-02-10',4,3,21),
(53,22,'2019-08-01',4,2,22),
(54,13,'2019-06-02',3,1,24),
(55,15,'2019-08-20',3,2,15),
(56,16,'2019-02-16',4,2,16),
(57,17,'2019-11-10',3,3,17),


(58,17,'2020-02-02',3,1,17),
(59,18,'2020-10-15',4,2,18),
(60,19,'2020-09-18',4,2,19),
(61,20,'2020-10-15',4,3,20),
(62,21,'2020-09-09',4,3,21),
(63,22,'2020-08-02',3,3,22),
(64,16,'2020-06-01',3,2,16),
(65,15,'2020-05-05',3,3,15),
(66,14,'2020-09-01',3,2,14),
(67,12,'2020-10-09',4,1,23),
(68,13,'2020-09-09',4,2,24),
(69,17,'2020-10-10',4,2,17),
(70,18,'2020-12-12',4,3,18),
(71,19,'2020-12-12',3,3,19),
(72,20,'2020-10-10',3,1,20),


(73,9,'2021-08-08',3,1,9),
(74,10,'2021-09-20',4,2,10),
(75,11,'2021-10-12',3,2,11),
(76,12,'2021-11-20',3,3,23),
(77,13,'2021-07-20',3,3,24),
(78,14,'2021-07-08',3,3,14),
(79,15,'2021-06-02',3,1,15),
(80,16,'2021-06-06',3,1,16),
(81,17,'2021-05-03',3,1,17),
(82,18,'2021-04-20',3,1,18),
(83,19,'2021-09-12',4,1,19),
(84,20,'2021-06-18',3,2,20),
(85,21,'2021-09-08',3,3,21),
(86,22,'2021-10-20',3,3,22),
(87,10,'2021-05-15',4,1,10),


(88,22,'2022-10-03',1,1,22),
(89,21,'2022-09-08',2,2,21),
(90,20,'2022-10-08',3,3,20),
(91,19,'2022-04-20',4,1,19),
(92,18,'2022-05-25',1,2,18),
(93,17,'2022-09-04',1,3,17),
(94,16,'2022-07-05',2,1,16),
(95,15,'2022-01-21',3,2,15),
(96,14,'2022-10-20',4,3,14),
(97,9,'2022-09-01',1,1,9),
(98,10,'2022-06-10',2,3,10),
(99,11,'2022-10-25',1,2,11),
(100,12,'2022-10-30',2,3,23),
(101,13,'2022-10-20',2,1,24),
(102,14,'2022-10-05',1,3,14),

(103,20,'2023-01-05',3,2,20),
(104,21,'2023-02-03',4,1,21),
(105,9,'2023-08-10',3,2,9),
(106,19,'2023-05-01',3,1,19),
(107,18,'2023-06-01',3,1,18),
(108,17,'2023-07-08',3,2,17),
(109,16,'2023-01-01',3,2,16),
(110,15,'2023-09-08',3,3,15),
(111,10,'2023-08-15',3,3,10),
(112,11,'2023-08-15',3,1,11),
(113,14,'2023-06-01',3,2,14),
(114,15,'2023-10-10',4,3,15),
(115,16,'2023-10-10',3,1,16),
(116,18,'2023-10-10',4,2,18),
(117,19,'2023-10-09',3,3,19),
(118,10,'2023-12-20',1,3,10),
(119,5,'2023-12-21',3,3,10),
(120,6,'2023-12-22',4,1,10),
(121,7,'2023-12-23',3,2,10);




INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, QuantityOrdered, TotalPrice)VALUES

(1,1,2,20,2580000),
(2,1,5,10,690000),
(3,1,1,10,940000),

(4,2,2,25,3225000),
(5,2,15,10,680000),
(6,2,11,10,1050000),
(7,2,29,15,2925000),


(8,3,3,15,1500000),
(9,3,7,5,350000),
(10,3,10,10,1080000),
(11,3,28,20,1160000),
(12,3,15,10,680000),

(13,4,2,25,3225000),
(14,4,13,20,2180000),
(15,4,6,15,1335000),


(16,5,8,20,1780000),
(17,5,1,25,2350000),
(18,5,19,30,1950000),
(19,5,12,10,950000),
(20,5,30,15,2925000),

(21,6,12,20,1900000),
(22,6,4,17,1785000),
(23,6,17,30,2070000),


(24,7,18,25,4500000),
(25,7,11,15,1050000),
(26,7,22,10,2000000),
(27,7,5,10,690000),

(28,8,21,20,1200000),
(29,8,10,15,1620000),
(30,8,8,20,1780000),
(31,8,14,15,430500),

(32,9,14,10,287000),
(33,9,9,20,2580000),
(34,9,3,25,2500000),

(35,10,20,15,975000),
(36,10,15,30,2040000),
(37,10,24,15,930000),
(38,10,27,10,580000),
(39,10,28,20,1160000),


(40,11,27,15,870000),
(41,11,10,20,2160000),
(42,11,21,23,1380000),

(43,12,28,25,1450000),
(44,12,26,20,1900000),
(45,12,19,15,975000),
(46,12,17,25,1725000),


(47,13,7,30,2100000),
(48,13,12,20,1900000),
(49,13,14,20,574000),
(50,13,25,15,1020000),


(51,14,24,30,1860000),
(52,14,18,20,3600000),
(53,14,27,15,870000),
(54,15,21,10,600000),
(55,15,4,15,1575000),
(56,15,11,25,2625000),
(57,15,13,15,1635000),

(58,16,27,10,580000),
(59,16,7,10,700000),
(60,16,15,12,816000),
(61,16,12,20,1900000),
(62,16,4,10,1050000),


(63,17,20,10,650000),
(64,17,6,15,1335000),
(65,17,16,10,950000),

(66,18,17,10,690000),
(67,18,7,20,1400000),
(68,18,13,10,1090000),
(69,18,15,15,1020000),

(70,19,16,10,950000),
(71,19,18,10,1800000),
(72,19,30,10,1950000),
(73,19,5,10,690000),

(74,20,13,10,1090000),
(75,20,11,15,1575000),
(76,20,12,15,1425000),


(77,21,6,15,1335000),
(78,21,7,25,1750000),
(79,21,8,10,890000),
(80,21,9,10,1290000),

(81,22,11,20,210000),
(82,22,21,25,1500000),

(83,23,14,10,28700),
(84,23,24,15,930000),
(85,23,22,20,4000000),

(86,24,22,10,2000000),
(87,24,12,15,1425000),
(88,24,27,25,1450000),

(89,25,23,10,650000),
(90,25,13,30,3270000),
(91,25,17,25,1725000),
(92,25,18,10,1800000),

(93,26,25,15,1020000),
(94,26,15,15,1020000),
(95,26,28,20,1160000),

(96,27,26,24,2280000),
(97,27,25,20,1360000),
(98,27,8,10,890000),

(99,28,21,15,900000),
(100,28,11,15,1575000),
(101,28,5,10,690000),
(102,28,6,20,1780000),

(103,29,6,20,1780000),
(104,30,6,20,1780000),
(105,31,6,20,1780000),
(106,32,6,20,1780000),
(107,33,6,20,1780000),
(108,34,6,20,1780000),
(109,35,6,20,1780000),
(110,36,1,23,2162000),
(111,37,2,21,2709000),
(112,38,3,20,2000000),
(113,39,4,11,1155000),
(114,40,5,7,483000),
(115,41,6,33,2937000),
(116,42,3,20,2000000),
(117,43,31,2,140000),
(118,43,32,1,65000),
(119,43,33,2,20000),

(120,44,31,2,140000),
(121,44,37,1,90000),


(122,45,51,1,130000),
(123,45,43,2,300000),
(124,45,37,1,90000),

(125,46,40,2,300000),
(126,46,35,1,60000),
(127,46,36,2,100000),



(128,47,43,1,150000),
(129,47,44,2,36000),
(130,47,45,1,60000),

(131,48,38,1,85000),
(132,48,39,10,750000),
(133,48,31,1,70000),

(134,49,33,2,20000),

(135,50,39,10,750000),
(136,50,43,1,150000),

(137,51,33,1,10000),
(138,51,39,10,750000),


(139,52,49,10,5000000),

(140,53,50,1,450000),

(141,54,55,1,120000),

(142,55,53,5,495000),
(143,55,43,1,150000),

(144,56,44,2,36000),
(145,56,43,2,300000),

(146,57,36,1,50000),


(147,58,46,2,400000),
(148,58,48,1,150000),

(149,59,54,10,1550000),
(150,59,46,1,200000),


(151,60,38,1,85000),

(152,61,39,2,150000),

(153,62,32,10,650000),

(154,63,34,5,350000),

(155,64,51,1,130000),
(156,64,53,1,99000),

(157,65,53,1,99000),
(158,65,32,10,650000),

(159,66,37,2,180000),
(160,66,36,3,100000),
(161,66,38,1,85000),



(162,67,38,1,85000),
(163,67,54,10,1550000),

(164,68,51,1,130000),
(165,68,53,1,99000),
(166,68,32,10,650000),


(167,69,38,10,850000),

(168,70,40,1,150000),
(169,71,41,2,40000),
(170,72,43,5,750000),
(171,73,44,1,18000),


(172,74,53,1,99000),

(173,75,32,10,650000),

(174,76,40,1,150000),
(175,76,43,5,750000),
(176,76,32,10,650000),
(177,77,51,1,130000),
(178,77,41,2,40000),

(179,78,51,1,130000),
(180,78,41,2,40000),
(181,78,32,10,650000),

(182,79,38,1,85000),
(183,79,54,10,1550000),

(184,80,37,2,180000),
(185,80,38,1,85000),

(186,81,40,1,150000),

(187,82,44,1,18000),
(188,82,45,2,120000),

(189,83,45,1,60000),
(190,83,38,1,85000),

(191,84,46,2,400000),

(192,85,50,1,450000),

(193,86,51,1,130000),

(194,87,52,2,260000),

(195,88,52,1,360000),

(196,89,53,10,990000),
(197,89,55,2,240000),

(198,90,45,1,60000),

(199,91,40,1,150000),
(200,91,53,10,990000),
(201,92,55,2,240000),

(202,93,51,1,130000),
(203,93,50,1,450000),

(204,94,36,1,50000),
(205,94,38,1,85000),
(206,94,39,1,75000),


(207,95,55,2,240000),
(208,95,39,1,75000),

(209,96,51,1,130000),
(210,96,38,1,85000),
(211,96,36,1,50000),

(212,97,44,1,18000),
(213,97,46,1,200000),
(214,97,47,1,350000),

(215,98,49,1,500000),
(216,98,50,1,450000),



(217,99,51,10,1300000),
(218,99,52,1,360000),

(219,100,44,1,18000),

(220,101,51,10,1300000),
(221,102,47,1,350000),

(222,103,52,1,360000),
(223,103,44,1,18000),

(224,104,32,10,650000),

(225,105,32,1,65000),
(226,105,33,5,50000),

(227,106,37,1,90000),
(228,106,36,1,50000),

(229,107,33,5,50000),

(230,108,31,10,700000),
(231,108,32,1,65000),

(232,109,34,1,70000),
(233,109,35,1,60000),

(234,110,36,10,500000),

(235,111,38,10,850000),
(236,112,39,1,75000),

(237,113,41,1,20000),
(238,113,42,10,2000000),

(239,114,45,10,600000),
(240,115,41,10,200000),

(241,116,51,10,1300000),

(242,117,52,1,360000),
(243,117,44,1,18000),

(244,43,4,11,1155000),
(245,44,5,7,483000),
(246,45,6,33,2937000),
(247,46,7,21,1470000);


INSERT INTO Tours (TourID, TourName, Description, Image,Departureday, Location) VALUES
(1,'Ngày Hội Nghệ Thuật','Activities : Tự do sáng tạo sản phẩm nghệ thuật mang đậm dấu ấn cá nhân Nuôi dưỡng cảm xúc qua từng sản phẩm
Ứng dụng nghệ thuật trong đời sống hàng ngày 
Gói Workshop độc quyền khai thác của HAT và GreenFarm Farm Camping','https://static.wixstatic.com/media/7406f4_cfa7a17cf87e48a7a9ba1b48bef15bf7~mv2.jpg/v1/crop/x_22,y_0,w_911,h_1276/fill/w_300,h_420,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/z3018338501187_4e0d10966df9e1cb7d351c6fc1fa3c34.jpg','Chủ nhật hàng tuần','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),
(2,'Hãy Là Một Nông Dân Hạnh Phúc','Activities :Hãy thử các sản phẩm hữu cơ. Lái xe tải.Tham gia các hoạt động nông nghiệp thực tế với mô hình hữu cơ công nghệ cao (Hoạt động cụ thể được cập nhật theo lịch tại trang trại).
Tham gia Chợ sinh thái Green Farm theo mùa thu hoạch.“Cho và Nhận” – Nuôi dưỡng hoặc trồng cây con như lời cảm ơn đến các kỹ sư và nông dân đã chăm sóc trang trại.
Tham quan chuồng nuôi gia súc (thỏ, dê) theo hình thức bán chăn thả.
Tham gia các workshop thú vị (sơn gỗ, trang trí túi xách, vẽ mũ, v.v.).
Lớp học nấu ăn với các sản phẩm hữu cơ (thạch/,...).','https://static.wixstatic.com/media/7406f4_67826ef1b2ce493e97c6e2ac4b6e96ca~mv2.jpg/v1/crop/x_86,y_0,w_2851,h_4032/fill/w_300,h_420,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/20200208_082648.jpg','Thứ bảy hàng tuần','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),
(3,'Cuộc Phiêu Lưu Hạt Giống','Bài học cho trẻ khi đến với Green Farm Camping Hiểu được đối với nông sản hữu cơ thì cần chăm sóc như thế nào?Hiểu được để có được nông sản sạch thì người nông dân sẽ bỏ công bao nhiêu?.','https://static.wixstatic.com/media/7406f4_ee369c693de747b2b2219e2d1c377ab9~mv2.jpg/v1/crop/x_120,y_0,w_2124,h_3000/fill/w_300,h_420,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/IMG20210115111312.jpg','Ngày 14 hàng tháng','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),
(4,'Thăm Trang Trại Xanh','Nông trại Green Farm là nông trại trồng rau hữu cơ kết hợp các khóa học trồng cây dành cho mọi 
lứa tuổi tọa lạc tại 130 Nguyễn Văn Hưởng, Thảo Điền, TP. Thủ Đức, TPHCM. Đây là địa chỉ du lịch sinh thái được rất nhiều người biết đến 
và là một trong những nơi tham quan dành cho lứa tuổi mầm non.Green Farm do nhóm bạn trẻ xây dựng với mong muốn mọi người có thể tiếp cận và tham 
quan xem quy trình trồng rau sạch.','https://tinviettravel.com.vn/uploads/tours/2019_11/tham-quan-nong-trai-vui-ve.jpg','Chủ nhật hàng tuần','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),
(5,'Mầm Non Làm Nông Dân','Nông trại Green Farm là nông trại trồng rau hữu cơ kết hợp các khóa học trồng cây dành cho mọi 
lứa tuổi tọa lạc tại 130 Nguyễn Văn Hưởng, Thảo Điền, TP. Thủ Đức, TPHCM. Đây là địa chỉ du lịch sinh thái được rất nhiều người biết đến 
và là một trong những nơi tham quan dành cho lứa tuổi mầm non.Green Farm do nhóm bạn trẻ xây dựng với mong muốn mọi người có thể tiếp cận và tham 
quan xem quy trình trồng rau sạch.','https://tinviettravel.com.vn/uploads/tours/2023_05/world-farm-hoc-sinh.jpg','Thứ bảy hàng tuần','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),
(6,'Trải Nghiệm Làm Nông Dân','Nông trại Green Farm là nông trại trồng rau hữu cơ kết hợp các khóa học trồng cây dành cho mọi 
lứa tuổi tọa lạc tại 130 Nguyễn Văn Hưởng, Thảo Điền, TP. Thủ Đức, TPHCM. Đây là địa chỉ du lịch sinh thái được rất nhiều người biết đến 
và là một trong những nơi tham quan dành cho lứa tuổi mầm non.Green Farm do nhóm bạn trẻ xây dựng với mong muốn mọi người có thể tiếp cận và tham 
quan xem quy trình trồng rau sạch.','https://tinviettravel.com.vn/assets/tours/2023_05/world-farm-trai-nghiem-lam-nong-dan.jpg','Ngày 15 hàng tháng','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),
(7,'Tham Quan Vườn Rau Xanh','Tour du lịch tham quan Vườn Rau sẽ đưa các bé đến với khu vườn rau xanh ngát tọa lạc tại nhà thiếu nhi quận 12. Đến với chương trình học tập ngoại khóa này các bé sẽ được học hỏi quan sát các kĩ năng và công đoạn để tạo ra một khu vườn rau mơ ước và thực hành công đoạn thu hoạch rau vui nhộn. Thông qua những hoạt động này sẽ giúp các em yêu mến thiên nhiên, biết bảo vệ môi trường và nhất là trân quý những sản phẩm nông nghiệp do những người nông dân tạo ra.','https://tinviettravel.com/uploads/tours/images/tour_mam_non/tour_khac/du-lich-tham-quan-vuon-rau.jpg','Ngày 20 hàng tháng','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),
(8,'Khu Nghỉ Dưỡng Sinh Thái Xanh','Nông trại Green Farm là nông trại trồng rau hữu cơ kết hợp các khóa học trồng cây dành cho mọi 
lứa tuổi tọa lạc tại 130 Nguyễn Văn Hưởng, Thảo Điền, TP. Thủ Đức, TPHCM. Đây là địa chỉ du lịch sinh thái được rất nhiều người biết đến 
và là một trong những nơi tham quan dành cho lứa tuổi mầm non.Green Farm do nhóm bạn trẻ xây dựng với mong muốn mọi người có thể tiếp cận và tham 
quan xem quy trình trồng rau sạch.','https://static.wixstatic.com/media/7406f4_9460923b9f0a4728956836ff18c5e3f1~mv2.jpg/v1/crop/x_458,y_0,w_564,h_798/fill/w_300,h_420,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/IMG_8203_JPG.jpg','Thứ bảy hàng tuần','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),
(9,'Trại Ngoại Ô Trang Trại Xanh','Nông trại Green Farm là nông trại trồng rau hữu cơ kết hợp các khóa học trồng cây dành cho mọi 
lứa tuổi tọa lạc tại 130 Nguyễn Văn Hưởng, Thảo Điền, TP. Thủ Đức, TPHCM. Đây là địa chỉ du lịch sinh thái được rất nhiều người biết đến 
và là một trong những nơi tham quan dành cho lứa tuổi mầm non.Green Farm do nhóm bạn trẻ xây dựng với mong muốn mọi người có thể tiếp cận và tham 
quan xem quy trình trồng rau sạch.','https://static.wixstatic.com/media/7406f4_296a6e28ae57446aa54ac5214d0a246f~mv2.jpg/v1/crop/x_471,y_0,w_857,h_1200/fill/w_300,h_420,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Blue_JPG.jpg','Chủ nhật hàng tuần','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),
(10,'Bầu trời nông nghiệp','Nông trại Green Farm là nông trại trồng rau hữu cơ kết hợp các khóa học trồng cây dành cho mọi 
lứa tuổi tọa lạc tại 130 Nguyễn Văn Hưởng, Thảo Điền, TP. Thủ Đức, TPHCM. Đây là địa chỉ du lịch sinh thái được rất nhiều người biết đến 
và là một trong những nơi tham quan dành cho lứa tuổi mầm non.Green Farm do nhóm bạn trẻ xây dựng với mong muốn mọi người có thể tiếp cận và tham 
quan xem quy trình trồng rau sạch.','https://images.pexels.com/photos/539282/pexels-photo-539282.jpeg','Ngày 15 hàng tháng','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu'),

(11,'Cánh đồng cẩm tú cầu','Nông trại Green Farm là nông trại trồng rau hữu cơ kết hợp các khóa học trồng cây dành cho mọi 
lứa tuổi tọa lạc tại 130 Nguyễn Văn Hưởng, Thảo Điền, TP. Thủ Đức, TPHCM. Đây là địa chỉ du lịch sinh thái được rất nhiều người biết đến 
và là một trong những nơi tham quan dành cho lứa tuổi mầm non.Green Farm do nhóm bạn trẻ xây dựng với mong muốn mọi người có thể tiếp cận và tham 
quan xem quy trình trồng rau sạch.','https://cdn.vntour.com.vn/storage/media/img/2019/07/01/cau-dat-farm-da-lat-6_1561945950.gif','Ngày 20 hàng tháng','GREEN FARM – Nông trại du lịchThôn Sông Xoài 1, Láng Lớn, Châu Đức, Bà Rịa Vũng Tàu');


INSERT INTO Pricings (TourID, AdultPrice,ChildPrice) values
(1, 255000, 170000),
(2, 150000, 100000),
(3, 200000, 150000),
(4, 150000, 85000),
(5, 100000, 50000),
(6, 135000, 70000),
(7, 135000, 70000),
(8, 1100000, 730000),
(9, 2000000, 1550000),
(10,2000000, 1550000),
(11,1000000,1500000);

 INSERT INTO TourConditions (TourConditionID, TourID, Conditions) VALUES
(1,1,'Tour bao gồm: HDV chuyên nghiệp suốt tuyến,- Suất ăn tiêu chuẩn 4-5 món các bữa, các món được thay đổi linh động - Bảo hiểm du lịch 20.000.000vnd/vụ - Khách sạn tiêu chuẩn 2-3 khách/ phòng - Tour không bao gồm: Chi phí tham quan ngoài trương trình - Chi phí ăn uống ngoài chương trình - Thuế VAT 08%. Điều kiện trẻ em: - Trẻ em dưới 4 tuổi được miến phí vé(Ngồi chung với người lớn) - Từ 4- dưới 10 tuổi tính 75% giá vé người lớn. Quy định hủy tour: - Trường hợp không báo trước, đến trễ giờ bắt đầu tour hoặc báo hủy, dời ngày trước 01 ngày khởi hành quý khách phải chịu 100% phí tour và không được hoàn cọc. Quy định hủy đối với ngày lễ tết: - Hủy trước 10 ngày chịu phạt 50% phí tour. - Hủy trước 03-09 ngày chịu phạt 75% phí tour. - Hủy trước 2 ngày chịu 100% phí tour. Quy định đối với ngày thường -  Hủy trước 07 ngày khởi hành chịu phạt 50% phí tour. - Hủy trước 03-07 ngày chịu phạt 75% phí tour. - Hủy trước 02 ngày chịu 100% phí tour hoặc mất 100% phí cọc tour.'),
(2,2,'I. GIÁ DỊCH VỤ – Giá dịch vụ được chúng tôi ấn định là Việt Nam đồng ( VNĐ ) – Giá chưa bao gồm thuế VAT 10% – Giá là giá niêm yết ( không trích lại hoa hồng dành cho người giới thiệu ) – Giá dịch vụ là giá dành cho 01 người ( 02 người/01 phòng ) nếu trường hợp lẻ nam hoặc nữ thì tuỳ vào từng khách sạn quý khách đặt sẽ tính phụ thu cho người thứ 3 đó.IV. QUY DỊNH DÀNH CHO TRẺ EM – Không có quy định nghiêm ngặt nào cho độ tuổi của các cháu bé khi tham gia tour. Tuy nhiên để đảm bảo về độ an toàn cũng như sự thuận tiện của hành khách khi có con nhỏ đi kèm thì độ tuổi thấp nhất là 06 tháng đến 1 năm tuổi. Khi tham gia tour với chúng tôi bắt buộc phải đi cùng với bố hoặc mẹ đẻ, trường hợp đi cùng với người nhà cần có giấy xác nhận của bố mẹ. Quy định hủy tour: - Trường hợp không báo trước, đến trễ giờ bắt đầu tour hoặc báo hủy, dời ngày trước 01 ngày khởi hành quý khách phải chịu 100% phí tour và không được hoàn cọc. Quy định hủy đối với ngày lễ tết: - Hủy trước 10 ngày chịu phạt 50% phí tour. - Hủy trước 03-09 ngày chịu phạt 75% phí tour. - Hủy trước 2 ngày chịu 100% phí tour. Quy định đối với ngày thường -  Hủy trước 07 ngày khởi hành chịu phạt 50% phí tour. - Hủy trước 03-07 ngày chịu phạt 75% phí tour. - Hủy trước 02 ngày chịu 100% phí tour hoặc mất 100% phí cọc tour.'),
(3,3,'Chương trình trải nghiệm tại Green Farm 1 buổi hoặc cả ngày (theo lịch hoạt động của nông trại bao gồm kỹ sư hướng dẫn, vé vào cổng).Nông sản mang về (0,5kg rau lá các loại ngoại trừ rau bầu đất).Dụng cụ tham gia trải nghiệm (nón lá, rổ, bao tay,…)Hoạt động Workshop ứng dụng đảm bảo mỗi học sinh/phần nguyên vật liệu thực hiện sản phẩm mang về.Nước uống (bình lớn 20 lít) – Học sinh tự túc mang theo bình nước cá nhân. Ăn trưa thực đơn phù hợp (Chương trình cả ngày).MC hướng dẫn và hoạt náo trong quá trình trải nghiệm.Leader hỗ trợ học sinh hoạt động 01 leader/ 25 học sinh.==> bỏBảo hiểm du lịch mức tối đa 20.000.000vnđ/trường hợp.Thuế VAT 10%.Quà tặng đặc biệt: 01 món quà Eco-Gift (túi vải đựng bình nước cá nhân/bộ muỗng+nĩa dừa/túi hạt giống đậu biếc).'),
(4,4,'Chương trình trải nghiệm tại Green Farm 1 buổi hoặc cả ngày (theo lịch hoạt động của nông trại bao gồm kỹ sư hướng dẫn, vé vào cổng).Nông sản mang về (0,5kg rau lá các loại ngoại trừ rau bầu đất).Dụng cụ tham gia trải nghiệm (nón lá, rổ, bao tay,…)Hoạt động Workshop ứng dụng đảm bảo mỗi học sinh/phần nguyên vật liệu thực hiện sản phẩm mang về.Nước uống (bình lớn 20 lít) – Học sinh tự túc mang theo bình nước cá nhân. Ăn trưa thực đơn phù hợp (Chương trình cả ngày).MC hướng dẫn và hoạt náo trong quá trình trải nghiệm.Leader hỗ trợ học sinh hoạt động 01 leader/ 25 học sinh.==> bỏBảo hiểm du lịch mức tối đa 20.000.000vnđ/trường hợp.Thuế VAT 10%.Quà tặng đặc biệt: 01 món quà Eco-Gift (túi vải đựng bình nước cá nhân/bộ muỗng+nĩa dừa/túi hạt giống đậu biếc).'),
(5,5,'Vé tham quan các điểm có trong chương trình. Xe 45 chỗ đời mới máy lạnh (tiêu chuẩn 50 hs/xe)Bữa trưa tiêu chuẩn (thêm 15k đối với xuất ăn cơm quê gia đình)Tặng nón du lịch cho bé.Nước uống cho bé suốt tuyến..HDV, tài xế vui vẻ  nhiệt tình, chuyên nghiệp phục vụ suốt tuyến.(2 HDV/xe).Miễn phí Ban Giám Hiệu và Giáo Viên theo tiêu chuẩn: 10 bé/ GVBảo hiểm du lịch cho bé. (theo quy định).'),
(6,6,'Chương trình trải nghiệm tại Green Farm 1 buổi hoặc cả ngày (theo lịch hoạt động của nông trại bao gồm kỹ sư hướng dẫn, vé vào cổng).Nông sản mang về (0,5kg rau lá các loại ngoại trừ rau bầu đất).Dụng cụ tham gia trải nghiệm (nón lá, rổ, bao tay,…)Hoạt động Workshop ứng dụng đảm bảo mỗi học sinh/phần nguyên vật liệu thực hiện sản phẩm mang về.Nước uống (bình lớn 20 lít) – Học sinh tự túc mang theo bình nước cá nhân. Ăn trưa thực đơn phù hợp (Chương trình cả ngày).MC hướng dẫn và hoạt náo trong quá trình trải nghiệm.Leader hỗ trợ học sinh hoạt động 01 leader/ 25 học sinh.==> bỏBảo hiểm du lịch mức tối đa 20.000.000vnđ/trường hợp.Thuế VAT 10%.Quà tặng đặc biệt: 01 món quà Eco-Gift (túi vải đựng bình nước cá nhân/bộ muỗng+nĩa dừa/túi hạt giống đậu biếc).'),
(7,7,'Chương trình trải nghiệm tại Green Farm 1 buổi hoặc cả ngày (theo lịch hoạt động của nông trại bao gồm kỹ sư hướng dẫn, vé vào cổng).Nông sản mang về (0,5kg rau lá các loại ngoại trừ rau bầu đất).Dụng cụ tham gia trải nghiệm (nón lá, rổ, bao tay,…)Hoạt động Workshop ứng dụng đảm bảo mỗi học sinh/phần nguyên vật liệu thực hiện sản phẩm mang về.Nước uống (bình lớn 20 lít) – Học sinh tự túc mang theo bình nước cá nhân. Ăn trưa thực đơn phù hợp (Chương trình cả ngày).MC hướng dẫn và hoạt náo trong quá trình trải nghiệm.Leader hỗ trợ học sinh hoạt động 01 leader/ 25 học sinh.==> bỏBảo hiểm du lịch mức tối đa 20.000.000vnđ/trường hợp.Thuế VAT 10%.Quà tặng đặc biệt: 01 món quà Eco-Gift (túi vải đựng bình nước cá nhân/bộ muỗng+nĩa dừa/túi hạt giống đậu biếc).'),
(8,8,'Chương trình trải nghiệm tại Green Farm 1 buổi hoặc cả ngày (theo lịch hoạt động của nông trại bao gồm kỹ sư hướng dẫn, vé vào cổng).Nông sản mang về (0,5kg rau lá các loại ngoại trừ rau bầu đất).Dụng cụ tham gia trải nghiệm (nón lá, rổ, bao tay,…)Hoạt động Workshop ứng dụng đảm bảo mỗi học sinh/phần nguyên vật liệu thực hiện sản phẩm mang về.Nước uống (bình lớn 20 lít) – Học sinh tự túc mang theo bình nước cá nhân. Ăn trưa thực đơn phù hợp (Chương trình cả ngày).MC hướng dẫn và hoạt náo trong quá trình trải nghiệm.Leader hỗ trợ học sinh hoạt động 01 leader/ 25 học sinh.==> bỏBảo hiểm du lịch mức tối đa 20.000.000vnđ/trường hợp.Thuế VAT 10%.Quà tặng đặc biệt: 01 món quà Eco-Gift (túi vải đựng bình nước cá nhân/bộ muỗng+nĩa dừa/túi hạt giống đậu biếc).'),
(9,9,'Chương trình trải nghiệm tại Green Farm 1 buổi hoặc cả ngày (theo lịch hoạt động của nông trại bao gồm kỹ sư hướng dẫn, vé vào cổng).Nông sản mang về (0,5kg rau lá các loại ngoại trừ rau bầu đất).Dụng cụ tham gia trải nghiệm (nón lá, rổ, bao tay,…)Hoạt động Workshop ứng dụng đảm bảo mỗi học sinh/phần nguyên vật liệu thực hiện sản phẩm mang về.Nước uống (bình lớn 20 lít) – Học sinh tự túc mang theo bình nước cá nhân. Ăn trưa thực đơn phù hợp (Chương trình cả ngày).MC hướng dẫn và hoạt náo trong quá trình trải nghiệm.Leader hỗ trợ học sinh hoạt động 01 leader/ 25 học sinh.==> bỏBảo hiểm du lịch mức tối đa 20.000.000vnđ/trường hợp.Thuế VAT 10%.Quà tặng đặc biệt: 01 món quà Eco-Gift (túi vải đựng bình nước cá nhân/bộ muỗng+nĩa dừa/túi hạt giống đậu biếc).'),
(10,10,'Chương trình trải nghiệm tại Green  Farm 1 buổi hoặc cả ngày (theo lịch hoạt động của nông trại bao gồm kỹ sư hướng dẫn, vé vào cổng).Nông sản mang về (0,5kg rau lá các loại ngoại trừ rau bầu đất).Dụng cụ tham gia trải nghiệm (nón lá, rổ, bao tay,…)Hoạt động Workshop ứng dụng đảm bảo mỗi học sinh/phần nguyên vật liệu thực hiện sản phẩm mang về.Nước uống (bình lớn 20 lít) – Học sinh tự túc mang theo bình nước cá nhân. Ăn trưa thực đơn phù hợp (Chương trình cả ngày).MC hướng dẫn và hoạt náo trong quá trình trải nghiệm.Leader hỗ trợ học sinh hoạt động 01 leader/ 25 học sinh.==> bỏBảo hiểm du lịch mức tối đa 20.000.000vnđ/trường hợp.Thuế VAT 10%.Quà tặng đặc biệt: 01 món quà Eco-Gift (túi vải đựng bình nước cá nhân/bộ muỗng+nĩa dừa/túi hạt giống đậu biếc).'),
(11,11,'Chương trình trải nghiệm tại Green  Farm 1 buổi hoặc cả ngày (theo lịch hoạt động của nông trại bao gồm kỹ sư hướng dẫn, vé vào cổng).Nông sản mang về (0,5kg rau lá các loại ngoại trừ rau bầu đất).Dụng cụ tham gia trải nghiệm (nón lá, rổ, bao tay,…)Hoạt động Workshop ứng dụng đảm bảo mỗi học sinh/phần nguyên vật liệu thực hiện sản phẩm mang về.Nước uống (bình lớn 20 lít) – Học sinh tự túc mang theo bình nước cá nhân. Ăn trưa thực đơn phù hợp (Chương trình cả ngày).MC hướng dẫn và hoạt náo trong quá trình trải nghiệm.Leader hỗ trợ học sinh hoạt động 01 leader/ 25 học sinh.==> bỏBảo hiểm du lịch mức tối đa 20.000.000vnđ/trường hợp.Thuế VAT 10%.Quà tặng đặc biệt: 01 món quà Eco-Gift (túi vải đựng bình nước cá nhân/bộ muỗng+nĩa dừa/túi hạt giống đậu biếc).');
INSERT INTO TourOverViews (TourID,Title, Content)VALUES
(1, ' Ngày Hội Nghệ Thuật GreenFarm','Workshop là một hình thức học tập, chia sẻ kiến thức, kỹ năng có tính mở rất cao. Workshop thiên về thực hành thường là những workshop trong lĩnh vực kĩ thuật, thủ công, nghệ thuật, tâm lý. Bạn sẽ được tự tay làm ra một sản phẩm, một tác phẩm, hoặc thực hành một kĩ năng nào đó. Hình thức workshop này yêu cầu phải có người hướng dẫn và những dụng cụ cơ bản để người tham gia thực hành. Số lượng người tham gia một buổi workshop dạng này thường không nhiều để đảm bảo ai cũng được hướng dẫn chi tiết..'),
(2, ' Hãy là một nông dân hạnh phúc GreenFarm','HOẠT ĐỘNG : - Tham quan Nông Trang hữu cơ công nghệ cao - Tham quan khu chăn nuôi, cho vật nuôi ăn (bồ câu, dê, thỏ, heo rừng,.v.v.)- Thu hoạch Rau xanh sạch đạt chuẩn Hữu Cơ Việt Nam- Trải nghiệm xe "buýt" máy cày- Cùng tham gia các hoạt động kết nối như trồng cây, đóng gói rau xanh,v.v.)  .'),
(3, ' Cuộc phiêu lưu hạt giống GreenFarm','Gặp gỡ kỹ sư, tìm hiểu về các loại nông sản được trồng theo phương pháp hữu cơ. Bắt tay vào việc để trở thành “những nông dân thấu hiểu”. Cùng nhau thu hoạch những thành quả của thiên nhiên nuôi lớn cùng bàn tay tỉ mỉ của người nông dân Ghé thăm khu chăn nuôi thỏ, dê.'),
(4, ' Thăm Trang Trại Xanh GreenFarm','HOẠT ĐỘNG : - Tham quan Nông Trang hữu cơ công nghệ cao - Tham quan khu chăn nuôi, cho vật nuôi ăn (bồ câu, dê, thỏ, heo rừng,.v.v.)- Thu hoạch Rau xanh sạch đạt chuẩn Hữu Cơ Việt Nam- Trải nghiệm xe "buýt" máy cày- Cùng tham gia các hoạt động kết nối như trồng cây, đóng gói rau xanh,v.v.)  ..'),
(5, ' Mầm Non Làm Nông Dân GreenFarm','HOẠT ĐỘNG : - Tham quan Nông Trang hữu cơ công nghệ cao - Tham quan khu chăn nuôi, cho vật nuôi ăn (bồ câu, dê, thỏ, heo rừng,.v.v.)- Thu hoạch Rau xanh sạch đạt chuẩn Hữu Cơ Việt Nam- Trải nghiệm xe "buýt" máy cày- Cùng tham gia các hoạt động kết nối như trồng cây, đóng gói rau xanh,v.v.) .'),
(6, ' Trải Nghiệm Làm Nông Dân GreenFarm ','GreenFarm, một vùng đất xanh mát rộng lớn hơn 20.000 m2 tọa lạc tại huyện Bình Chánh, TP. Hồ Chí Minh, là nơi chứa đựng những giá trị tinh túy của nông nghiệp bền vững và tự nhiên. Khám phá GreenFarm, các bé sẽ được hòa mình vào không gian nông trại yên bình, chăm sóc động vật dễ thương, trải nghiệm việc trồng trọt và tìm hiểu những phương pháp nông nghiệp bền vững, hiệu quả. Để rồi, các bé sẽ nhận ra rằng, chúng ta cần có những khoảnh khắc gần gũi với thiên nhiên, để tìm lại sự bình yên cho tâm hồn. Hãy đến World Farm, nơi tâm hồn kết nối với thiên nhiên.'),
(7, ' Tham Quan Vườn Rau Xanh GreenFarm','HOẠT ĐỘNG : - Tham quan Nông Trang hữu cơ công nghệ cao - Tham quan khu chăn nuôi, cho vật nuôi ăn (bồ câu, dê, thỏ, heo rừng,.v.v.)- Thu hoạch Rau xanh sạch đạt chuẩn Hữu Cơ Việt Nam- Trải nghiệm xe "buýt" máy cày- Cùng tham gia các hoạt động kết nối như trồng cây, đóng gói rau xanh,v.v.) .'),
(8, ' Khu nghỉ dưỡng sinh thái trang trại xanh GreenFarm','HOẠT ĐỘNG : - Tham quan Nông Trang hữu cơ công nghệ cao - Tham quan khu chăn nuôi, cho vật nuôi ăn (bồ câu, dê, thỏ, heo rừng,.v.v.)- Thu hoạch Rau xanh sạch đạt chuẩn Hữu Cơ Việt Nam- Trải nghiệm xe "buýt" máy cày- Cùng tham gia các hoạt động kết nối như trồng cây, đóng gói rau xanh,v.v.)  .'),
(9, ' Trại Ngoại Ô Trang Trại Xanh GreenFarm ','HOẠT ĐỘNG : - Tham quan Nông Trang hữu cơ công nghệ cao - Tham quan khu chăn nuôi, cho vật nuôi ăn (bồ câu, dê, thỏ, heo rừng,.v.v.)- Thu hoạch Rau xanh sạch đạt chuẩn Hữu Cơ Việt Nam- Trải nghiệm xe "buýt" máy cày- Cùng tham gia các hoạt động kết nối như trồng cây, đóng gói rau xanh,v.v.)  .'),
(10, ' Cánh đồng cẩm tú cầu ','HOẠT ĐỘNG : Đến với Cầu Đất Farm ngoài tham quan đồi chè, cánh đồng hoa hướng dương, cánh đồng hoa lavender, cánh đồng hoa cẩm tú cầu thì bạn cũng quên ghé khu vực Cầu Đất Farm một trong những nông trại sở hữu quy mô lớn nhất Đà Lạt để tham quan khu vực nông sản sạch trồng cây ăn quả, rau sạch được trồng theo mô hình thủy canh nhé!)  .'),
(11, ' Bầu trời nông nghiệp GreenFarm ','HOẠT ĐỘNG : Đến với Cầu Đất Farm ngoài tham quan cánh đồng hoa hướng dương, cánh đồng hoa lavender, cánh đồng hoa cẩm tú cầu thì bạn cũng quên ghé khu vực Cầu Đất Farm một trong những nông trại sở hữu quy mô lớn nhất Đà Lạt để tham quan khu vực nông sản sạch trồng cây ăn quả, rau sạch được trồng theo mô hình thủy canh nhé!)  .');

INSERT INTO TourImages (TourImageID, TourID, ImageURL) VALUES
(1,1,'https://static.wixstatic.com/media/7406f4_ff5e866d637e4fcf9f75311a0d74c63a~mv2.jpg/v1/fill/w_475,h_606,al_l,q_80,usm_0.66_1.00_0.01,enc_auto/7406f4_ff5e866d637e4fcf9f75311a0d74c63a~mv2.jpg'),(2,1,'https://static.wixstatic.com/media/7406f4_0736a23c965f4d9aaaed29a1e54d9433~mv2.jpg/v1/fill/w_720,h_376,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/7406f4_0736a23c965f4d9aaaed29a1e54d9433~mv2.jpg'),(3,1,'https://static.wixstatic.com/media/7406f4_97ad00d587754e7784a5f57deecf020a~mv2.jpg/v1/fill/w_480,h_376,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/7406f4_97ad00d587754e7784a5f57deecf020a~mv2.jpg'),
(4,2,'https://static.wixstatic.com/media/7406f4_f4b5a29da1d449d09bef631c6536076c~mv2.jpg/v1/fill/w_299,h_224,al_c,q_80,usm_0.66_1.00_0.01/7406f4_f4b5a29da1d449d09bef631c6536076c~mv2.jpg'),(5,2,'https://static.wixstatic.com/media/7406f4_409babb7f75445659ab6d8192b1efc95~mv2.jpg/v1/fill/w_299,h_223,al_c,q_80,usm_0.66_1.00_0.01/7406f4_409babb7f75445659ab6d8192b1efc95~mv2.jpg'),(6,2,'https://static.wixstatic.com/media/7406f4_aa8987b12880458681343a3d7f464161~mv2.jpg/v1/fill/w_299,h_224,al_c,q_80,usm_0.66_1.00_0.01/7406f4_aa8987b12880458681343a3d7f464161~mv2.jpg'),
(7,3,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStQtGhlsKfC7t2mf_yrdvQ-JlnPs8IbdKdiA&usqp=CAU'),(8,3,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfqqX0h6OnacVqXn3NvXPZ2i0A42d3Ic7FcaamSYmFp4WA4TzZ5d-Ny7XZcusgZ_649T8&usqp=CAU'),(9,3,'https://tinviettravel.com.vn/uploads/cam-nang-du-lich/2019_11/trai-nghiem-be-lam-nong-dan-tai-happy-farm8-1.jpg'),
(10,4,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQI3h0SQMmTfNDD8bHmOUfOArNhx6FGJbVGsXNVn7BgaEM9b6_1Zn-aq7-Hymbkvn_xGdQ&usqp=CAU'),(11,4,'https://tinviettravel.com.vn/uploads/tours/2019_11/trong-lua-happy-farm_1.jpg'),(12,4,'https://afamilycdn.com/2019/9/25/ngoc-15694002334101573181689.jpg'),
(13,5,'https://patin365.com/datafiles/7450/upload/images/atfarm-nong-trai-gia-dinh-nong-trai-cho-be(1).jpg'),(14,5,'https://atfarm.vn/wp-content/uploads/2019/01/atfarm-don-chao-nam-moi-2019-640x401.jpg'),(15,5,'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/10/14/1104746/289447817_5437957605.jpg'),
(16,6,'https://tinviettravel.com.vn/uploads/tours/2023_05/hoat-dong-tren-san-cat-tai-world-farm.jpg'),(17,6,'https://tinviettravel.com.vn/uploads/tours/2023_05/z4316454701672_08e8f93fd75454b1315f987e53effcbc.jpg'),(18,6,'https://tinviettravel.com.vn/uploads/tours/2023_05/trai-nghiem-lam-nong-dan-di-cau-khi.jpg'),
(19,7,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0P5r86hmTMr8QnTrc5mnwTseEtD566EwUiIhtemzRylxMbAlSXUy_Zo1H4KpXpQJ5oVk&usqp=CAU'),(20,7,'https://file3.qdnd.vn/data/images/0/2022/11/09/tuanson/4.jpg?dpi=150&quality=100&w=870'),(21,7,'https://baodongkhoi.vn/image/fckeditor/upload/2018/20180531/images/BDK1.jpg'),
(22,8,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRM8yWJacH4dydNqSDWXQA7pu32Z0YTM_bTG4r34arHYNI1T-0hsPHSgbw4mEazR64KKI0&usqp=CAU'),(23,8,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgWo7yvY-L7p7U_e2UPiaQdtF0f4getVUHwyxBL33oxUr8QcJxfIhfkR7773mF2fx7OU0&usqp=CAU'),(24,8,'https://baocantho.com.vn/image/fckeditor/upload/2022/20220819/images/du-lich-nong-nghiep.jpg'),
(25,9,'https://songcatinh.com/wp-content/uploads/2021/05/tat-tan-tat-kinh-nghiem-cam-trai-eco-farm.jpg'),(26,9,'https://scontent.iocvnpt.com/resources/portal/Images/CTO/adminportal.cto/2022/29_06_05_07/lalang_farm_%E2%80%93_camping_tai_can_tho/1c13535dd29911c74888_26722476.jpg'),(27,9,'https://moitruongdulich.vn/mypicture/images/2023/T1/121Nong-nghiep-ket-hop-du-lich---Huong-di-cua-su-ben-vung.jpg'),
(28,10,'https://statics.vinwonders.com/canh-dong-hoa-cam-tu-cau-1_1689996361.jpg'),(29,10,'https://tripday.vn/wp-content/uploads/2022/11/cam-tu-1.jpg'),
(30,11,'https://img.dantocmiennui.vn/t620/uploaded/exlpvekyzsztyyrey/2023_04_29/vna_potal_du_lich_va_nong_nghiep_da_nang_dong_hanh_phat_trien_6705491.jpg'),(31,11,'https://vimefarm.vn/wp-content/uploads/ttl.20221007091406.976.jpg');

INSERT INTO TourDates (TourdateID, TourID, Tourdates, AvailableSlots) VALUES
(1,1,'2023-12-03',45),
(2,1,'2023-12-10',45),
(3,1,'2023-12-17',45),
(4,1,'2023-12-24',45),
(5,1,'2023-12-31',45),
(6,2,'2023-12-02',45),
(7,2,'2023-12-09',45),
(8,2,'2023-12-16',45),
(9,2,'2023-12-23',45),
(10,2,'2023-12-30',45),
(11,3,'2023-12-14',45),
(12,4,'2023-12-03',45),
(13,4,'2023-12-10',45),
(14,4,'2023-12-17',45),
(15,4,'2023-12-24',45),
(16,4,'2023-12-31',45),
(17,5,'2023-12-02',45),
(18,5,'2023-12-09',45),
(19,5,'2023-12-16',45),
(20,5,'2023-12-23',45),
(21,5,'2023-12-30',45),
(22,6,'2023-12-15',45),
(23,7,'2023-12-20',45),
(24,8,'2023-12-02',45),
(25,8,'2023-12-09',45),
(26,8,'2023-12-16',45),
(27,8,'2023-12-23',45),
(28,8,'2023-12-30',45),
(29,9,'2023-12-03',45),
(30,9,'2023-12-10',45),
(31,9,'2023-12-17',45),
(32,9,'2023-12-24',45),
(33,9,'2023-12-31',45),
(34,10,'2023-12-15',35),
(35,11,'2023-12-20',45);





INSERT INTO Bookings (BookingID, UserID, TourID, BookingDate, AdultTicketNumber,ChildTicketNumber, TotalPrice, StatusBookingID, PaymentMethodID) VALUES
(1,1,1,'2019-12-03',3,2,1105000,2,3),
(2,1,1,'2019-11-23',2,2,250000,2,1),
(3,1,1,'2019-10-10',4,2,1100000,1,2),
(4,1,1,'2019-10-01',4,2,770000,5,1),
(5,1,1,'2019-09-25',1,2,200000,5,1),
(6,1,2,'2019-08-23',3,2,485000,3,1),
(7,1,2,'2019-10-01',3,2,485000,2,3),
(8,1,2,'2019-07-13',2,2,3360000,5,1),
(9,1,2,'2019-06-28',2,0,2000000,5,3),
(10,1,2,'2019-10-20',2,2,500000,5,1),
(11,1,3,'2020-07-07',1,2,275000,3,1),
(12,1,4,'2020-06-12',3,2,545000,2,3),
(13,1,4,'2020-06-30',4,2,5860000,5,1),
(14,1,4,'2020-06-28',2,0,4000000,5,2),

(15,2,4,'2020-10-21',1,2,595000,5,2),
(16,2,4,'2020-11-12',1,2,500000,1,1),
(17,2,5,'2020-09-22',3,2,610000,5,2),
(18,2,5,'2020-11-03',2,2,200000,4,1),
(19,2,5,'2020-11-23',1,2,275000,3,1),
(20,2,5,'2020-11-05',3,2,545000,1,3),
(21,2,5,'2023-10-13',2,2,3360000,5,1),
(22,7,7,'2023-09-04',2,0,2000000,4,3),
(23,2,7,'2022-04-18',1,2,5100000,1,1),

(24,3,8,'2023-05-01',3,1,1105000,2,3),
(25,3,8,'2023-03-25',1,2,250000,2,1),
(26,3,3,'2023-04-15',1,2,1100000,1,2),
(27,3,4,'2022-10-01',1,1,770000,5,1),
(28,3,5,'2021-09-09',1,2,200000,5,1),
(29,3,6,'2023-08-03',3,2,485000,3,1),
(30,3,7,'2023-11-07',3,2,485000,2,3),
(31,3,8,'2023-07-13',2,1,3360000,5,1),
(32,3,9,'2023-06-28',3,0,2000000,5,3),
(33,3,5,'2023-10-24',2,1,500000,5,1),
(34,3,9,'2022-07-23',1,2,275000,3,1),
(35,3,3,'2023-06-11',3,0,545000,2,3),
(36,3,1,'2023-11-30',5,2,5860000,5,1),
(37,3,4,'2023-08-12',2,0,4000000,5,2),

(38,4,1,'2023-07-01',3,1,935000,2,3),
(39,4,2,'2022-03-25',2,2,500000,2,1),
(40,4,3,'2023-11-22',1,1,350000,1,2),
(41,4,4,'2022-10-01',3,1,535000,5,1),
(42,4,5,'2021-10-09',1,2,200000,5,1),
(43,4,6,'2023-08-03',3,2,545000,3,1),
(44,4,7,'2023-10-07',1,2,205000,2,3),
(45,4,8,'2023-07-13',1,1,1830000,5,1),
(46,4,9,'2023-06-28',3,1,7550000,5,3),
(47,4,5,'2023-11-24',4,1,450000,5,1),
(48,4,9,'2023-11-19',1,2,5100000,3,1),
(49,4,3,'2023-08-28',1,1,350000,2,1),
(50,4,1,'2023-10-30',2,1,680000,5,1),
(51,4,4,'2023-08-12',2,1,385000,5,1),

(52,5,1,'2022-11-11',3,1,935000,5,3),
(53,5,2,'2022-05-15',2,2,500000,5,1),
(54,5,3,'2023-11-10',1,1,350000,1,2),
(55,5,4,'2022-08-13',3,2,535000,5,1),
(56,5,5,'2021-03-09',4,2,200000,5,1),
(57,5,6,'2023-09-19',3,2,545000,3,1),
(58,5,7,'2023-11-09',3,2,205000,2,3),
(59,5,8,'2023-11-22',2,1,1830000,2,1),
(60,5,8,'2023-08-11',3,2,7550000,5,3),
(61,5,5,'2023-09-25',3,1,450000,1,1),
(62,5,9,'2023-06-16',5,2,5100000,5,1),
(63,5,3,'2023-05-10',1,1,350000,2,1),
(64,5,1,'2023-11-24',2,1,680000,5,1),
(65,5,4,'2023-10-19',2,1,85000,2,1),


(66,5,1,'2022-11-11',3,1,935000,5,3),
(67,5,2,'2022-05-15',2,2,500000,5,1),
(68,5,3,'2023-11-10',1,1,350000,1,2),
(69,5,4,'2022-08-13',3,2,535000,5,1),
(70,5,5,'2021-03-09',4,2,200000,5,1),
(71,5,6,'2023-09-19',3,2,545000,3,1),
(72,5,7,'2023-11-09',3,2,205000,2,3),
(73,5,8,'2023-11-11',2,1,1830000,2,1),
(74,5,9,'2023-08-11',3,2,7550000,5,3),
(75,5,5,'2023-09-25',3,1,450000,1,1),
(76,5,9,'2023-06-16',5,2,5100000,5,1),
(77,5,3,'2023-08-10',1,1,350000,2,1),
(78,5,1,'2023-11-24',2,1,680000,5,1),
(79,5,4,'2023-11-19',2,1,85000,2,1),

(80,6,1,'2022-11-11',3,1,935000,5,3),
(81,6,2,'2022-05-15',2,2,500000,5,1),
(82,6,3,'2023-11-10',1,1,350000,1,2),
(83,6,4,'2022-08-13',3,2,535000,5,1),
(84,6,5,'2021-03-09',4,2,200000,5,1),
(85,6,6,'2023-09-19',3,2,545000,3,1),
(86,6,7,'2023-05-09',3,2,205000,2,3),
(87,6,8,'2023-11-27',2,1,1830000,2,1),
(88,6,9,'2023-08-11',3,2,7550000,5,3),
(89,6,5,'2023-09-25',3,1,450000,1,1),
(90,6,9,'2023-06-16',5,2,5100000,5,1),
(91,6,3,'2023-08-10',1,1,350000,2,1),
(92,6,1,'2023-11-12',2,1,680000,5,1),
(93,6,4,'2023-08-19',2,1,85000,2,1),

(94,7,1,'2022-11-11',3,1,935000,5,3),
(95,7,2,'2022-05-15',2,2,500000,5,1),
(96,7,3,'2023-11-10',1,1,350000,1,2),
(97,7,4,'2022-08-13',3,2,535000,5,1),
(98,7,5,'2021-03-09',4,2,200000,5,1),
(99,7,6,'2023-09-19',3,2,545000,3,1),
(100,7,7,'2023-09-09',3,2,205000,2,3),
(101,7,8,'2023-11-23',2,1,1830000,2,1),
(102,7,9,'2023-08-11',3,2,7550000,5,3),
(103,7,5,'2023-09-25',3,1,450000,1,1),
(104,7,9,'2023-06-16',5,2,5100000,5,1),
(105,7,3,'2023-10-10',1,1,350000,2,1),
(106,7,1,'2023-11-23',2,1,680000,5,1),
(107,7,4,'2023-08-19',2,1,85000,2,1),

(108,8,1,'2022-09-11',2,1,680000,5,3),
(109,8,2,'2022-03-15',2,1,400000,4,1),
(110,8,3,'2023-05-10',2,1,550000,1,2),
(111,8,4,'2022-07-13',3,2,626000,5,1),
(112,8,5,'2021-10-09',2,1,250000,3,1),
(113,8,6,'2023-11-19',1,2,275000,3,1),
(114,8,7,'2023-09-10',2,1,340000,5,3),
(115,8,8,'2023-10-27',3,2,900000,5,1),
(116,8,9,'2023-09-11',1,1,3550000,5,3),
(117,8,5,'2023-11-22',1,0,1100000,1,1),
(118,8,9,'2023-10-16',2,3,8650000,1,1),
(119,8,3,'2023-11-10',6,1,135000,3,1),
(120,8,1,'2023-10-25',1,2,595000,1,1),
(121,8,4,'2023-09-22',1,0,150000,1,1),
(122,9,1,'2022-09-11',3,1,935000,5,3),

(123,9,2,'2022-10-15',2,2,500000,5,1),
(124,9,3,'2023-09-10',1,1,350000,1,2),
(125,9,4,'2022-11-13',3,2,535000,5,1),
(126,9,5,'2021-08-09',4,2,200000,5,1),
(127,9,6,'2023-04-19',3,2,545000,3,1),
(128,9,7,'2023-05-09',3,2,205000,2,3),
(129,9,8,'2023-01-18',2,0,1830000,2,1),
(130,9,9,'2023-09-04',1,2,7550000,5,3),
(131,9,5,'2023-11-21',3,2,450000,1,1),
(132,9,9,'2023-10-16',1,0,2000000,1,1),
(133,9,1,'2023-10-02',1,1,425000,5,1),
(134,9,4,'2023-07-19',2,2,470000,1,1),

(135,10,1,'2022-09-11',3,1,935000,5,3),
(136,10,2,'2022-04-15',2,1,400000,5,1),
(137,10,3,'2023-10-10',1,3,650000,5,2),
(138,10,4,'2022-08-13',2,1,385000,1,1),
(139,10,5,'2021-06-09',3,3,450000,5,1),
(140,10,6,'2023-07-19',3,1,475000,4,1),
(141,10,8,'2023-07-09',2,2,410000,5,3),
(142,10,9,'2023-06-27',1,1,1830000,5,1),
(143,10,9,'2023-10-11',1,0,2000000,5,3),
(144,10,9,'2023-11-21',2,2,300000,2,1),
(145,10,9,'2023-10-16',1,3,6650000,5,1),
(146,10,9,'2023-09-10',5,2,1300000,2,1),
(147,10,1,'2023-10-25',4,1,1190000,5,1),
(148,10,1,'2023-09-19',1,2,32000,1,1),

(149,11,1,'2022-11-11',1,0,255000,5,3),
(150,11,2,'2022-05-15',2,2,500000,5,1),
(151,11,2,'2023-01-10',3,3,1050000,1,2),
(152,11,2,'2022-05-13',2,0,300000,5,1),
(153,11,1,'2021-01-09',5,2,600000,5,1),
(154,11,1,'2023-11-19',4,2,680000,3,1),
(155,11,2,'2023-10-09',3,1,475000,2,3),
(156,11,6,'2023-10-27',3,1,4030000,2,1),
(157,11,7,'2023-09-11',3,3,10650000,5,3),
(158,11,8,'2023-10-25',6,0,600000,1,1),
(159,11,5,'2023-11-16',1,2,5100000,5,1),
(160,11,6,'2023-07-25',4,1,350000,2,1),
(161,11,5,'2023-08-25',3,1,935000,1,1),
(162,11,6,'2023-09-19',3,1,535000,5,1),
(163,9,5,'2023-10-11',3,1,750000,2,1),
(164,9,9,'2023-10-11',3,1,750000,2,1);


INSERT INTO Reviews (ReviewID, content,datepost,rating,UserID,ProductID) VALUES
(1,'Đóng gói rất cẩn thận,đầy đủ.  dù là giá 1k . Cb hàng nhanh . Gửi nhanh. Kiện hàng đến tay ng nhận rất đẹp mắt, mua của shop 5-6 lần. Hạt nảy mầm rất đều, nhưng do mình gieo đúng dịp nồm ẩm bị thối nhũn hết nên phải mua lại.','2023-04-18',4,1,1),
(2,'Shop gói hàng cẩn thận, giao đầy đủ còn có cả quà tặng phân bón 100g. Tư vấn nhiệt tình lắm mọi người nên mua thử.','2021-12-02',3,1,4),
(3,'Shop giao hàng siu nhanh, mới đặt hôm trước hsau nhận đc r còn trồng có lên đc hay ko thì chưa bít','2022-03-12',2,1,2),
(4,'Hàng đẹp lắm shop ơi. Giao hàng nhanh. Shipeer nhiệt tình. Hàng đẹp giá tốt. Mẫu mã đa dạng','2022-08-08',1,2,1),
(5,'Mua đợt đầu thì các hạt giống đều nảy mầm khá tốt nha cả nhà. Thấy khá ổn và quay lại mua lần 2 đây ạ...','2023-07-12',4,3,1),
(6,'Đóng gói sản phẩm ok, giống cây trồng được đẹp như tranh vẽ bằng bút chì và cục tẩy trắng đang trồng thử nên chưa biết chất lượng hàng ok lắm nha,','2023-09-21',3,2,3),
(7,'Mua lần đầu nên mới trồng chưa biết chất lượng tn , ship nhanh , đóng gói ổn đúng đủ loại','2023-11-02',5,4,5),
(8,'Giao đủ số lượng, đóng gói kĩ càng giống chưa ươm nên không biết có lên không, nếu lên lần sau sẽ ủng hộ tiếp.','2023-10-18',3,1,3),
(9,'Giao hàng an toàn và nhanh chóng. Tôi đã nhận được','2023-10-02',4,22,55),
(10,'Sản phẩm nhận được đúng hẹn, không có gì để thấm sâu. Rất hài lòng nhé!','2023-02-02',5,21,55),
(11,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,55),
(12,'tệ','2023-05-17',1,21,55),
(13,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,55),
(14,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,55),
(15,'Cũm ổn á','2023-10-02',4,16,55),
(16,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,55),
(17,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,55),
(18,'chất lượng ','2023-08-23',5,14,55),
(19,'Giao hàng an toàn và nhanh chóng. Tôi đã nhận được','2023-10-02',4,22,54),

(20,'Sản phẩm nhận được đúng hẹn, không có gì để thấm sâu. Rất hài lòng nhé!','2023-02-02',5,21,54),

(21,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,54),

(22,'tệ','2023-05-17',1,21,54),

(23,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,54),

(24,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,54),

(25,'Cũm ổn á','2023-10-02',4,16,54),

(26,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,54),

(27,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,54),

(28,'chất lượng ','2023-08-23',5,14,54),


(29,'Giao hàng an toàn và nhanh chóng. Tôi đã nhận được','2023-10-02',4,22,53),

(30,'Sản phẩm nhận được đúng hẹn, không có gì để thấm sâu. Rất hài lòng nhé!','2023-02-02',5,21,53),

(31,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,53),

(32,'tệ','2023-05-17',1,21,53),

(33,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,53),

(34,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,53),

(35,'Cũm ổn á','2023-10-02',4,16,53),

(36,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,53),

(37,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,53),

(38,'chất lượng ','2023-08-23',5,14,53),

(39,'Giao hàng an toàn và nhanh chóng. Tôi đã nhận được','2023-10-02',4,22,53),

(40,'Sản phẩm nhận được đúng hẹn, không có gì để thấm sâu. Rất hài lòng nhé!','2023-02-02',5,21,52),

(41,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,52),

(42,'tệ','2023-05-17',1,21,52),

(43,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,52),

(44,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,52),

(45,'Cũm ổn á','2023-10-02',4,16,52),

(46,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,52),

(47,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,52),

(48,'chất lượng ','2023-08-23',5,14,52),

(49,'Cũm ổn á','2023-10-02',4,16,51),

(50,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,51),

(51,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,51),

(52,'chất lượng ','2023-08-23',5,14,50),

(53,'Giao hàng an toàn và nhanh chóng. Tôi đã nhận được','2023-10-02',4,22,50),

(54,'Sản phẩm nhận được đúng hẹn, không có gì để thấm sâu. Rất hài lòng nhé!','2023-02-02',5,21,50),

(55,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,49),

(56,'tệ','2023-05-17',1,21,49),

(57,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,49),

(58,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,49),

(59,'Cũm ổn á','2023-10-02',4,16,48),

(60,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,48),

(61,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,48),

(62,'chất lượng ','2023-08-23',5,14,54),

(63,'Giao hàng an toàn và nhanh chóng. Tôi đã nhận được','2023-10-02',4,22,17),

(64,'Sản phẩm nhận được đúng hẹn, không có gì để thấm sâu. Rất hài lòng nhé!','2023-02-02',5,21,16),

(65,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,45),

(66,'tệ','2023-05-17',1,21,45),

(67,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,53),

(68,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,15),

(69,'Cũm ổn á','2023-10-02',4,16,15),

(70,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,20),

(71,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,20),

(72,'chất lượng ','2023-08-23',5,14,53),

(73,'Giao hàng an toàn và nhanh chóng. Tôi đã nhận được','2023-10-02',4,22,20),

(74,'Sản phẩm nhận được đúng hẹn, không có gì để thấm sâu. Rất hài lòng nhé!','2023-02-02',5,21,20),

(75,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,20),

(76,'tệ','2023-05-17',1,21,20),

(77,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,27),

(78,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,27),

(79,'Cũm ổn á','2023-10-02',4,16,28),

(80,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,29),

(81,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,30),

(82,'chất lượng ','2023-08-23',5,14,21),

(83,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,30),

(84,'Giao hàng đúng hẹn và rau tươi ngon','2023-09-09',4,15,30),

(85,'chất lượng ','2023-08-23',5,14,30),

(86,'ngonc','2023-10-02',4,22,30),
(87,'Nhanh chóng và thuận tiện','2023-02-02',5,21,31),
(88,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,31),
(89,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,31),

(90,'Cũm ổn á','2023-10-02',4,16,31),

(91,'Dịch vụ đặt hàng trực tuyến tốt  ','2023-10-10',5,16,31),

(92,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,31),

(93,'chất lượng ','2023-08-23',5,14,31),

(94,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,32),

(95,'Giao hàng đúng hẹn và rau tươi ngon','2023-09-09',4,15,32),

(96,'chất lượng ','2023-08-23',5,14,32),

(97,'ngonc','2023-10-02',4,22,33),

(98,'Nhanh chóng và thuận tiện','2023-02-02',5,21,33),

(99,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,33),

(100,'tệ','2023-05-17',1,21,33),

(101,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,33),

(102,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,33),

(103,'Cũm ổn á','2023-10-02',4,16,34),

(104,'Dịch vụ đặt hàng trực tuyến tốt  ','2023-10-10',5,16,34),

(105,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,34),

(106,'chất lượng ','2023-08-23',5,14,34),

(107,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,35),

(108,'Giao hàng đúng hẹn và rau tươi ngon','2023-09-09',4,15,35),

(109,'chất lượng ','2023-08-23',5,14,35),

(110,'ngonc','2023-10-02',4,22,35),

(111,'Nhanh chóng và thuận tiện','2023-02-02',5,21,36),

(112,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,36),

(113,'tệ','2023-05-17',1,21,36),

(114,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,36),

(115,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,36),

(116,'Cũm ổn á','2023-10-02',4,16,36),

(117,'Dịch vụ đặt hàng trực tuyến tốt  ','2023-10-10',5,16,37),

(118,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,37),

(119,'chất lượng ','2023-08-23',5,14,37),



(120,'Giao hàng nhanh và an toàn ','2023-10-10',5,16,38),

(121,'Giao hàng đúng hẹn và rau tươi ngon','2023-09-09',4,15,38),

(122,'chất lượng ','2023-08-23',5,14,38),

(123,'ngonc','2023-10-02',4,22,38),

(124,'Nhanh chóng và thuận tiện','2023-02-02',5,21,39),

(125,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,39),

(126,'tệ','2023-05-17',1,21,39),

(127,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,40),

(128,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,40),

(129,'Cũm ổn á','2023-10-02',4,16,40),

(130,'Dịch vụ đặt hàng trực tuyến tốt  ','2023-10-10',5,16,41),

(131,'tôi đã nhận được sự đúng như tôi mong đợi','2023-09-09',4,15,42),

(132,'chất lượng ','2023-08-23',5,14,42),

(133,'Giao hàng an toàn và nhanh chóng. Tôi đã nhận được','2023-10-02',4,22,16),

(134,'Sản phẩm nhận được đúng hẹn, không có gì để thấm sâu. Rất hài lòng nhé!','2023-02-02',5,21,16),

(135,'Rất ấn tượng với chất lượng của sản phẩm. ','2023-01-01',4,19,16),

(136,'tệ','2023-05-17',1,21,17),

(137,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,17),

(138,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,17),

(139,'Cũm ổn á','2023-10-02',4,16,17),

(140,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,17),

(141,'tGiao hàng nhanh và an toàn ','2023-09-09',4,15,22),

(142,'chất lượng ','2023-08-23',5,14,25),

(143,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,26),

(144,'Giao hàng đúng hẹn và rau tươi ngon','2023-09-09',4,15,19),

(145,'chất lượng ','2023-08-23',5,14,19),

(146,'ngonc','2023-10-02',4,22,19),

(147,'mng đặt đuyyy oke lắm đấy nhé','2023-10-28',5,18,12),

(148,'đợt này sẵn phẩm không được tốt cho mấy hay shaooo á','2023-09-02',2,17,13),

(149,'Cũm ổn á','2023-10-02',4,16,14),

(150,'Giao hàng nhanh và an toàn, ','2023-10-10',5,16,15);
    
INSERT INTO Comments (CommentID, UserID, TourID, CommentText, CommentDate) VALUES
(1,1,1,'Trải nghiệm tại nông trại thật tuyệt vời.','2023-10-07'),
(2,3,2,'Gia đình tôi đã có kỷ niệm rất đẹp ở đây. Mọi thứ đều tốt, hướng dẫn viên của tour rất nhiệt tình...','2023-10-30'),
(3,1,3,'Mọi người đừng ngần ngại gì nữa booking đi tiền cho tuiiii','2023-08-16'),
(4,2,4,'Các hoạt động trồng rau, ... rất vui và thú vị, đồ ăn phục vụ rất vừa miệng','2023-10-14'),
(5,4,5,'Nào chán quá không biết làm gì, trống rỗng thì mọi người hãy thử đi tour GreenFarm nhé','2023-07-08'),
(6,5,6,'Có dịp tôi sẽ đi lần nữa','2023-07-26'),
(7,6,7,'Trải nghiệm tại nông trại thật tuyệt vời.','2023-10-04'),
(8,7,8,'Hẹn gặp GreenFarm vào dịp tới đây','2023-11-18'),
(9,8,9,'Tôi sẽ dẫn gia đình tới GreenFarm vào dịp tới','2023-09-02'),
(10,9,1,'Tôi thấy GreenFarm là một trải nghiệm tốt mà tôi có.. Rau ở đây rất tươi xanh và dinh dưỡng mọi người nên lấy sỉ ở đây để buôn bán ..','2023-10-04'),
(11,1,2,'Nếu mà mệt quá hãy về GreenFarm để nuôi cá và trồng thêm rau nhé kkkk','2023-10-09'),
(12,10,3,'Rất là vui nha mọi người','2023-06-04'),
(13,9,4,'Mong GreenFarm sẽ ngày càng phát triển nhé','2023-08-15'),
(14,3,5,'Tháng sau tôi sẽ dần lũ bạn đi cùng','2023-10-14'),
(15,1,6,'Trải nghiệm tại nông trại thật tuyệt vời.','2023-07-09'),
(16,5,7,'Tôi muốn xin info chị dẫn tour quá!','2023-07-26'),
(17,7,8,'Đó là một câu chuyện dài cho cuộc tour này. Hay và ý nghĩa','2023-10-07'),
(18,7,9,'Hiện tại GreenFarm chưa được mọi người biết đến nhiều. Mong GreenFarm sẽ được nhiều người biết tới thật sự quá tuyệt vời!!!','2023-10-07'),
(19,5,1,'Trải nghiệm tại nông trại thật tuyệt vời.','2023-10-07'),
(20,9,4,'Trải nghiệm tại nông trại thật tuyệt vời.','2023-10-07'),
(21,5,10,'các anh chị hướng dẫn viễn rất dễ thương luôn áaaaaaaa','2023-1-1'),
(22,9,11,'Rất xứng đáng để trải nghiệm nha','2022-12-31'),
(23,3,10,'10 điểm nha ','2023-1-1'),
(24,4,11,'Đi không muốn về luôn í','2022-12-31'),
(25,9,9,'các anh chị hướng dẫn viễn rất dễ thương luôn áaa','2023-1-1'),
(26,9,8,'Rất xứng đáng để trải nghiệm nha','2022-12-31'),
(27,8,1,'các anh chị hướng dẫn viễn rất dễ thương luôn áaaaaaaa','2023-1-1'),
(28,3,2,'Rất xứng đáng để trải nghiệm nha','2022-12-31'),

(29,1,1, 'Tour thật sự tuyệt vời! Khám phá những địa điểm đẹp và ấn tượng.','2023-1-1'),
(30,2,2, 'Hướng dẫn viên rất nhiệt tình và am hiểu. Điều này làm cho chuyến đi trở nên đặc biệt.','2022-12-31'),
(31,3,3, 'Hướng dẫn viên rất nhiệt tình và am hiểu. Điều này làm cho chuyến đi trở nên đặc biệt.','2023-1-1'),
(32,4,4, 'Chất lượng dịch vụ xuất sắc. Tôi đã có một trải nghiệm tuyệt vời.','2022-12-31'),
(33,5,5, 'Nhóm du lịch vui vẻ và hòa đồng. Tạo nên một không khí thoải mái.','2023-1-1'),
(34,6,6, 'Chuyến đi này làm cho tôi yêu thêm về văn hóa địa phương và lịch sử.','2022-12-31'),
(35,7,7, 'Cảm ơn đội ngũ hỗ trợ. Họ đã làm cho chuyến đi của tôi trở nên trọn vẹn.','2023-1-1'),
(36,8,8, 'Địa điểm độc đáo và không gian tự nhiên tuyệt vời. Không thể tin được tôi đã được trải nghiệm điều này.','2022-12-31'),
(37,9,9, 'Tôi đã thích thú với mọi điều từ đầu đến cuối. Chắc chắn sẽ giới thiệu cho bạn bè.','2023-1-1'),
(38,10,10, 'Một trải nghiệm đáng nhớ. Tôi đã học được nhiều điều mới.','2023-1-1'),
(39,11,11, 'Cảm ơn đội ngũ hỗ trợ. Họ đã làm cho chuyến đi của tôi trở nên trọn vẹn.','2023-1-1'),

(40,11,1, ' Tôi hạnh phúc vì đã lựa chọn tour này.','2023-1-1'),
(41,10,2, ' Chương trình hợp lý, không quá chật chội và không quá lỏng lẻo.','2022-12-31'),
(42,9,3, ' Tôi thực sự ấn tượng với sự chuyên nghiệp của đội ngũ hướng dẫn.','2023-1-1'),
(43,8,4, ' Cảm ơn tour đã mang lại cho tôi những kỷ niệm đẹp.','2022-12-31'),
(45,7,5, ' Chuyến đi này là một cơ hội tuyệt vời để khám phá.','2023-1-1'),
(46,6,6, ' Tôi sẽ quay lại với tour khác của công ty này.','2022-12-31'),
(47,5,7, ' Hỗ trợ khách hàng rất tốt từ đội ngũ tổ chức tour.','2023-1-1'),
(48,4,8, ' Tour này giúp tôi thư giãn và nghỉ ngơi thực sự.','2022-12-31'),
(49,3,9, ' Tôi không thể tin nổi rằng giá tour lại hợp lý như vậy.','2023-1-1'),
(50,2,10, ' Tour này thật sự tuyệt vời!','2023-1-1'),
(51,1,11, ' Tôi hạnh phúc vì có cơ hội tham gia chuyến đi này.','2023-1-1');

INSERT INTO ReComments (CommentID, UserID, ReCommentText, ReCommentDate) VALUES
(1,11,'Cảm ơn bạn,chúc gia đình bạn nhiều sức khỏe ạ','2023-10-07'),
(10,11,'Cảm ơn bạn,chúc gia đình bạn nhiều sức khỏe ạ.','2023-10-07'),
(19,11,'Cảm ơn bạn,chúc gia đình bạn nhiều sức khỏe ạ.','2023-10-07'),
(2,11,'Cảm ơn bạn,chúc gia đình bạn nhiều sức khỏe ạ','2023-10-07'),
(11,11,'Cảm ơn bạn,chúc gia đình bạn nhiều sức khỏe ạ.','2023-10-07'),
(7,11,'Cảm ơn bạn,chúc gia đình bạn nhiều sức khỏe ạ.','2023-10-07'),
(16,11,'Ê!!!!! ẩu rồi đó ba =))','2023-10-07');


INSERT INTO Vouchers (Code, Discount,ExpirationDate) VALUES 
('sG6hKf9LpR',0.05,'2024-03-01'),
('2fR4EgKlHJ',0.10,'2024-03-01'),
('qD3MwN6TbK',0.15,'2024-03-01'),
('8JhN5kPfTQ',0.20,'2024-03-01'),
('GREENFARMF88',0.50,'2024-03-01');

INSERT INTO VoucherUsers (UserID, ExpirationDate, VoucherID) VALUES 
(1, '2023-12-14 06:00:00', 1),
(1, '2023-12-14 06:00:00', 2),
(1, '2023-12-14 06:00:00', 3),
(1, '2023-12-14 06:00:00', 4),
(2, '2023-12-14 06:00:00', 1),
(2, '2023-12-14 06:00:00', 2),
(2, '2023-12-14 06:00:00', 4),
(3, '2023-12-14 06:00:00', 1),
(3, '2023-12-14 06:00:00', 2),
(4, '2023-12-14 06:00:00', 1),
(5, '2023-12-14 06:00:00', 1),
(6, '2023-12-14 06:00:00', 1),
(7, '2023-12-14 06:00:00', 1),
(7, '2023-12-14 06:00:00', 2),
(8, '2023-12-14 06:00:00', 1),
(9, '2023-12-14 06:00:00', 1),
(10, '2023-12-14 06:00:00', 1);

INSERT INTO TourDateBookings (TourdateBookingID, TourDateID, BookingID) VALUES
(1,1,1),
(2,1,2),
(3,3,3),
(4,4,4),
(5,5,5),
(6,6,6),
(7,7,7),
(8,8,8),
(9,9,9),
(10,10,10),
(11,11,11),
(12,12,12),
(13,13,13),
(14,14,14),
(15,15,15),
(16,16,16),
(17,17,17),
(18,18,18),
(19,19,19),
(20,20,20),
(21,21,21),
(22,23,22),
(23,24,23),
(24,25,24),
(25,26,25),
(26,27,60),
(27,28,141),
(28,29,142),
(29,30,143),
(30,31,144),
(31,32,145),
(32,33,146),
(33,2,147),
(34,3,148),
(35,3,149),
(36,7,150),
(37,8,151),
(38,7,152),
(39,5,153),
(40,2,154),
(41,9,155),
(42,22,156),
(43,23,157),
(44,25,158),
(45,21,159),
(46,16,160),
(47,17,161),
(48,22,162),
(49,18,163),
(50,31,164);



-- SELECT td.tourdates, COALESCE(SUM(b.Adultticketnumber + b.Childticketnumber), 0) AS totalTickets
-- FROM TourDates td
-- LEFT JOIN TourDateBookings tdb ON td.tourdateid = tdb.tourdateid
-- LEFT JOIN Bookings b ON tdb.bookingid = b.bookingid
-- WHERE td.tourid = 4 AND td.tourdates BETWEEN '2023-12-01' AND '2023-12-31'
-- GROUP BY td.tourdates
-- ORDER BY td.tourdates;


-- SELECT t.tourid, t.tourname, COUNT(b.bookingid) AS totalBookings
-- FROM Tours t
-- LEFT JOIN Bookings b ON t.tourid = b.tourid
-- GROUP BY t.tourid, t.tourname
-- ORDER BY totalBookings DESC
-- LIMIT 5;

-- -- Thống kê số lượng vé đã đặt cho một ngày cụ thể của một tour
-- SELECT 
--     COUNT(DISTINCT b.bookingid) AS total_bookings,
--     SUM(b.Adultticketnumber) AS total_adult_tickets,
--     SUM(b.Childticketnumber) AS total_child_tickets
-- FROM
--     TourDates td
-- JOIN 
--     TourDateBookings tdb ON td.tourdateid = tdb.tourdateid
-- JOIN
--     Bookings b ON tdb.bookingid = b.bookingid
-- JOIN
--     StatusBookings sb ON b.statusbookingid = sb.statusbookingid
-- WHERE
--     DATE(td.tourdates) = "2023-12-03"
--     AND sb.name = "Đặt tour thành công";

--    

-- SELECT
--     t.tourid,
--     t.tourname,
--     td.tourdates,
--     p.adultprice,
--     p.childprice
-- FROM Tours t
-- JOIN Tourdates td ON t.tourid = td.tourid
-- LEFT JOIN Tourdatebookings tdb ON td.tourdateid = tdb.tourdateid
-- LEFT JOIN Bookings b ON tdb.bookingid = b.bookingid
-- LEFT JOIN Pricings p ON t.tourid = p.tourid
-- WHERE
--     t.tourid = 9
--     AND td.tourdates = '2023-12-17'
-- ORDER BY b.bookingdate ASC;




