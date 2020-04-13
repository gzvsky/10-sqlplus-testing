-- выкл отображение замены переменных
set verify off
-- считываем версию патча
@services/patch_ver.sql

-- спулим в файл
spool install_patch_num_&patch_num..log replace

-- описание приложения
set appinfo 'Install Script Oracle patch &patch_num'

-- при возникновении ошибки выходим
whenever sqlerror exit failure
-- Handling OS errors (например - неверный путь) 
whenever oserror exit

-- заголовок
@@services/title.sql

-- вывод системной инфы
@@services/banner.sql

-- отключение считывания символов &
set define off

prompt ================
-------- объекты --------

-- другое - до установки
prompt >>>> others/_before.sql
prompt 
@@others/_before.sql

-- таблицы
prompt >>>> tables/_tables.sql
prompt 
@tables/_tables.sql

-- пакеты
prompt >>>> packages/_packages.sql
prompt 
@packages/_packages.sql

-- данные
-- интересно время выполнения команд
set timing on
prompt >>>> data/_data.sql
prompt 
@@data/_data.sql
set timing off

-- другое - после установки
prompt >>>> others/_after.sql
@@others/_after.sql

-- tests 
prompt >>>> tests/_tests.sql
@@tests/_tests.sql

prompt ================
prompt 
prompt Patch was successfull installed :)

-- отрубаем спулл
spool off

exit;