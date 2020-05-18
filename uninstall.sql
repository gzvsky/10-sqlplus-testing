-- выкл отображение замены переменных
set verify off
-- считываем версию патча
@services/patch_ver.sql

-- спулим в файл
spool uninstall_patch_num_&patch_num..log replace

-- описание приложения
set appinfo 'UnInstall Script Oracle patch &patch_num'

-- при возникновении ошибки идем дальше
whenever sqlerror continue

-- заголовок
@@services/title.sql

-- вывод системной инфы
@@services/banner.sql

prompt ================

---- удаляются объекты
prompt drop package test_client_pkg;
drop package test_client_pkg;

prompt drop package client_pkg;
drop package client_pkg;

prompt drop trigger client_b_iu;
drop trigger client_b_iu;

prompt drop sequence client_seq;
drop sequence client_seq;

prompt drop table client;
drop table client;

prompt ================
prompt 
prompt Patch was successfull uninstalled :)

-- отрубаем спулл
spool off

exit;