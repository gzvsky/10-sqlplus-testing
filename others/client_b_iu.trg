create or replace trigger client_b_iu
before insert or update or delete
on client for each row
declare
begin
    client_pkg.prevent_direct_change;
end;
/