-- 创建地价表
CREATE TABLE landprice (
  date_ DATE,
  values_ DECIMAL(10, 9)
);


-- 创建汇率表
-- "日付け","終値","始値","高値","安値","出来高(交易量)","変化率 %"
CREATE TABLE rate(
    date DATE NOT NULL PRIMARY KEY,
    close_price DECIMAL(10, 5),
    open_price DECIMAL(10, 5),
    high_price DECIMAL(10, 5),
    low_price DECIMAL(10, 5),
    volume INT DEFAULT NULL,
    change_rate_percent DECIMAL(5, 2)
);

-- 可读写配置目录
show variables like '%secure%'; -- 有权限的读写地址
SHOW VARIABLES LIKE 'secure_file_priv'; -- 有权限的读写地址
SHOW VARIABLES LIKE 'local_infile'; -- 写入权限
set global local_infile=on;
SHOW GRANTS FOR CURRENT_USER;-- 用户权限




-- 导入数据
load data infile 'C:/Users/juan/Downloads/JPY_CNY.csv' 
INTO TABLE rate
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(date, close_price, open_price, high_price, low_price, volume, change_rate_percent);



SELECT * FROM rate LIMIT 30;
