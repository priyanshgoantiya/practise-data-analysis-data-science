SELECT * FROM laptopdata;

SELECT * FROM laptopdata;

CREATE TABLE laptop_backup LIKE laptopdata;

INSERT INTO laptop_backup
SELECT * FROM laptopdata;

SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'laptop'
AND TABLE_NAME = 'laptopdata';

SELECT * FROM laptopdata;

ALTER TABLE laptopdata DROP COLUMN `Unnamed: 0`;

SELECT * FROM laptopdata;

DELETE FROM laptopdata
WHERE `index` IN (SELECT `index` FROM laptopdata
WHERE Company IS NULL AND TypeName IS NULL AND Inches IS NULL
AND ScreenResolution IS NULL AND Cpu IS NULL AND Ram IS NULL
AND Memory IS NULL AND Gpu IS NULL AND OpSys IS NULL AND
WEIGHT IS NULL AND Price IS NULL);

ALTER TABLE laptopdata MODIFY COLUMN Inches DECIMAL(10,1);

SELECT * FROM laptopdata;

UPDATE laptopdata l1
SET Ram = REPLACE(Ram,'GB','') ;

SELECT * FROM laptopdata;

ALTER TABLE laptopdata MODIFY COLUMN Ram INTEGER;

SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'laptop'
AND TABLE_NAME = 'laptopdata';

UPDATE laptopdata l1
SET Weight = REPLACE(Weight,'kg','') ;
		   
           
SELECT * FROM laptopdata;

UPDATE laptopdata l1
SET Price = ROUND(Price) ;
            
ALTER TABLE laptopdata MODIFY COLUMN Price INTEGER;

SELECT DISTINCT OpSys FROM laptopdata;

-- mac
-- windows
-- linux
-- no os
-- Android chrome(others)

SELECT OpSys,
CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END AS 'os_brand'
FROM laptopdata;

UPDATE laptopdata
SET OpSys = 
CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
    WHEN OpSys LIKE 'windows%' THEN 'windows'
    WHEN OpSys LIKE '%linux%' THEN 'linux'
    WHEN OpSys = 'No OS' THEN 'N/A'
    ELSE 'other'
END;

-- GPU
alter table laptopdata
add column Gpu_brand varchar(30) after gpu,
add column Gpu_name varchar(30) after gpu_brand;

update laptopdata
set Gpu_brand= substring_index(Gpu,' ',1);

update laptopdata
set Gpu_name= replace(gpu,Gpu_brand,'');

select * from laptopdata;

alter table laptopdata
drop column Gpu;

-- cpu 
alter table laptopdata
add column cpu_brand varchar(255),add column cpu_name varchar(255),add column cpu_speed varchar(255);

alter table laptopdata
modify cpu_speed decimal(10,1) ;

update laptopdata
set cpu_brand=substring_index(cpu,' ',1);

update laptopdata
set cpu_speed=cast(replace(substring_index(cpu,' ',-1),'GHz','') as decimal);

update laptopdata
set  cpu_name= replace(replace(cpu,cpu_brand,''),substring_index(replace(cpu,cpu_brand,''),' ',-1),'');

select * from laptopdata;

select substring_index(replace(cpu,cpu_brand,''),' ',-1) 
from laptopdata;

alter table laptopdata
drop column cpu;

-- ScreenResolution

select ScreenResolution,substring_index(substring_index(ScreenResolution,' ',-1),'x',1),
substring_index(substring_index(ScreenResolution,' ',-1),'x',-1)
from laptopdata;

alter table laptopdata
add column resolution_width int after ScreenResolution,add column resolution_height int after resolution_width;

update laptopdata
set resolution_width = substring_index(substring_index(ScreenResolution,' ',-1),'x',1);

update laptopdata
set resolution_height = substring_index(substring_index(ScreenResolution,' ',-1),'x',-1);

select * from laptopdata;

alter table laptopdata
add column touchscreen int after resolution_height;

update laptopdata
set touchscreen= 
case 
    when ScreenResolution like '%touchscreen%' then 1 else 0  end;
    
SELECT DISTINCT
  TRIM(
    SUBSTRING_INDEX(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(screenresolution, 'IPS Panel ', ''),
              'Retina Display ', ''
            ),
            'Full HD ', ''
          ),
          'Touchscreen ', ''
        ),
        '/ ', ' '
      ),
      ' ',
      1
    )
  ) AS cleaned_resolution
FROM laptopdata;

alter table laptopdata
drop column ScreenResolution;
-- cpu_name 
select cpu_name , substring_index(trim(cpu_name),' ',2)
from laptopdata;

	update laptopdata
	set cpu_name= substring_index(trim(cpu_name),' ',2);

select * from laptopdata;

-- Memory column 

alter table laptopdata
add column Memory_type int after Memory,add column primary_memory  int after Memory_type,
add column secondary_memory int after primary_memory;

alter table laptopdata
modify Memory_type varchar(256);

select Memory,
case 
    when Memory like '%SSD%' and Memory like '%HDD%' then 'hybrid' 
    when Memory like '%SSD%' then 'SSD' 
    when Memory like '%HDD%' then 'HDD'
    when Memory like '%flash storage%' then 'flash storage'
    when Memory like '%flash storage%' and Memory like '%HDD%' then 'hybrid' 
    else null
end as Memory_type
from  laptopdata;

update laptopdata
set Memory_type= case 
    when Memory like '%SSD%' and Memory like '%HDD%' then 'hybrid' 
    when Memory like '%SSD%' then 'SSD' 
    when Memory like '%HDD%' then 'HDD'
    when Memory like '%flash storage%' then 'flash storage'
    when Memory like '%flash storage%' and Memory like '%HDD%' then 'hybrid' 
    else null
end ;

select * from laptopdata;
    
select Memory, regexp_substr(substring_index(Memory,'+',1),'[0-9]+'),
case when memory like "%+%" then regexp_substr(substring_index(Memory,'+',-1),'[0-9]+') else 0 end
from laptopdata;

update laptopdata
set primary_memory=regexp_substr(substring_index(Memory,'+',1),'[0-9]+'),
secondary_memory=case when memory like "%+%" then regexp_substr(substring_index(Memory,'+',-1),'[0-9]+') else 0 end;

select primary_memory, case when primary_memory <=2 then primary_memory*1024 else primary_memory end 
from laptopdata;

update laptopdata
set primary_memory= case when primary_memory <=2 then primary_memory*1024 else primary_memory end ;

alter table laptopdata
drop column memory;

-- gpu_name 
alter table laptopdata
drop column Gpu_name;

select * from laptopdata;
    
-- final check 
SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'laptop'
AND TABLE_NAME = 'laptopdata';


    
    
    
    
    
    


    












