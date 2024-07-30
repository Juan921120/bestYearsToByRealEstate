-- ALTER TABLE rate RENAME COLUMN 日期 to rate_date;
-- ALTER TABLE rate RENAME COLUMN 最高值 TO high_value;
-- ALTER TABLE rate RENAME COLUMN 最低值 TO low_value;
alter table rate
modify column high_value decimal(10,5),
modify column low_value decimal(10,5);

-- 2009-2024数据处理
ALTER TABLE rate
ADD COLUMN avg DECIMAL(10,5)
UPDATE rate SET avg=(high_value + low_value)/2;
SELECT * FROM rate;

-- 年平均汇率 一日元兑换人民币
SELECT YEAR(rate_date) AS ryear,
AVG(avg) AS year_avg
FROM rate
GROUP BY ryear
ORDER BY ryear ASC
;

-- 年平均地价
UPDATE  land SET land_avg=1813926 WHERE year=2024; -- 2024年特殊处理 原本没有值
SELECT* FROM land;

-- 每年 200万人民币可以买多少平东京的房子
WITH rate2 AS(
	SELECT 
		YEAR(rate_date) AS r_year,
		AVG(avg) AS rate_avg
	FROM rate
	GROUP BY r_year
)
SELECT  rate2.r_year 年份 ,
(2000000/rate_avg) 日元,
land.land_avg 年平均地价,
ROUND((2000000/rate_avg)/land.land_avg ,2) 面积
FROM rate2
JOIN land
WHERE rate2.r_year=land.`year`;

-- 同比增长率
SELECT
	a.r_year 年份,
	a.rate_avg 平均汇率,
	land.land_avg 平均地价,
	abs(a.rate_avg-lag(a.rate_avg,1,0) over(ORDER BY a.r_year))/lag(a.rate_avg,1,0) over(ORDER BY a.r_year) 汇率年同比增长率,
	abs(land.land_avg-lag(land.land_avg,1,0)over(ORDER BY land.`year`))/lag(land.land_avg,1,0)over(ORDER BY land.`year` ) 地价同比增长率
FROM
 (
	SELECT 
		YEAR(rate_date) AS r_year,
		AVG(avg) AS rate_avg
	FROM rate
	GROUP BY r_year
)a
JOIN
	land
WHERE
	a.r_year=land.`year`
;