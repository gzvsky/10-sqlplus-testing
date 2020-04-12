-- Запретить прямой DML таблицы client
create or replace trigger client_b_iu
before insert or update on client for each row
declare
begin
    client_pkg.prevent_direct_change;
end;
/