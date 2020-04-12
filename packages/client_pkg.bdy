create or replace package body client_pkg is

    g_is_api boolean:= false;

    -- Добавление нового клиента
    function createClient(pi_first_name client.c_first_name%type, pi_last_name client.c_last_name%type, pi_middle_name client.c_middle_name%type, pi_gender client.c_gender%type, pi_birth_date client.c_birth_date%type, pi_autocommit boolean := false) return client.c_id%type
        is
        v_id client.c_id%type;
    begin
        g_is_api := true;

        v_id := client_seq.nextval;
        insert into client values (v_id, pi_first_name, pi_last_name, pi_middle_name, pi_gender, pi_birth_date, sysdate, sysdate);

        if pi_autocommit then
            commit;
        end if;

        g_is_api := false;

        return v_id;

        exception
        when others then
            g_is_api := false;
            raise;
    end;

    -- Обновление клиента
    function updateClient(pi_client_id client.c_id%type, p_visit_date client.c_last_visit_date%type, pi_autocommit boolean := false) return client.c_id%type
        is
    begin
        g_is_api := true;

        update client set c_last_visit_date = p_visit_date where c_id = pi_client_id;

        if pi_autocommit then
            commit;
        end if;

        g_is_api := false;

        return pi_client_id;

        exception
        when no_data_found then
            raise_application_error(-20500, 'Такого клиента не существует');
        when others then
            g_is_api := false;
            raise;
    end;

    -- Удаление клиента
    function deleteClient(pi_client_id client.c_id%type, pi_autocommit boolean := false) return client.c_id%type
        is
        v_id client.c_id%type;
    begin
        g_is_api := true;

        delete from client where c_id = pi_client_id returning c_id into v_id;
        if (v_id is null) then
            raise_application_error(-20500, 'Такого клиента не существует');
        end if;

        if pi_autocommit then
            commit;
        end if;

        g_is_api := false;

        return v_id;

        exception
        when others then
            g_is_api := false;
            raise;
    end;

    procedure prevent_direct_change is
    begin
        if not g_is_api then
            raise_application_error(-20500, 'Прямое изменение запрещено. Только через API пакета client_pkg');
        end if;
    end;

end;
/